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

@interface RKFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sendFeedbackTitle;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UIButton *noThanksButton;
@property (weak, nonatomic) IBOutlet UIButton *sendFeedbackButton;

@end

@implementation RKFeedbackViewController

+ (RKFeedbackViewController *)feedbackViewController {
    return [self initialViewControllerFromStoryboardWithName:@"RKFeedbackViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [Flurry logEvent:@"Send Feedback – popup displayed"];
    
    RKLocalizedLabelFromTable(self.sendFeedbackTitle, @"SEND_FEEDBACK_TITLE", NSStringFromClass(self.class));
    [self.feedbackTextView setText:RKLocalizedFromTable(@"FEEDBACK_TEXT_PLACEHOLDER", NSStringFromClass(self.class))];
    RKLocalizedButtonFromTableWithFormat(self.noThanksButton, @"NO_THANKS_BUTTON", NSStringFromClass(self.class));
    RKLocalizedButtonFromTableWithFormat(self.sendFeedbackButton, @"SEND_FEEDBACK_BUTTON", NSStringFromClass(self.class));
}

- (IBAction)sendFeedback:(id)sender {
    // Do the testflight magick
}


@end
