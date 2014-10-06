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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewWidthConstraint;
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

@property (weak, nonatomic) IBOutlet UILabel *ourAppsLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *facebookLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *supportLabel;

@property (weak, nonatomic) IBOutlet UIButton *newsletterCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *newsletterSubscribeButton;

@property (assign, nonatomic) BOOL shouldCloseSubscribeView;

@end

@implementation RKAboutRobocatViewController

+ (RKAboutRobocatViewController *)aboutRobocatViewController {
	return [self rk_initialViewControllerFromStoryboardWithName:@"RKAboutRobocatViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[Flurry logEvent:@"Did open About Robocat" timed:YES];
	
	self.aboutLabel.text = [NSString stringWithFormat:@"%@ %@\nCopyright © 2014 Robocat\nAll rights reserved", [RKSocial appName], [RKSocial appVersion]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	[RKLocalization registerForLocalization:self];
	
	if ([RKSocial hasFollowedOnTwitter]) {
		[self didFollow];
	}
	
	if ([RKSocial hasLikedOnFacebook]) {
		[self didLike];
	}
	
	if ([RKSocial hasSubscribed]) {
		[self didSubscribe];
	}
	
	if (![self.navigationController isModalInPopover]) {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (void)shouldLocalize {
	
    NSString *clstring = NSStringFromClass([self class]);

    RKLocalizedLabelFromTable(self.ourAppsLabel, @"RC_ABOUT_BUTTON_OUR_APPS", clstring);
    RKLocalizedLabelFromTable(self.subscribeLabel, @"RC_ABOUT_BUTTON_SUBSCRIBE", clstring);
    RKLocalizedLabelFromTable(self.facebookLabel, @"RC_ABOUT_BUTTON_LIKE", clstring);
    RKLocalizedLabelFromTable(self.twitterLabel, @"RC_ABOUT_BUTTON_FOLLOW", clstring);
    RKLocalizedLabelFromTable(self.websiteLabel, @"RC_ABOUT_BUTTON_WEBSITE", clstring);
    RKLocalizedLabelFromTable(self.supportLabel, @"RC_ABOUT_BUTTON_SUPPORT", clstring);

    RKLocalizedLabelFromTable(self.aboutTitleLabel, @"RC_ABOUT_WHO_WE_ARE_TITLE", clstring);
    RKLocalizedLabelFromTable(self.aboutTextLabel, @"RC_ABOUT_WHO_WE_ARE_TEXT", clstring);

    RKLocalizedButtonFromTable(self.newsletterCancelButton, @"RC_ABOUT_NEWSLETTER_CANCEL", clstring);
    RKLocalizedButtonFromTable(self.newsletterSubscribeButton, @"RC_ABOUT_BUTTON_SUBSCRIBE", clstring);

    [self.closeButton setTitle:RKLocalizedFromTable(@"RC_ABOUT_BUTTON_CLOSE", clstring)];
}

- (void)keyboardWillShow:(NSNotification *)notification {
	NSDictionary *info = [notification userInfo];
	CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
	self.scrollView.contentInset = contentInsets;
	self.scrollView.scrollIndicatorInsets = contentInsets;
	
	// If active text field is hidden by keyboard, scroll it so it's visible
	// Your application might not need or want this behavior.
	CGRect targetFrame = self.view.frame;
	targetFrame.size.height -= keyboardSize.height;
	
	CGRect inputFrame = [self.emailInput convertRect:self.emailInput.frame toView:self.scrollView];
	
	if (!CGRectContainsPoint(targetFrame, inputFrame.origin) ) {
		CGPoint scrollPoint = CGPointMake(0, inputFrame.origin.y - keyboardSize.height);
		[self.scrollView setContentOffset:scrollPoint animated:YES];
	}
}

- (void)keyboardWillHide:(NSNotification *)notification {
	[self.scrollView scrollRectToVisible:CGRectZero animated:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification {
	self.shouldCloseSubscribeView = YES;
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification {
	
}

- (void)openSubscribeView {
	self.subscribeViewLeftMarginConstraint.constant = -self.subscribeSuperview.frame.size.width / 2;
	
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
	[self.facebookLabel setText:@"Liked on Facebook!"];
	[self.facebookButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:89/255.0 blue:152/255.0 alpha:1.0]];
	
	UIColor *tintColor = [UIColor colorWithRed:30/255.0 green:53/255.0 blue:100/255.0 alpha:1.0];
	[self.facebookButton setTintColor:tintColor];
	[self.facebookLabel setTextColor:tintColor];
}

- (void)didFollow {
	[self.twitterLabel setText:@"Followed on Twitter!"];
	[self.twitterButton setBackgroundColor:[UIColor colorWithRed:0.0 green:172/255.0 blue:237/255.0 alpha:1.0]];
	
	UIColor *tintColor = [UIColor colorWithRed:0.0 green:123/255.0 blue:170/255.0 alpha:1.0];
	[self.twitterButton setTintColor:tintColor];
	[self.twitterLabel setTextColor:tintColor];
}

- (void)didSubscribe {
	[self.subscribeLabel setText:@"Subscribed!"];
	[self.subscribeButton setBackgroundColor:[UIColor colorWithRed:201/255.0 green:151/255.0 blue:19/255.0 alpha:1.0]];
	
	UIColor *tintColor = [UIColor colorWithRed:140/255.0 green:92/255.0 blue:9/255.0 alpha:1.0];
	[self.subscribeButton setTintColor:tintColor];
	[self.subscribeLabel setTextColor:tintColor];
}

#pragma mark - Interface actions

- (IBAction)support:(id)sender {
	[Flurry logEvent:@"Did request support from About Robocat"];
	
    NSString *mailString = [NSString stringWithFormat:@"mailto:%@?subject=Support %@ (%@)", [RKSocial supportEmailAddress], [RKSocial appName], [RKSocial appVersion]];
	NSURL *mailURL = [NSURL URLWithString:[mailString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	[[UIApplication sharedApplication] openURL:mailURL];
	
	[self.supportButton setBackgroundColor:[UIColor colorWithRed:1.0 green:80/255.0 blue:80/255.0 alpha:1.0]];
	UIColor *tintColor = [UIColor colorWithRed:170/255.0 green:43/255.0 blue:43/255.0 alpha:1.0];
	[self.supportButton setTintColor:tintColor];
	[self.supportLabel setTextColor:tintColor];
}

- (IBAction)visitWebsite:(id)sender {
	[Flurry logEvent:@"Did visit website from About Robocat"];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://robo.cat"]];
	
	[self.websiteButton setBackgroundColor:[UIColor colorWithRed:151/255.0 green:246/255.0 blue:35/255.0 alpha:1.0]];
	UIColor *tintColor = [UIColor colorWithRed:52/255.0 green:150/255.0 blue:14/255.0 alpha:1.0];
	[self.websiteButton setTintColor:tintColor];
	[self.websiteLabel setTextColor:tintColor];
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
	[self.ourAppsButton setBackgroundColor:[UIColor colorWithRed:243/255.0 green:224/255.0 blue:55/255.0 alpha:1.0]];
	UIColor *tintColor = [UIColor colorWithRed:140/255.0 green:92/255.0 blue:9/255.0 alpha:1.0];
	[self.ourAppsButton setTintColor:tintColor];
	[self.ourAppsLabel setTextColor:tintColor];
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
