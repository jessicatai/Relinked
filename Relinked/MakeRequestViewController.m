//
//  MakeRequestViewController.m
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "MakeRequestViewController.h"
#import "Request+Relinked.h"
#import "OpenRequestsCDTVC.h"

@interface MakeRequestViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *profileWebView;
@property (strong, nonatomic) IBOutlet UIButton *requestButton;

@end

@implementation MakeRequestViewController

- (void) viewDidLoad {
    if (!self.newRequest) {
        self.requestButton.enabled = NO;
        self.title = @"Your Connection";
        [self.requestButton setTitle:@"Pending request" forState:UIControlStateNormal];
        [self.requestButton setBackgroundColor:[UIColor blueColor]];
        
    } else {
        [self.requestButton setTitle:[NSString stringWithFormat:@"Relink with %@!", self.connection.firstName] forState:UIControlStateNormal];
    }
    [self.requestButton sizeToFit]; // account for dynamic text
    
    NSLog(@"make request view did load");
}

- (IBAction)requestRelink:(UIButton *)sender {
    NSString *today = [RelinkedStanfordServerRequest convertDateToString:[[NSDate alloc] init]];
    [Request addNewRequestFromUserID:self.currentUser.userID toUserID:self.connection.userID withAction:@"insert" withStatus:@"open" withDate:today inManagedObjectContext:self.currentUser.managedObjectContext];
    
    // go back to the search results
    [self.navigationController popViewControllerAnimated:YES];
}


@end
