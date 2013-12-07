//
//  OpenRequestTableViewCell.m
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "OpenRequestTableViewCell.h"
#import "ReminderViewController.h"

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
    
    // modally add a reminder to connect with available contact options
    NSString *storyboardName = [self.cdtvc.splitViewController.viewControllers lastObject] ? @"Main_iPad" : @"Main_iPhone";
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardName bundle:Nil];
    UITabBarController *viewController = (UITabBarController *)[storyBoard instantiateViewControllerWithIdentifier:@"reminderViewController"];
    
    [self.cdtvc presentViewController:viewController animated:YES completion:nil];
    
}

- (IBAction)ignoreRequest:(UIButton *)sender {
    NSLog(@"clicked ignore");
    // update request status to ignore
    [self.cdtvc updateRequestWithIndexPath:self.indexPath forAction:@"update" forStatus:@"ignore"];
}


@end
