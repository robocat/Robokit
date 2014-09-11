//
//  RSAboutRobocatViewController.m
//  Televised
//
//  Created by Kristian Andersen on 9/20/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKAboutRobocatViewController.h"
#import "UIViewController+RKAdditions.h"

#import <Robokit/RKSocial.h>
#import <Robokit/RKLocalization.h>
#import <Flurry.h>

@interface RKAboutRobocatViewController () <UIScrollViewDelegate, UITextFieldDelegate, RKLocalizable>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subscribeViewLeftMarginConstraint;
@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UIView *subscribeSuperview;

@property (weak, nonatomic) IBOutlet UILabel *aboutTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;

@property (weak, nonatomic) IBOutlet UIButton *ourAppsButton;
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;
@property (weak, nonatomic) IBOutlet UIButton *supportButton;

@property (weak, nonatomic) IBOutlet UIButton *newsletterCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *newsletterSubscribeButton;

@property (assign, nonatomic) BOOL shouldCloseSubscribeView;

@end

@implementation RKAboutRobocatViewController

+ (RKAboutRobocatViewController *)aboutRobocatViewController {
	return [self rk_initialViewControllerFromStoryboardWithName:@"RKAboutRobocatViewController"];
}

- (id)init {
    self = [super init];
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[Flurry logEvent:@"Did open About Robocat" timed:YES];
	
	self.aboutLabel.text = [NSString stringWithFormat:@"%@ %@\nCopyright © 2014 Robocat\nAll rights reserved", [RKSocial appName], [RKSocial appVersion]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
	
	if ([RKSocial hasFollowedOnTwitter]) {
		[self didFollow];
	}
	
	if ([RKSocial hasLikedOnFacebook]) {
		[self didLike];
	}
	
	if ([RKSocial hasSubscribed]) {
		[self didSubscribe];
	}
    
    [RKLocalization registerForLocalization:self];
	
	if (![self.navigationController isModalInPopover]) {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (void)shouldLocalize {
    NSString *clstring = NSStringFromClass([self class]);

    RKLocalizedButtonFromTable(self.ourAppsButton, @"RC_ABOUT_BUTTON_OUR_APPS", clstring);
    RKLocalizedButtonFromTable(self.subscribeButton, @"RC_ABOUT_BUTTON_SUBSCRIBE", clstring);
    RKLocalizedButtonFromTable(self.facebookButton, @"RC_ABOUT_BUTTON_LIKE", clstring);
    RKLocalizedButtonFromTable(self.twitterButton, @"RC_ABOUT_BUTTON_FOLLOW", clstring);
    RKLocalizedButtonFromTable(self.websiteButton, @"RC_ABOUT_BUTTON_WEBSITE", clstring);
    RKLocalizedButtonFromTable(self.supportButton, @"RC_ABOUT_BUTTON_SUPPORT", clstring);

    RKLocalizedLabelFromTable(self.aboutTitleLabel, @"RC_ABOUT_WHO_WE_ARE_TITLE", clstring);
    RKLocalizedLabelFromTable(self.aboutTextLabel, @"RC_ABOUT_WHO_WE_ARE_TEXT", clstring);

    RKLocalizedButtonFromTable(self.newsletterCancelButton, @"RC_ABOUT_NEWSLETTER_CANCEL", clstring);
    RKLocalizedButtonFromTable(self.newsletterSubscribeButton, @"RC_ABOUT_BUTTON_SUBSCRIBE", clstring);

    [self.closeButton setTitle:RKLocalizedFromTable(@"RC_ABOUT_BUTTON_CLOSE", clstring)];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	[self.scrollView scrollRectToVisible:CGRectMake(0, self.subscribeSuperview.frame.origin.y, 320, self.subscribeSuperview.frame.size.height + keyboardFrame.size.height + 20) animated:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification {
	self.shouldCloseSubscribeView = YES;
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification {
	CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	[self.scrollView scrollRectToVisible:CGRectMake(0, self.subscribeSuperview.frame.origin.y, 320, self.subscribeSuperview.frame.size.height + keyboardFrame.size.height + 20) animated:YES];
}

- (void)openSubscribeView {
	self.subscribeViewLeftMarginConstraint.constant = -320;
	
	[UIView animateWithDuration:.3 animations:^{
		[self.view layoutIfNeeded];
	}];
	
	[self.emailInput becomeFirstResponder];
	self.emailInput.text = @"";
}

- (void)closeSubscribeView {
	self.subscribeViewLeftMarginConstraint.constant = 0;
	
	[UIView animateWithDuration:.3 animations:^{
		[self.view layoutIfNeeded];
	}];
	
	[self.emailInput resignFirstResponder];
	self.shouldCloseSubscribeView = NO;
}

- (void)didLike {
	[self.facebookButton setBackgroundImage:[self.facebookButton backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];
	[self.facebookButton setTitleColor:[self.facebookButton titleColorForState:UIControlStateHighlighted] forState:UIControlStateNormal];
	[self.facebookButton setTitle:@"Liked on Facebook!" forState:UIControlStateNormal];
}

- (void)didFollow {
	[self.twitterButton setBackgroundImage:[self.twitterButton backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];
	[self.twitterButton setTitleColor:[self.twitterButton titleColorForState:UIControlStateHighlighted] forState:UIControlStateNormal];
	[self.twitterButton setTitle:@"Followed on Twitter!" forState:UIControlStateNormal];
}

- (void)didSubscribe {
	[self.subscribeButton setBackgroundImage:[self.subscribeButton backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];
	[self.subscribeButton setTitleColor:[self.subscribeButton titleColorForState:UIControlStateHighlighted] forState:UIControlStateNormal];
	[self.subscribeButton setTitle:@"Subscribed!" forState:UIControlStateNormal];
}

#pragma mark - Interface actions

- (IBAction)support:(id)sender {
	[Flurry logEvent:@"Did request support from About Robocat"];
	
    NSString *mailString = [NSString stringWithFormat:@"mailto:%@?subject=Support %@ (%@)", [RKSocial supportEmailAddress], [RKSocial appName], [RKSocial appVersion]];
	NSURL *mailURL = [NSURL URLWithString:[mailString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	[[UIApplication sharedApplication] openURL:mailURL];
}

- (IBAction)visitWebsite:(id)sender {
	[Flurry logEvent:@"Did visit website from About Robocat"];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://robo.cat"]];
}

- (IBAction)followOnTwitter:(id)sender {
	[Flurry logEvent:@"Did follow on Twitter from About Robocat"];
	
	[RKSocial followOnTwitterWithCompletion:^(BOOL success) {
		if (success) [self didFollow];
	}];
}

- (IBAction)likeOnFacebook:(id)sender {
	[Flurry logEvent:@"Did like on Facebook from About Robocat"];
	
	[RKSocial likeOnFacebookWithCompletion:^(BOOL success) {
		if (success) [self didLike];
	}];
}

- (IBAction)ourApps:(id)sender {
	[Flurry logEvent:@"Did open 'more apps' from About Robocat"];
	[RKSocial showMoreAppsFromRobocat];
}

- (IBAction)subscribe:(id)sender {
	[self openSubscribeView];
}

- (IBAction)cancel:(id)sender {
	[self closeSubscribeView];
}

- (IBAction)doSubscribe:(id)sender {
	[Flurry logEvent:@"Did subscribe to newsletter About Robocat"];
	
	[RKSocial subscribeWithEmail:self.emailInput.text completion:^(BOOL success) {
		if (success) [self didSubscribe];
	}];
	
	[self closeSubscribeView];
}

- (IBAction)dismiss:(id)sender {
	[Flurry logEvent:@"Did open About Robocat"];
	
    if ([self.navigationController isModalInPopover]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (self.shouldCloseSubscribeView) {
		[self closeSubscribeView];
	}
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	[self closeSubscribeView];
	
	return YES;
}

@end
