//
//  OpenRequestsCDTVC.m
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "OpenRequestsCDTVC.h"
#import "MakeRequestViewController.h"

@interface OpenRequestsCDTVC ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addNewRequestButton;

@end

@implementation OpenRequestsCDTVC
- (IBAction)addNewRequest:(UIBarButtonItem *)sender {
    // show suggested results
    
}
- (IBAction)fetchRequests:(UIRefreshControl *)sender {
    [Request addAllRequestsInvolvingUser:self.currentUser];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)setupFetchedResultsController
{
    NSLog(@"open request setup");
    NSManagedObjectContext *context = self.currentUser.managedObjectContext;
    if (context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Request"];
        request.predicate = [NSPredicate predicateWithFormat:@"(toID = %@ or fromID = %@) and status=%@", self.currentUser.userID, self.currentUser.userID, OPEN_STATUS];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sentDate" ascending:NO];        
        request.sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:context
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (void)prepareViewController:(id)vc
                     forSegue:(NSString *)segueIdentifer
                fromIndexPath:(NSIndexPath *)indexPath
{
    Request *req = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // get id of other person involved in the request
    NSString *cxnID = [req.toID isEqualToString:self.currentUser.userID] ? req.fromID : req.toID;
    User *cxn = [User getUserWithID:cxnID inManagedObjectContext:self.currentUser.managedObjectContext];
    if ([vc isKindOfClass:[MakeRequestViewController class]]) {
        MakeRequestViewController *mrvc = (MakeRequestViewController *)vc;
        mrvc.currentUser = self.currentUser;
        mrvc.connection = cxn;
        mrvc.title = @"View Connection";
        mrvc.newRequest = NO;
        mrvc.request = req;
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

- (NSString *) getDetailedTextForRequest:(Request *)request {
    return request.toUser.userID == self.currentUser.userID ? request.fromUser.headline : request.toUser.headline;
}


@end
