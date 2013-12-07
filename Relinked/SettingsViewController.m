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
@property (strong, nonatomic) IBOutlet UISwitch *otherSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *emailSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *phoneSwitch;
@property (strong, nonatomic) IBOutlet UITextView *industryTextArea;
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

- (void) viewDidAppear:(BOOL)animated {
    // change switches to reflect current user's choices
    self.emailSwitch.selected = self.currentUser.email ? YES : NO;
    self.phoneSwitch.selected = self.currentUser.phone ? YES : NO;
    self.otherSwitch.selected = self.currentUser.other ? YES: NO;
    
    // show comma separted list of selected industries
    NSSet *industries = self.currentUser.interestedIndustries;
    [self.industryTextArea setText:[[industries allObjects] componentsJoinedByString:@","]];
}


- (IBAction)logout:(UIButton *)sender {
    [RelinkedUserDefaults logoutCurrentUser];
    [RelinkedUserDefaults deleteSavedAccessToken];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    NSString *storyboardName = [self.splitViewController.viewControllers lastObject] ? @"Main_iPad" : @"Main_iPhone";
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardName bundle:Nil];
    UINavigationController *controller = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"startingNavigationController"];
    
    appDelegate.window.rootViewController = controller; // re-navigate back to root view controller
    
}

@end
