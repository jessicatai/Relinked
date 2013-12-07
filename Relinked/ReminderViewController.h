//
//  ReminderViewController.h
//  Relinked
//
//  Created by Jessica Tai on 12/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface ReminderViewController : UIViewController
- (IBAction)unwindFromConfirmationForm:(UIStoryboardSegue *)segue;
@end
