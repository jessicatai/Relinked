//
//  MakeRequestViewController.m
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "MakeRequestViewController.h"
#import "OpenRequestsCDTVC.h"
#import "LIALinkedInHttpClient.h"
#import "AppDelegate.h"
#import "RelinkedUserDefaults.h"

@interface MakeRequestViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *profileWebView;
@property (strong, nonatomic) IBOutlet UIButton *requestButton;
@property (strong, nonatomic) LIALinkedInHttpClient *client;
@end

@implementation MakeRequestViewController

- (void) viewDidLoad {
    NSLog(@"make request view did load");
    if (!self.newRequest) {
        self.title = @"Your Connection";
        [self.requestButton setTitle:@"Retract request" forState:UIControlStateNormal];
        [self.requestButton setBackgroundColor:[UIColor redColor]];
        
    } else {
        [self.requestButton setTitle:[NSString stringWithFormat:@"Relink with %@!", self.connection.firstName] forState:UIControlStateNormal];
    }
    [self.requestButton sizeToFit]; // account for dynamic text
    
    [self loadWebViewWithoutAuth];
    
    
}

- (IBAction)requestRelink:(UIButton *)sender {
    if (self.newRequest) {
        NSString *today = [RelinkedStanfordServerRequest convertDateToString:[[NSDate alloc] init]];
        [Request addNewRequestFromUserID:self.currentUser.userID toUserID:self.connection.userID withAction:@"insert" withStatus:@"open" withDate:today inManagedObjectContext:self.currentUser.managedObjectContext];
    } else {
        [Request deleteRequest:self.request];
    }
    
    // go back to the search results
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) loadWebViewWithoutAuth {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.client = appDelegate.client;
    
    self.client.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.client.requestSerializer setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    NSLog(@"access token %@", [RelinkedUserDefaults getSavedAccessToken]);
    
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/id=%@:(public-profile-url)?oauth2_access_token=%@", self.connection.uid, [RelinkedUserDefaults getSavedAccessToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *userResult) {
        NSLog(@"profile %@", userResult);
        
        NSURL *url = [NSURL URLWithString:[userResult valueForKey:@"publicProfileUrl"]];
        NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
        [self.profileWebView loadRequest:requestObj];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to fetch profile %@", error);
    }];
}


@end
