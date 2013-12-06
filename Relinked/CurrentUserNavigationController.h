//
//  CurrentUserNavigationController.h
//  Relinked
//
//  Created by Jessica Tai on 12/4/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+LinkedIn.h"

@interface CurrentUserNavigationController : UINavigationController

@property (nonatomic, strong) User *currentUser;

@end
