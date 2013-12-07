//
//  OpenRequestTableViewCell.m
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "OpenRequestTableViewCell.h"
#import "ReminderViewController.h"
#import "EmailViewController.h"

@interface OpenRequestTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *ignoreButton;

@end

@implementation OpenRequestTableViewCell

- (IBAction)acceptRequest:(UIButton *)sender {
    NSLog(@"clicked accept");
    // update request status to accept
    [self.cdtvc updateRequestWithIndexPath:self.indexPath forAction:@"update" forStatus:@"accept"];
    // after accepting show an email prompt for the user to optionally send
   // [self.cdtvc prepForEmailForIndexPath:self.indexPath];
    
   
//    
//    // modally add a reminder to connect with available contact options
//    NSString *storyboardName = [self.cdtvc.splitViewController.viewControllers lastObject] ? @"Main_iPad" : @"Main_iPhone";
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardName bundle:Nil];
//    EmailViewController *viewController = (EmailViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"emailViewController"];
//    
//    // prep before presenting
//    viewController.request = req;
//    
//    [self.cdtvc presentViewController:viewController animated:YES completion:nil];
    
}

- (IBAction)ignoreRequest:(UIButton *)sender {
    NSLog(@"clicked ignore");
    // update request status to ignore
    [self.cdtvc updateRequestWithIndexPath:self.indexPath forAction:@"update" forStatus:@"ignore"];
}



@end
