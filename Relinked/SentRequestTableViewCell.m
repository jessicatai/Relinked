//
//  SentRequestTableViewCell.m
//  Relinked
//
//  Created by Jessica Tai on 12/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SentRequestTableViewCell.h"

@implementation SentRequestTableViewCell
- (IBAction)deleteRequest:(UIButton *)sender {
    NSLog(@"TODO: delete request");
    
    [self.cdtvc deleteRequestWithIndexPath:self.indexPath];
    
}


@end
