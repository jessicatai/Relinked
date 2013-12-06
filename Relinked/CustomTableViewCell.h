//
//  CustomTableViewCell.h
//  Relinked
//
//  Created by Jessica Tai on 12/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestsCDTVC.h"

@interface CustomTableViewCell : UITableViewCell
@property (nonatomic, weak) RequestsCDTVC *cdtvc;
@property (nonatomic, weak) NSIndexPath *indexPath;
@end
