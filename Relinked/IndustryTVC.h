//
//  IndustryTVC.h
//  Relinked
//
//  Created by Jessica Tai on 12/2/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "User+LinkedIn.h"

@interface IndustryTVC : UITableViewController

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSArray *contactMethods;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *other;

- (void) returnToLoginVC;

@end
