//
//  EmailViewController.h
//  Relinked
//
//  Created by Jessica Tai on 12/7/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Request+Relinked.h"

@interface EmailViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) Request *request;
@end
