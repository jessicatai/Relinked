//
//  SuggestionsCDTVC.m
//  Relinked
//
//  Created by Jessica Tai on 12/4/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SuggestionsCDTVC.h"
#import "MakeRequestViewController.h"
#import "Request+Relinked.h"

@interface SuggestionsCDTVC ()

@end

@implementation SuggestionsCDTVC
- (IBAction)changeSearchFilters:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//- (void) setCurrentUser:(User *)currentUser
//{
//    _currentUser = currentUser;
//    self.debug = YES;
//    [self setupFetchedResultsController];
//}

- (void)setupFetchedResultsController
{
    NSLog(@"Suggestions request set up; 1st cxn %@", [[self.currentUser.connections allObjects] firstObject]);
    NSManagedObjectContext *context = self.currentUser.managedObjectContext;
    if (context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        // ignore places where we do not have the region name
        NSArray *interestedIndustries = [self.currentUser.interestedIndustries componentsSeparatedByString:RELINKED_DELIMITER];
        request.predicate = [NSPredicate predicateWithFormat:@"industry IN %@ and thumbnailURL != nil", interestedIndustries];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"userID"
                                                                  ascending:NO
                                                                   selector:@selector(localizedStandardCompare:)]];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:context
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Connection Cell"];
    
    User *cxn = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",cxn.firstName, cxn.lastName];
    cell.detailTextLabel.text = cxn.headline;
    
    cell.imageView.image = [UIImage imageWithData:cxn.thumbnailData];
    // fetch thumbnail data, only if there is a thumbnail to fetch, if have not requested before
    if (!cell.imageView.image && !cxn.thumbnailData) {
        dispatch_queue_t q = dispatch_queue_create("Connection Photo Thumbnail", 0);
        dispatch_async(q, ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:cxn.thumbnailURL]];
            [cxn.managedObjectContext performBlock:^{
                cxn.thumbnailData = imageData;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell setNeedsLayout];
                });
            }];
        });
    }
    
    // display a checkmark if there's already an open request for this connection
    if ([Request allRequestsInvolvingUser:cxn withStatus:@"open"]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)prepareViewController:(id)vc
                     forSegue:(NSString *)segueIdentifer
                fromIndexPath:(NSIndexPath *)indexPath
{
    User *connection = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([vc isKindOfClass:[MakeRequestViewController class]]) {
        MakeRequestViewController *mrvc = (MakeRequestViewController *)vc;
        mrvc.currentUser = self.currentUser;
        mrvc.connection = connection;
        mrvc.title = @"Relink Request";
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    [self prepareViewController:segue.destinationViewController
                       forSegue:segue.identifier
                  fromIndexPath:indexPath];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detailvc = [self.splitViewController.viewControllers lastObject];
    if ([detailvc isKindOfClass:[UINavigationController class]]) {
        detailvc = [((UINavigationController *)detailvc).viewControllers firstObject];
        [self prepareViewController:detailvc
                           forSegue:nil
                      fromIndexPath:indexPath];
    }
}

@end
