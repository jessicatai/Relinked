//
//  ContactMethodViewController.m
//  Relinked
//
//  Created by Jessica Tai on 12/2/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "ContactMethodViewController.h"
#import "IndustryTVC.h"

@interface ContactMethodViewController() <UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *contactButtons;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *methodTextFields; // TODO: delete, probably can't use bc can't guarantee order?

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIButton *emailButton;

@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UIButton *phoneButton;
@property (strong, nonatomic) IBOutlet UITextField *otherTextField;
@property (strong, nonatomic) IBOutlet UIButton *otherButton;
@end

@implementation ContactMethodViewController

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;
    self.errorLabel.hidden = YES;
    [self presetContactMethods];
    [self hideAllTextFields];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    for (UITextField *textField in self.methodTextFields) {
        textField.delegate = self;
    }
    
}

- (void) presetContactMethods {
    // TODO implement
    
}

- (void) hideAllTextFields {

    for (UIButton *btn in self.contactButtons) {
        if (!btn.selected) {
            if ([btn.accessibilityLabel isEqualToString:@"email"]) {
                self.emailTextField.alpha = 0;
            } else if ([btn.accessibilityLabel isEqualToString:@"phone"]) {
                 self.phoneTextField.alpha = 0;
            } else {
                self.otherTextField.alpha = 0;
            }
        }
    }
}

- (void) showAndEditTextField:(UITextField *)textField {
    [UIView beginAnimations:Nil context:NULL];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:0.75];
    textField.alpha = 1;
    [UIView commitAnimations];
    
    textField.userInteractionEnabled = TRUE;
    [textField becomeFirstResponder];
}

- (IBAction)tapButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    UIButton *btn = (UIButton *)sender;
    if (sender.selected) {
        if ([btn.accessibilityLabel isEqualToString:@"email"]) {
            [self showAndEditTextField:self.emailTextField];
        } else if ([btn.accessibilityLabel isEqualToString:@"phone"]) {
            [self showAndEditTextField:self.phoneTextField];
        } else {
            [self showAndEditTextField:self.otherTextField];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    // if there is text, assume the user intends to check this option
    if (textField.text.length > 0) {
        if ([textField.accessibilityLabel isEqualToString:@"email address"]) {
            self.emailButton.selected = YES;
        } else if ([textField.accessibilityLabel isEqualToString:@"phone number"]) {
            self.phoneButton.selected = YES;
        } else {
            self.otherButton.selected = YES;
        }
    }
    return NO;
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
    // check for any selected methods with no input text
    if ((self.emailButton.selected && self.emailTextField.text.length == 0)
        || (self.phoneButton.selected && self.phoneTextField.text.length == 0)
        || (self.otherButton.selected && self.otherTextField.text.length == 0)){
        self.errorLabel.hidden = NO;
        return NO;
    }
    
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
        industryTVC.email = self.emailTextField.text;
        industryTVC.phone = self.phoneTextField.text;
        industryTVC.other = self.otherTextField.text;
    }
}

@end
