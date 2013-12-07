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

@property (strong, nonatomic) UITextField *activeField;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView; // needed to move up text when keyboard shows up
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
    [self registerForKeyboardNotifications];
    
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

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (IBAction)tapButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    UIButton *btn = (UIButton *)sender;

    // change text field visibility w button select/deselect
    if ([btn.accessibilityLabel isEqualToString:@"email"]) {
        [self shouldShowTextField:self.emailTextField isSelected:sender.selected];
    } else if ([btn.accessibilityLabel isEqualToString:@"phone"]) {
        [self shouldShowTextField:self.phoneTextField isSelected:sender.selected];
    } else {
        [self shouldShowTextField:self.otherTextField isSelected:sender.selected];
    }
}

- (void) shouldShowTextField:(UITextField *)textField isSelected:(BOOL)selected{
    if (selected) {
        [self showAndEditTextField:textField];
    } else {
        textField.alpha = 0;
        
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
        industryTVC.email = self.emailButton.selected ? self.emailTextField.text : nil;
        industryTVC.phone = self.phoneButton.selected ? self.phoneTextField.text : nil;
        industryTVC.other = self.otherButton.selected ? self.otherTextField.text : nil;
    }
}

# pragma mark Keyboard
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView beginAnimations:Nil context:NULL];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:0.75];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    [UIView commitAnimations];
}

@end
