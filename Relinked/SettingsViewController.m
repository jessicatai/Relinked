//
//  SettingsViewController.m
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SettingsViewController.h"
#import "RelinkedUserDefaults.h"
#import "User+LinkedIn.h"
#import "Request+Relinked.h"
#import "AppDelegate.h"

#import "IndustryTVC.h"
#import "InterestedIndustry+Create.h"

@interface SettingsViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UISwitch *otherSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *emailSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *phoneSwitch;
@property (strong, nonatomic) IBOutlet UITextView *industryTextArea;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@end

@implementation SettingsViewController


- (void) viewDidAppear:(BOOL)animated {
    // change switches to reflect current user's choices
    if (!self.currentUser.email) NSLog(@"email not selected");
    self.emailSwitch.on = self.currentUser.email ? YES : NO;
    self.phoneSwitch.on = self.currentUser.phone ? YES : NO;
    self.otherSwitch.on = self.currentUser.other ? YES: NO;
    
    // show comma separted list of selected industries
    NSSet *industries = self.currentUser.interestedIndustries;
    NSMutableArray *indTexts = [[NSMutableArray alloc] init];
    for (InterestedIndustry *ind in [industries allObjects]) {
        [indTexts addObject:ind.industry];
    }
    [self.industryTextArea setText:[indTexts componentsJoinedByString:@", "]];
}

- (IBAction)editSettings:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logout:(UIButton *)sender {
    [RelinkedUserDefaults logoutCurrentUser];
    [RelinkedUserDefaults deleteSavedAccessToken];
    [User deleteAllUsersInContext:self.currentUser.managedObjectContext];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    NSString *storyboardName = [self.splitViewController.viewControllers lastObject] ? @"Main_iPad" : @"Main_iPhone";
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardName bundle:Nil];
    UINavigationController *controller = (UINavigationController *)[storyBoard instantiateViewControllerWithIdentifier:@"startingNavigationController"];
    
    appDelegate.window.rootViewController = controller; // re-navigate back to root view controller
    
}

@end
