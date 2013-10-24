//
//  RSAboutRobocatViewController.m
//  Televised
//
//  Created by Kristian Andersen on 9/20/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKAboutRobocatViewController.h"
#import "RKLocalization.h"
#import "RKSocial.h"
#import "Flurry.h"
#import "UIViewController+Robokit.h"

@interface RKAboutRobocatViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;
@property (nonatomic, weak) IBOutlet UIButton *buttonReview;
@property (nonatomic, weak) IBOutlet UIButton *buttonTwitter;
@property (nonatomic, weak) IBOutlet UIButton *buttonFacebook;
@property (nonatomic, weak) IBOutlet UIButton *buttonMoreApps;
@property (nonatomic, weak) IBOutlet UIButton *buttonReceiveNews;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinnerView;
@property (nonatomic, weak) IBOutlet UILabel *versionLabel;

- (IBAction)review:(id)sender;
- (IBAction)twitter:(id)sender;
- (IBAction)facebook:(id)sender;
- (IBAction)moreApps:(id)sender;

@end

@implementation RKAboutRobocatViewController

#pragma mark - UIViewController

+ (RKAboutRobocatViewController *)aboutRobocatViewController {
    return [self initialViewControllerFromStoryboardWithName:@"RKAboutRobocatViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[Flurry logEvent:@"Did open About Robocat" timed:YES];
    
    if ([RKSocial hasFollowedOnTwitter]) {
        [self haveFollowedOnTwitter];
    }
    
    if ([RKSocial hasLikedOnFacebook]) {
        [self haveLikedOnFacebook];
    }
	
	if ([RKSocial hasRated]) {
		[self haveRated];
	}
    
    [self.buttonReview.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.buttonTwitter.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.buttonFacebook.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.buttonMoreApps.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.buttonReceiveNews.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
	self.closeButton.title = RKLocalizedFromTable(@"RC_ABOUT_BUTTON_CLOSE", NSStringFromClass(self.class));
    [self.buttonReview setTitle:RKLocalizedFromTable(@"RC_ABOUT_BUTTON_REVIEW", NSStringFromClass(self.class)) forState:UIControlStateNormal];
    [self.buttonTwitter setTitle:RKLocalizedFromTable(@"RC_ABOUT_BUTTON_TWITTER", NSStringFromClass(self.class)) forState:UIControlStateNormal];
    [self.buttonFacebook setTitle:RKLocalizedFromTable(@"RC_ABOUT_BUTTON_FACEBOOK", NSStringFromClass(self.class)) forState:UIControlStateNormal];
    [self.buttonMoreApps setTitle:RKLocalizedFromTable(@"RC_ABOUT_BUTTON_MORE_APPS", NSStringFromClass(self.class)) forState:UIControlStateNormal];
    [self.buttonReceiveNews setTitle:RKLocalizedFromTable(@"RC_ABOUT_BUTTON_NEWSLETTER", NSStringFromClass(self.class)) forState:UIControlStateNormal];
    
    [self.versionLabel setText:[NSString stringWithFormat:@"%@ %@\nCopyright © 2013 Robocat\nAll rights reserved", [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]]];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(320.0f, 664.0f);
    self.scrollView.scrollEnabled = YES;
}

#pragma mark - RSAboutRobocatViewController ()

- (void)haveFollowedOnTwitter {
    [self.buttonTwitter setBackgroundImage:[UIImage imageNamed:@"Button Blue"] forState:UIControlStateNormal];
    [self.buttonTwitter setTitle:RKLocalizedFromTable(@"RC_ABOUT_BUTTON_FOLLOWED", NSStringFromClass(self.class)) forState:UIControlStateNormal];
}

- (void)haveLikedOnFacebook {
    [self.buttonFacebook setBackgroundImage:[UIImage imageNamed:@"Button Dark Blue"] forState:UIControlStateNormal];
    [self.buttonFacebook setTitle:RKLocalizedFromTable(@"RC_ABOUT_BUTTON_LIKED", NSStringFromClass(self.class)) forState:UIControlStateNormal];
}

- (void)haveRated {
    [self.buttonReview setBackgroundImage:[UIImage imageNamed:@"Button Red"] forState:UIControlStateNormal];
	[self.buttonReview setTitle:RKLocalizedFromTable(@"RC_ABOUT_BUTTON_REVIEWED", NSStringFromClass(self.class)) forState:UIControlStateNormal];
}


#pragma mark - Actions

- (IBAction)review:(id)sender {
	[Flurry logEvent:@"Did review from About Robocat"];
	
	[RKSocial rateAppWithCompletion:^(BOOL success) {
		if (success) {
			[self haveRated];
		}
	}];
}

- (IBAction)twitter:(id)sender {
    [self.spinnerView startAnimating];
	
	[Flurry logEvent:@"Did follow on Twitter from About Robocat"];
    
    [RKSocial followOnTwitterWithCompletion:^(BOOL success) {
		[self.spinnerView stopAnimating];
		
		if (success) {
			[self haveFollowedOnTwitter];
		}
	}];
}

- (IBAction)facebook:(id)sender {
	[Flurry logEvent:@"Did like on Facebook from About Robocat"];
	
	[RKSocial likeOnFacebookWithCompletion:^(BOOL success) {
		if (success) {
			[self haveLikedOnFacebook];
		}
	}];
}

- (IBAction)moreApps:(id)sender {
	[Flurry logEvent:@"Did open 'more apps' from About Robocat"];
	
	[RKSocial showMoreAppsFromRobocat];
}

- (IBAction)dismiss:(id)sender {
	[Flurry logEvent:@"Did open About Robocat"];
	
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
