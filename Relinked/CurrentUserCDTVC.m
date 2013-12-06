//
//  CurrentUserCDTVC.m
//  Relinked
//
//  Created by Jessica Tai on 12/4/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CurrentUserCDTVC.h"

@interface CurrentUserCDTVC ()

@end

@implementation CurrentUserCDTVC

- (void) setCurrentUser:(User *)currentUser
{
    _currentUser = currentUser;
    self.debug = YES;
    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated { // TODO: change to view did load?
    [self setupFetchedResultsController];
    [self.tableView reloadData];
}

// abstract
- (void) setupFetchedResultsController {
}

@end
