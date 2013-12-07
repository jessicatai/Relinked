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
#import "AppDelegate.h"

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
    [RelinkedUserDefaults logoutCurrentUser];
    [RelinkedUserDefaults deleteSavedAccessToken];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    NSString *storyboardName = [self.splitViewController.viewControllers lastObject] ? @"Main_iPad" : @"Main_iPhone";
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardName bundle:Nil];
    UINavigationController *controller = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"startingNavigationController"];
    
    appDelegate.window.rootViewController = controller; // re-navigate back to root view controller
    
}

@end
