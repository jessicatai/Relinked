//
//  CustomTableViewCell.m
//  Relinked
//
//  Created by Jessica Tai on 12/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (NSIndexPath *) indexPath {
    if (!_indexPath) _indexPath = [self.cdtvc.tableView indexPathForCell:self];
    return _indexPath;
}

@end
