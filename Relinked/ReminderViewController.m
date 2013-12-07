//
//  ReminderViewController.m
//  Relinked
//
//  Created by Jessica Tai on 12/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "ReminderViewController.h"

@interface ReminderViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation ReminderViewController

-(void) viewDidLoad {
    EKEventStore *store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        // handle access here
        NSLog(@"user denied access");
    }];
}
- (IBAction)addReminder:(UIButton *)sender {

}

- (IBAction)cancelReminder:(UIButton *)sender {
    self.notesTextView = nil;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)unwindFromConfirmationForm:(UIStoryboardSegue *)segue {
}

@end
