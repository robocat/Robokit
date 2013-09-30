//
//  RSRobocatNewsletterViewController.m
//  Televised
//
//  Created by Kristian Andersen on 9/23/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKRobocatNewsletterViewController.h"
#import "RKAboutRobocatViewController.h"
#import "RKSocial.h"
#import "RKLocalization.h"
#import "Flurry.h"

@interface RKRobocatNewsletterViewController () <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailField;
@property (nonatomic, weak) IBOutlet UILabel *disclaimerLabel;

- (IBAction)join:(id)sender;

@end

@implementation RKRobocatNewsletterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.navigationItem.rightBarButtonItem setTitle:RKLocalizedFromTable(@"RC_NEWSLETTER_BUTTON_JOIN", NSStringFromClass([RKAboutRobocatViewController class]))];
    [self.emailField setPlaceholder:RKLocalizedFromTable(@"RC_NEWSLETTER_EMAIL_INPUT", NSStringFromClass([RKAboutRobocatViewController class]))];
    [self.disclaimerLabel setText:RKLocalizedFromTable(@"RC_NEWSLETTER_DISCLAIMER", NSStringFromClass([RKAboutRobocatViewController class]))];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.emailField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.emailField resignFirstResponder];
}

- (BOOL)isValidEmail:(NSString *)email {
    return [email length] > 1;
}

- (IBAction)join:(id)sender {
	[Flurry logEvent:@"Did join newsletter from About Robocat signup"];
	
    [RKSocial subscribeWithEmail:self.emailField.text completion:^(BOOL success) {
		[self close];
	}];
}

- (void)close {
	[self.emailField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	self.navigationItem.rightBarButtonItem.enabled = [self isValidEmail:textField.text];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self isValidEmail:textField.text]) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self join:self.emailField];
    }
    
    return YES;
}

@end
