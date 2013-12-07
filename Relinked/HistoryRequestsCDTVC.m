//
//  HistoryRequestsCDTVC.m
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "HistoryRequestsCDTVC.h"

@interface HistoryRequestsCDTVC ()

@end

@implementation HistoryRequestsCDTVC

- (void)setupFetchedResultsController
{
    NSLog(@"open request setup");
    NSManagedObjectContext *context = self.currentUser.managedObjectContext;
    if (context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Request"];
        request.predicate = [NSPredicate predicateWithFormat:@"(toID = %@ or fromID = %@) and status !=%@", self.currentUser.userID, self.currentUser.userID, OPEN_STATUS];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"acceptDate" ascending:NO];
        request.sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:context
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (NSString *) getDetailedTextForRequest:(Request *)request {
    if ([request.status isEqualToString:ACCEPT_STATUS]) {
        return @"Accepted";
    } else {
        return @"Ignored";
    }
}
@end
