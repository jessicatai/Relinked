//
//  SettingsViewController.m
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SettingsViewController.h"
#import "LinkedInDatabaseAvailability.h"
#import "RelinkedUserDefaults.h"
#import "User+LinkedIn.h"
#import "Request+Relinked.h"

#import "IndustryTVC.h"

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property(weak, nonatomic) User *currentUser;
@end

@implementation SettingsViewController

- (void) awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:LinkedInDatabaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = note.userInfo[LinkedInDatabaseAvailabilityContext];
                                                      NSLog(@"Settngs awoke from nib w context");
                                                  }];
}

- (IBAction)logout:(UIBarButtonItem *)sender {
    [self prepareAndPresentViewController];
}

- (void) prepareAndPresentViewController {
    NSString *storyboardName = [self.splitViewController.viewControllers lastObject] ? @"Main_iPad" : @"Main_iPhone";
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardName bundle:Nil];
    UITabBarController *controller = (UITabBarController *)[storyBoard instantiateViewControllerWithIdentifier:@"startingNavigationController"];

    NSLog(@"Current user trying to log out %@", self.currentUser.firstName);
    [RelinkedUserDefaults logoutCurrentUser];
    // delete core data entities
    [User deleteAllUsersInContext:self.currentUser.managedObjectContext];
    [Request deleteAllRequestsInContext:self.currentUser.managedObjectContext];
    self.currentUser = nil;

    
    //[self presentViewController:controller animated:YES completion:nil];
    
    IndustryTVC *vc = (IndustryTVC *)self.presentingViewController;
    //[vc returnToLoginVC];
    
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    
}

@end
