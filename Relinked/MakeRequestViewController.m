//
//  MakeRequestViewController.m
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "MakeRequestViewController.h"
#import "Request+Relinked.h"

@interface MakeRequestViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *profileWebView;
@property (strong, nonatomic) IBOutlet UIButton *requestButton;

@end

@implementation MakeRequestViewController

- (void) viewDidLoad {
    [self.requestButton setTitle:[NSString stringWithFormat:@"Relink with %@!", self.connection.firstName] forState:UIControlStateNormal];
    NSLog(@"make request did laod");
}

- (IBAction)requestRelink:(UIButton *)sender {
    [Request addNewRequestFromUserID:self.currentUser.userID toUserID:self.connection.userID withAction:@"insert" inManagedObjectContext:self.currentUser.managedObjectContext];
    
    // go back to the search results
    [self.navigationController popViewControllerAnimated:YES];
}


@end
