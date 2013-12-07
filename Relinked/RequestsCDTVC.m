//
//  RequestsCDTVC.m
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "RequestsCDTVC.h"
#import "OpenRequestsCDTVC.h"
#import "OpenRequestTableViewCell.h"

@interface RequestsCDTVC () <MFMailComposeViewControllerDelegate>

@end

@implementation RequestsCDTVC

- (void) viewDidLoad {
    [self.tableView registerNib:[UINib nibWithNibName:@"OpenRequestTableCell" bundle:nil] forCellReuseIdentifier:@"Open Request Cell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    CustomTableViewCell *cell;
    Request *request = [self.fetchedResultsController objectAtIndexPath:indexPath];
    User *connection = [request.toID isEqualToString:self.currentUser.userID] ? [User getUserWithID:request.fromID inManagedObjectContext:self.currentUser.managedObjectContext] : [User getUserWithID:request.toID inManagedObjectContext:self.currentUser.managedObjectContext];
    
    if ([request.toID isEqualToString:self.currentUser.userID] && [request.status isEqualToString:OPEN_STATUS]) { // request sent to current user
        cellIdentifier = @"Open Request Cell";
        cell = (OpenRequestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        OpenRequestTableViewCell *openReqCell = (OpenRequestTableViewCell *)cell;
//        openReqCell.cdtvc = self; // give cdtvc for accept/ignore buttons
//        cell = openReqCell;
    } else { // current user sent the request
        cellIdentifier = @"Request Cell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    cell.cdtvc = self;
    
    
    NSString *connectionName = [NSString stringWithFormat:@"%@ %@", connection.firstName, connection.lastName];

    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",[request.toID isEqualToString:self.currentUser.userID ] ? @"FROM": @"TO", connectionName];
    cell.detailTextLabel.text = [self getDetailedTextForRequest:request];
    
    cell.imageView.image = [UIImage imageWithData:connection.thumbnailData];
    // fetch thumbnail data, only if there is a thumbnail to fetch, if have not requested before
    if (!cell.imageView.image && !connection.thumbnailData) {
        dispatch_queue_t q = dispatch_queue_create("Request Connection Photo Thumbnail", 0);
        dispatch_async(q, ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:connection.thumbnailURL]];
            [connection.managedObjectContext performBlock:^{
                connection.thumbnailData = imageData;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell setNeedsLayout];
                    [tableView reloadData];
                });
            }];
        });
    }
    
    return cell;
}

// custom height for dynamic cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

// abstract
- (NSString *) getDetailedTextForRequest:(Request *)request {
    return nil;
}

-(void) updateRequestWithIndexPath:(NSIndexPath *)indexPath forAction:(NSString *) action forStatus:(NSString *)status{
    Request *request = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // hack to counter for off-by-one error when getting indexpath from cell :[
    if ([status isEqualToString:@"accept"]) {
        [self prepForEmailForIndexPath:indexPath];
    }
    
    NSString *date = [RelinkedStanfordServerRequest convertDateToString:request.sentDate];
    [Request addNewRequestFromUserID:request.fromUser.userID toUserID:request.toUser.userID withAction:action withStatus:status withDate:date inManagedObjectContext:request.managedObjectContext];
}

-(void) deleteRequestWithIndexPath:(NSIndexPath *)indexPath {
    Request *request = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [Request deleteRequest:request];
}

-(Request *) requestForIndexPath:(NSIndexPath *) indexPath {
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}


# pragma mark mail
- (void) prepForEmailForIndexPath:(NSIndexPath *)indexPath {
    Request *request = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([request.fromUser.userID isEqualToString:self.currentUser.userID]) {
        // this is an error state
        return;
    }
    // can only accept requests sent to you, so get from user info
    User *fromUser = request.fromUser;
    
    // Email Subject
    NSString *emailTitle = @"Relinked Request Accepted";
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"Hi %@,\n\nSaw your request on Relink and would love to meet up with you! \n\n- %@ %@", fromUser.firstName, self.currentUser.firstName, self.currentUser.lastName];
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:fromUser.email];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    mc.title = @"Request Accepted";
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
