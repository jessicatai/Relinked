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

@interface RequestsCDTVC ()

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
    NSLog(@"detailed text %@", cell.detailTextLabel.text);
    
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
    NSString *date = [RelinkedStanfordServerRequest convertDateToString:request.sentDate];
    [Request addNewRequestFromUserID:request.fromUser.userID toUserID:request.toUser.userID withAction:action withStatus:status withDate:date inManagedObjectContext:request.managedObjectContext];
}

-(void) deleteRequestWithIndexPath:(NSIndexPath *)indexPath {
    Request *request = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [Request deleteRequest:request];
}

@end
