//
//  ContactMethodViewController.m
//  Relinked
//
//  Created by Jessica Tai on 12/2/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "ContactMethodViewController.h"
#import "IndustryTVC.h"

@interface ContactMethodViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *contactButtons;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation ContactMethodViewController

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;
    self.errorLabel.hidden = YES;
    [self presetContactMethods];
}

- (void) presetContactMethods {
    // TODO implement
    
}

- (IBAction)tapButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

- (NSArray *) selectedContactMethods {
    NSMutableArray *selectedOptions = [[NSMutableArray alloc] init];
    for (UIButton *button in self.contactButtons) {
        if (button.selected) {
            [selectedOptions addObject:button.accessibilityLabel];
        }
        
    }
    return (NSArray *)selectedOptions;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"step2"]) {
        self.errorLabel.hidden = [[self selectedContactMethods] count] > 0;
        return [[self selectedContactMethods] count] > 0;
    }
    return NO;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepping for industry segue");
    if ([segue.destinationViewController isKindOfClass:[IndustryTVC class]]) {
        IndustryTVC *industryTVC = (IndustryTVC *) segue.destinationViewController;
        industryTVC.currentUser = self.currentUser;
        industryTVC.contactMethods = [self selectedContactMethods];
    }
}

@end
