//
//  LoginViewController.m
//  Relinked
//
//  Created by Jessica Tai on 12/2/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//  Citations for Frameworks used:
//  AFNetworking: https://github.com/AFNetworking/AFNetworking
//  iOSLinkedInAPI: https://github.com/jeyben/IOSLinkedInAPI
//

#import "LoginViewController.h"
#import "ContactMethodViewController.h"
#import "LinkedInFetcher.h"
#import "LinkedInDatabaseAvailability.h"

#import "User+LinkedIn.h"
#import "Request+Relinked.h"
#import "LIALinkedInHttpClient.h"
#import "RelinkedUserDefaults.h"
#import "AppDelegate.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) LIALinkedInHttpClient * client;
@property(weak, nonatomic) User *currentUser;
@property(strong, nonatomic) NSString *accessToken;
@end

@implementation LoginViewController

- (void) awakeFromNib
{
    NSLog(@")(!*#&)(@Q*&$)(*awake from nib");
    [[NSNotificationCenter defaultCenter] addObserverForName:LinkedInDatabaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = note.userInfo[LinkedInDatabaseAvailabilityContext];
                                                      NSLog(@"awoke from nib w context");
                                                  }];
}

// get Current User entity if user already logged in
- (void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    if ([RelinkedUserDefaults isUserLoggedIn]) {
        NSLog(@"user already logged in, getting context %@", managedObjectContext);
        NSDictionary *userInfo = [RelinkedUserDefaults getCurrentUserInfo];
        self.currentUser = [User userWithInfo:userInfo forCurrentUser:nil inManagedObjectContext:self.managedObjectContext];
        
        NSLog(@"user has %d connections!", [self.currentUser.connections count]);
        // only skip the login page if user was correctly retrieved
        if (self.currentUser && self.currentUser.managedObjectContext && [self.currentUser.connections count] > 0) {
            [Request addAllRequestsInvolvingUser:self.currentUser];
            
            [self.loginButton setTitle:@"Welcome back!" forState:UIControlStateNormal];
            [self performSegueWithIdentifier: @"LoggedIn" sender: self];
        }
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.client = appDelegate.client;
    
}


- (IBAction)login:(UIButton *)sender {

    //self.loginButton.enabled = NO;
    [self.client getAuthorizationCode:^(NSString *code) {
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                [self.view addSubview:spinner];
                spinner.center = self.parentViewController.view.center;
                [spinner startAnimating];
                NSLog(@"current user %@", result);
                
                User *currentUser = [User userWithInfo:result forCurrentUser:nil inManagedObjectContext:self.managedObjectContext];
                self.currentUser = currentUser;
                
                [RelinkedUserDefaults loginCurrentUser:result];
                
                
                self.accessToken = accessToken;
                [RelinkedUserDefaults saveAccessToken:accessToken];
                
                [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~/connections?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
                    //NSLog(@"connections %@", result);
                    NSArray *connections = [result objectForKey:@"values"];
                    [User loadUsersArray:connections forCurrentUser:currentUser intoManagedObjectContext:self.managedObjectContext];
                    
                    NSLog(@"*** Current user has %d connections!",[currentUser.connections count]);
                    
                    // need connection info to set request info
                    [Request addAllRequestsInvolvingUser:self.currentUser]; // get any requests related to user
                    [spinner stopAnimating];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"failed to fetch connections %@", error);
                }];

                self.loginButton.titleLabel.text = [self isLoggedIn] ? @"logged in!": @"not logged in :(";
                
                if (self.managedObjectContext && [currentUser.connections count] > 0) {
                    [self performSegueWithIdentifier: @"LoggedIn" sender: self];
                } else {
                    [self.loginButton setTitle:@"Error retrieving your connections. \nPlease close app and try again." forState:UIControlStateNormal];
                    [self.view setBackgroundColor:[UIColor redColor]];
                }
                
            
                
            }            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"failed to fetch current user %@", error);
            }];
        }                   failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }                          cancel:^{
        NSLog(@"Authorization was cancelled by user");
    }                         failure:^(NSError *error) {
        NSLog(@"Authorization failed %@", error);
    }];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepping for segue");
    if ([segue.destinationViewController isKindOfClass:[ContactMethodViewController class]]) {
        ContactMethodViewController *cmvc = (ContactMethodViewController *) segue.destinationViewController;
        cmvc.currentUser = self.currentUser;
    }
}

- (BOOL)isLoggedIn
{
    return self.currentUser != nil;
}
@end
