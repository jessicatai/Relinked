//
//  AppDelegate.h
//  Relinked
//
//  Created by Jessica Tai on 12/2/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import "AFHTTPRequestOperation.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIManagedDocument *document;

// universal client for whole app
@property(nonatomic, strong) LIALinkedInHttpClient *client;
@end
