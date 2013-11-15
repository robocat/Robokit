//
//  RKFeedbackViewController.m
//  Robokit
//
//  Created by Kristian Andersen on 24/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKFeedbackViewController.h"
#import "Flurry.h"
#import "RKLocalization.h"
#import "TestFlight.h"
#import "RKDispatch.h"
#import "RKSocial.h"
#import "RKSoundPlayer.h"

@interface RKFeedbackViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *feedbackView;

@property (weak, nonatomic) IBOutlet UILabel *sendFeedbackTitle;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UIButton *noThanksButton;
@property (weak, nonatomic) IBOutlet UIButton *sendFeedbackButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *feedbackViewTopSpaceConstraint;

@property (assign, nonatomic) CGFloat feedbackViewOffset;
@property (strong, nonatomic) NSString *feedbackPlaceholder;

@end

@implementation RKFeedbackViewController

+ (RKFeedbackViewController *)feedbackViewController {
    return [self rk_initialViewControllerFromStoryboardWithName:@"RKFeedbackViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.feedbackTextView setDelegate:self];

    [Flurry logEvent:@"Send Feedback – popup displayed"];
    
    self.feedbackView.clipsToBounds = YES;
	self.feedbackView.layer.cornerRadius = 10;
    CGSize viewSize = self.feedbackView.frame.size;
    self.feedbackViewOffset = (self.view.frame.size.height - viewSize.height - 20.0f)/2;
    [self.feedbackViewTopSpaceConstraint setConstant:self.feedbackViewOffset];
    [self.view layoutIfNeeded];
    
    if ([RKSocial modalBackgroundStyle] == RKModalBackgroundStyleLight) {
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.feedbackView.bounds];
        toolbar.translucent = YES;
        [self.feedbackView insertSubview:toolbar atIndex:0];
        self.feedbackView.backgroundColor = [UIColor clearColor];
    }
    
    RKLocalizedLabelFromTable(self.sendFeedbackTitle, @"SEND_FEEDBACK_TITLE", NSStringFromClass(self.class));
    
    self.feedbackPlaceholder = RKLocalizedFromTable(@"FEEDBACK_TEXT_PLACEHOLDER", NSStringFromClass(self.class));
    [self.feedbackTextView setText:self.feedbackPlaceholder];
    RKLocalizedButtonFromTableWithFormat(self.noThanksButton, @"NO_THANKS_BUTTON", NSStringFromClass(self.class));
    RKLocalizedButtonFromTableWithFormat(self.sendFeedbackButton, @"SEND_FEEDBACK_BUTTON", NSStringFromClass(self.class));
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [UIView animateWithDuration:0.3f animations:^{
            CGSize keyboardSize = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
            CGFloat offset = (self.view.frame.size.height - keyboardSize.height - self.feedbackView.frame.size.height - 20.0f) / 2;
            [self.feedbackViewTopSpaceConstraint setConstant:offset];
            [self.view layoutIfNeeded];
        }];
    }];
}

- (IBAction)sendFeedback:(id)sender {
    [RKSoundPlayer playSoundForEvent:kRKSoundPlayerButtonClickedEvent];
    
    // Do the testflight magick
    if ([self.feedbackTextView.text length] > 0) {
        [Flurry logEvent:@"Send Feedback - Submitted feedback" withParameters:@{@"Feedback": self.feedbackTextView.text}];
        [TestFlight submitFeedback:self.feedbackTextView.text];
    }

    [Flurry logEvent:@"Send Feedback - Pressed No Thanks"];
    
    [self.feedbackTextView resignFirstResponder];
    [self close];
}

- (IBAction)noThanks:(id)sender {
    [RKSoundPlayer playSoundForEvent:kRKSoundPlayerButtonClickedEvent];
    
    [self.feedbackTextView resignFirstResponder];
    
    [self close];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:self.feedbackPlaceholder]) {
        [textView setText:@""];
        [textView setTextColor:[UIColor blackColor]];
        [textView setFont:[UIFont systemFontOfSize:textView.font.pointSize]];
    }
}

@end
