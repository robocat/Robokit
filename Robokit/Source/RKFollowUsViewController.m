//
//  FollowUsViewController.m
//  Thermo
//
//  Created by Ulrik Damm on 15/10/12.
//
//

#import "RKFollowUsViewController.h"
#import "RKSocial.h"
#import "RKLocalization.h"
#import "RKMacros.h"
#import "Flurry.h"

@interface RKFollowUsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *followView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *twitterSpinner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *subscribeSpinner;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;
@property (weak, nonatomic) IBOutlet UIButton *nothanksButton;
@property (weak, nonatomic) IBOutlet UIView *subscribeView;
@property (weak, nonatomic) IBOutlet UITextField *subscribeField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subscribeViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parentViewBottomSpaceConstraint;

@property (strong, nonatomic) NSString *mailchimpId;
@property (strong, nonatomic) NSString *mailchimpApiKey;
@property (copy, nonatomic) void (^closeHandler)(void);

@property (assign, nonatomic) BOOL hasFollowed;
@property (assign, nonatomic) BOOL hasLiked;
@property (assign, nonatomic) BOOL hasSubscribed;

- (IBAction)twitter:(id)sender;
- (IBAction)facebook:(id)sender;
- (IBAction)subscribe:(id)sender;
- (IBAction)noThanks:(id)sender;

@end

@implementation RKFollowUsViewController

+ (RKFollowUsViewController *)followUsViewControllerWithMailchimpId:(NSString *)mailchimpId APIKey:(NSString *)apiKey {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RKFollowUsViewController" bundle:nil];
	RKFollowUsViewController *followUsViewController = [storyboard instantiateInitialViewController];
	followUsViewController.mailchimpId = mailchimpId;
	followUsViewController.mailchimpApiKey = apiKey;
	return followUsViewController;
}

- (void)presentInWindow:(UIWindow *)window withCloseHandler:(void (^)(void))closeHandler {
	self.view.alpha = 0;
	
	self.view.frame = window.bounds;
	[window addSubview:self.view];
	
	[UIView animateWithDuration:.3 animations:^{
		self.view.alpha = 1;
	}];
	
	self.closeHandler = closeHandler;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[Flurry logEvent:@"Follow us – popup displayed"];
	
	self.subscribeViewHeightConstraint.constant = 0;
	self.subscribeField.delegate = self;
	
	self.topLabel.text = RKLocalizedFromTable(@"STAY_UPDATED_LABEL", NSStringFromClass(self.class));
	[self.twitterButton setTitle:RKLocalizedFromTable(@"TWITTER_FOLLOW_BUTTON", NSStringFromClass(self.class)) forState:UIControlStateNormal];
	[self.facebookButton setTitle:RKLocalizedFromTable(@"FACEBOOK_LIKE_BUTTON", NSStringFromClass(self.class)) forState:UIControlStateNormal];
	[self.subscribeButton setTitle:RKLocalizedFromTable(@"SUBSCRIBE_BUTTON", NSStringFromClass(self.class)) forState:UIControlStateNormal];
	[self.nothanksButton setTitle:RKLocalizedFromTable(@"NO_THANKS_BUTTON", NSStringFromClass(self.class)) forState:UIControlStateNormal];
	
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.followView.bounds];
	toolbar.translucent = YES;
	[self.followView insertSubview:toolbar atIndex:0];
	self.followView.backgroundColor = [UIColor clearColor];
	
	self.followView.clipsToBounds = YES;
	self.followView.layer.cornerRadius = 10;
	
	UIInterpolatingMotionEffect *motionEffectx = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	motionEffectx.minimumRelativeValue = @( -20 );
	motionEffectx.maximumRelativeValue = @(  20 );
	[self.followView addMotionEffect:motionEffectx];
	
	UIInterpolatingMotionEffect *motionEffecty = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	motionEffecty.minimumRelativeValue = @( -20 );
	motionEffecty.maximumRelativeValue = @(  20 );
	[self.followView addMotionEffect:motionEffecty];
	
	if ([RKSocial hasFollowedOnTwitter]) {
		[self didFollow];
	}
	
	if ([RKSocial hasLikedOnFacebook]) {
		[self didLike];
	}
	
	if ([RKSocial hasSubscribed]) {
		[self didSubscribe];
	}
}

- (void)didFollow {
	self.hasFollowed = YES;
	
	self.twitterButton.backgroundColor = [UIColor colorWithRed:0.000000 green:0.650980 blue:0.972549 alpha:1.000000];
	[self.twitterButton setTitle:RKLocalizedFromTable(@"TWITTER_FOLLOW_BUTTON_FOLLOWING", NSStringFromClass(self.class)) forState:UIControlStateNormal];
	[self.twitterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.twitterButton setImage:[UIImage imageNamed:@"follow_twitter_active"] forState:UIControlStateNormal];
	[self goHappyFace];
	
	[self.view setNeedsDisplay];
}

- (void)didLike {
	self.hasLiked = YES;
	
	self.facebookButton.backgroundColor = [UIColor colorWithRed:0.250980 green:0.282353 blue:0.619608 alpha:1.000000];
	[self.facebookButton setTitle:RKLocalizedFromTable(@"FACEBOOK_LIKE_BUTTON_LIKED", NSStringFromClass(self.class)) forState:UIControlStateNormal];
	[self.facebookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.facebookButton setImage:[UIImage imageNamed:@"follow_facebook_active"] forState:UIControlStateNormal];
	[self goHappyFace];
}

- (void)didSubscribe {
	self.hasSubscribed = YES;
	
	self.subscribeButton.backgroundColor = [UIColor colorWithRed:1.000000 green:0.686275 blue:0.000000 alpha:1.000000];
	[self.subscribeButton setTitle:RKLocalizedFromTable(@"SUBSCRIBE_BUTTON_SUBSCRIBED", NSStringFromClass(self.class)) forState:UIControlStateNormal];
	[self.subscribeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.subscribeButton setImage:[UIImage imageNamed:@"follow_subscribe_active"] forState:UIControlStateNormal];
	[self goHappyFace];
}

- (void)goHappyFace {
	[self.nothanksButton setTitle:RKLocalizedFromTable(@"NO_THANKS_BUTTON_THANKS", NSStringFromClass(self.class)) forState:UIControlStateNormal];
	[self.nothanksButton setImage:[UIImage imageNamed:@"follow_thanks_inactive"] forState:UIControlStateNormal];
	[self.nothanksButton setImage:[UIImage imageNamed:@"follow_thanks_active"] forState:UIControlStateHighlighted];
}

- (IBAction)twitter:(id)sender {
	[RKSocial followOnTwitterWithCompletion:^(BOOL success) {
		if (success) {
			[self didFollow];
		}
	}];
}

- (IBAction)facebook:(id)sender {
	[RKSocial likeOnFacebookWithCompletion:^(BOOL success) {
		if (success) {
			[self didLike];
		}
	}];
}

- (IBAction)subscribe:(id)sender {
	if (![self subscriptionViewIsOpen]) {
		[self openSubscriptionView];
	} else {
		[self closeSubscriptionView];
	}
}

- (IBAction)noThanks:(id)sender {
	[self close];
}

- (void)close {
	[Flurry logEvent:@"Follow popup" withParameters:@{ @"didFollow": @( self.hasFollowed ),
													   @"didLike": @( self.hasLiked ),
													   @"didSubscribe": @( self.hasSubscribed ) }];
	
	[UIView animateWithDuration:.3 animations:^{
		self.view.alpha = 0;
	} completion:^(BOOL finished) {
		[self.view removeFromSuperview];
		if (self.closeHandler) self.closeHandler();
	}];
}

- (void)openSubscriptionView {
	[self.subscribeField becomeFirstResponder];
	
	[UIView animateWithDuration:.3 animations:^{
		self.subscribeViewHeightConstraint.constant = 50;
		self.parentViewBottomSpaceConstraint.constant = (RK_IS_IPHONE_5? 90: 155);
		[self.view layoutIfNeeded];
	} completion:nil];
}

- (void)closeSubscriptionView {
	[self.subscribeField resignFirstResponder];
	
	[UIView animateWithDuration:.3 animations:^{
		self.subscribeViewHeightConstraint.constant = 0;
		self.parentViewBottomSpaceConstraint.constant = 0;
		[self.view layoutIfNeeded];
	} completion:nil];
}

- (BOOL)subscriptionViewIsOpen {
	return self.subscribeViewHeightConstraint.constant > 0;
}

#pragma mark - Subscribe text field

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self closeSubscriptionView];
	[RKSocial subscribeWithEmail:textField.text completion:^(BOOL success) {
		if (success) {
			[self didSubscribe];
		}
	}];
	
	return YES;
}

@end
