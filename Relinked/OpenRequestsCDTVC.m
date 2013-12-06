//
//  OpenRequestsCDTVC.m
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "OpenRequestsCDTVC.h"

@interface OpenRequestsCDTVC ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addNewRequestButton;

@end

@implementation OpenRequestsCDTVC
- (IBAction)addNewRequest:(UIBarButtonItem *)sender {
    // show suggested results
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // show accept or ignore buttons
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
}


@end
