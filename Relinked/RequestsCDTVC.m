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
    UITableViewCell *cell;
    Request *request = [self.fetchedResultsController objectAtIndexPath:indexPath];
    User *connection;
    NSLog(@"request to id %@, current user id %@", request.toID, self.currentUser.userID);
    if ([request.toID isEqualToString:self.currentUser.userID ]) { // request sent to current user
        cellIdentifier = @"Open Request Cell";
        cell = (OpenRequestTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        connection = [User getUserWithID:request.fromID inManagedObjectContext:self.currentUser.managedObjectContext];
    } else { // current user sent the request
        cellIdentifier = @"Request Cell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        connection = [User getUserWithID:request.toID inManagedObjectContext:self.currentUser.managedObjectContext];
    }
    
    
    
    NSString *connectionName = [NSString stringWithFormat:@"%@ %@", connection.firstName, connection.lastName];

    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",[request.toID isEqualToString:self.currentUser.userID ] ? @"FROM": @"TO", connectionName];
    cell.detailTextLabel.text = connection.headline;
    
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
    cell.selected = NO;
    return cell;
}

// custom height for dynamic cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

@end
