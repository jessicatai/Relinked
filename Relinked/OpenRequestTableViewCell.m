//
//  OpenRequestTableViewCell.m
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "OpenRequestTableViewCell.h"

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
}

- (IBAction)ignoreRequest:(UIButton *)sender {
    NSLog(@"clicked ignore");
}


@end
