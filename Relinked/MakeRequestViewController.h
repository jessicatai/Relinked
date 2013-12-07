//
//  MakeRequestViewController.h
//  Relinked
//
//  Created by Jessica Tai on 12/5/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+LinkedIn.h"

@interface MakeRequestViewController : UIViewController

@property (nonatomic, strong) User *connection;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic) BOOL newRequest;
@end
