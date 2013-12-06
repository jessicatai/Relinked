//
//  CurrentUserCDTVC.h
//  Relinked
//
//  Created by Jessica Tai on 12/4/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "User+LinkedIn.h"

@interface CurrentUserCDTVC : CoreDataTableViewController

@property (nonatomic, strong) User *currentUser;

- (void) setupFetchedResultsController; // abstract

@end
