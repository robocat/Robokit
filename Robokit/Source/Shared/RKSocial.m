//
//  RKSocial.m
//  Ultraviolet2
//
//  Created by Ulrik Damm on 26/9/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKSocial.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "RKRatingViewController.h"
#import "RKFollowUsViewController.h"
#import "RKFeedbackViewController.h"
#import "RKDispatch.h"
#import "Flurry.h"

NSString * const kRKSocialDidUpdateFromPreviousVersionNotification = @"cat.robo.kRKSocialDidUpdateFromPreviousVersionNotification";

NSString * const kRKSocialUpdatePreviousVersionKey = @"cat.robo.kRKSocialUpdatePreviousVersionKey";
NSString * const kRKSocialUpdateCurrentVersionKey = @"cat.robo.kRKSocialUpdateCurrentVersionKey";

#define RKRobocatViewControllerHaveFollowedKey @"RKRobocatViewControllerHaveFollowedKey"
#define RKRobocatViewControllerHaveLikedKey @"RKRobocatViewControllerHaveLikedKey"
#define RKRobocatViewControllerHaveSubscribedKey @"RKRobocatViewControllerHaveSubscribedKey"
#define RKRobocatViewControllerHaveRatedKey @"RKRobocatViewControllerHaveRatedKey"

#define kFirstUseDate @"kFirstUseDate"
#define kRatedCurrentVersion @"kRatedCurrentVersion"
#define kRatedCurrentVersionDate @"kRatedCurrentVersionDate"
#define kUserDefaultAppVersion @"kUserDefaultAppVersion"
#define kHaveFollowed @"kHaveFollowed"

#define kDaysToRatePrompt 2
#define kDaysToFollowPrompt 2

#define kMailchimpAPIKey @"0707e00bae61425cb207a028f7730a89-us1"
#define kMailchimpListId @"f864e02a1c"

// User Identity

#define kUserIdentityEmailAddressKey @"kUserIdentityEmailAddressKey"
#define kUserIdentityTwitterUsernameKey @"kUserIdentityTwitterUsernameKey"
#define kUserIdentityFacebookUsernameKey @"kUserIdentityFacebookUsernameKey"
#define kUserIdentityFullNameKey @"kUserIdentityFullNameKey"

@interface RKSocial () <UIAlertViewDelegate>

@property (strong, nonatomic) NSString *appId;
@property (strong, nonatomic) NSString *appName;
@property (strong, nonatomic) NSString *appVersion;
@property (strong, nonatomic) NSString *whatsNew;
@property (strong, nonatomic) NSString *facebookAppId;
@property (assign, nonatomic) BOOL isFirstLaunch;
@property (assign, nonatomic) RKModalBackgroundStyle backgroundStyle;

@end

@implementation RKSocial

+ (RKSocial *)sharedInstance {
	static RKSocial *instance;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[RKSocial alloc] init];
	});
	
	return instance;
}

+ (void)initializeSocialFeaturesWithAppId:(NSString *)appId appName:(NSString *)appName newInThisVersion:(NSString *)newsString {
	[[self sharedInstance] setWhatsNew:newsString];
	[[self sharedInstance] setAppId:appId];
	[[self sharedInstance] setAppName:appName];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults doubleForKey:kFirstUseDate] == 0) {
		[defaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kFirstUseDate];
        [[self sharedInstance] setIsFirstLaunch:YES];
	}
	
	NSString *versionString = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    NSString *previousVersionString = [defaults objectForKey:kUserDefaultAppVersion];
	
    if (previousVersionString && ![previousVersionString isEqualToString:versionString]) {
        [defaults setBool:NO forKey:kRatedCurrentVersion];
        [defaults setBool:NO forKey:kHaveFollowed];
        [defaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kFirstUseDate];
        [self showWhatsNewPopup];
    } else if (!previousVersionString) {
        previousVersionString = @"";
    }
    
	[defaults setValue:versionString forKey:kUserDefaultAppVersion];
	[defaults synchronize];
    
    [[self sharedInstance] setAppVersion:versionString];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kRKSocialDidUpdateFromPreviousVersionNotification
                                                        object:nil
                                                      userInfo:@{kRKSocialUpdatePreviousVersionKey: previousVersionString, kRKSocialUpdateCurrentVersionKey: versionString}];
	
	[RKDispatch after:5 callback:^{
		if ([self shouldShowRateView]) {
			[self showRateThisAppPopup];
		} else if ([self shouldShowFollowView]) {
			[self showFollowUsPopup];
		}
	}];
	
	[[NSNotificationCenter defaultCenter] addObserver:[self sharedInstance] selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:[self sharedInstance] selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
	[[self sharedInstance] applicationDidBecomeActive:nil];
}

+ (void)initializeFlurryWithAppId:(NSString *)flurryAppId {
	[Flurry setAppVersion:[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]];
	[Flurry setSecureTransportEnabled:YES];
	[Flurry startSession:flurryAppId];
}

+ (void)setModalBackgroundStyle:(RKModalBackgroundStyle)backgroundStyle {
    [[[self class] sharedInstance] setBackgroundStyle:backgroundStyle];
}

+ (RKModalBackgroundStyle)modalBackgroundStyle {
    return [[[self class] sharedInstance] backgroundStyle];
}

+ (void)showRateThisAppPopup {
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRatedCurrentVersion];
	[[NSUserDefaults standardUserDefaults] setDouble:[[NSDate date] timeIntervalSince1970] forKey:kRatedCurrentVersionDate];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	__block RKRatingViewController *ratingViewController = [RKRatingViewController ratingViewController];
	
	[ratingViewController presentInWindow:[[UIApplication sharedApplication] keyWindow] withCloseHandler:^{
		ratingViewController = nil;
	}];
}

+ (void)showFollowUsPopup {
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHaveFollowed];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	__block RKFollowUsViewController *followUsViewController = [RKFollowUsViewController followUsViewControllerWithMailchimpId:kMailchimpListId APIKey:kMailchimpAPIKey];
	
	[followUsViewController presentInWindow:[[UIApplication sharedApplication] keyWindow] withCloseHandler:^{
		followUsViewController = nil;
	}];
}

+ (void)showWhatsNewPopup {
	NSString *versionString = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
	NSString *title = [NSString stringWithFormat:@"What's New in %@ %@?", [[self sharedInstance] appName], versionString];
	
	[[[UIAlertView alloc] initWithTitle:title message:[[self sharedInstance] whatsNew] delegate:[self sharedInstance] cancelButtonTitle:@"Continue" otherButtonTitles:@"Rate ★", nil] show];
}

+ (NSString *)appId {
	return [[self sharedInstance] appId];
}

+ (NSString *)appName {
	return [[self sharedInstance] appName];
}

+ (NSString *)appVersion {
    return [[self sharedInstance] appVersion];
}

+ (BOOL)hasLikedOnFacebook {
	return [[NSUserDefaults standardUserDefaults] boolForKey:RKRobocatViewControllerHaveLikedKey];
}

+ (BOOL)hasFollowedOnTwitter {
	return [[NSUserDefaults standardUserDefaults] boolForKey:RKRobocatViewControllerHaveFollowedKey];
}

+ (BOOL)hasSubscribed {
	return [[NSUserDefaults standardUserDefaults] boolForKey:RKRobocatViewControllerHaveSubscribedKey];
}

+ (BOOL)hasRated {
	return [[NSUserDefaults standardUserDefaults] boolForKey:RKRobocatViewControllerHaveRatedKey];
}

+ (void)likedOnFacebook {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:RKRobocatViewControllerHaveLikedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)likeOnFacebookWithCompletion:(void (^)(BOOL success))completion {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/235384996484325"]];
    [self likedOnFacebook];
    
	if (completion) completion(YES);
}

+ (void)followOnTwitterWithCompletion:(void (^)(BOOL success))completion {
	ACAccountStore *accountStore = [[ACAccountStore alloc] init];
	ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	
	[accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
		if (error) {
			[self openTwitterApp];
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:RKRobocatViewControllerHaveFollowedKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
			if (completion) completion(YES);
			return;
		}
		
		if (!granted) {
			if (completion) completion(NO);
			return;
		}
		
		NSArray *accounts = [accountStore accountsWithAccountType:accountType];
		
		if ([accounts count] == 0) {
			[self openTwitterApp];
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:RKRobocatViewControllerHaveFollowedKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
			if (completion) completion(YES);
			return;
		}
		
		ACAccount *twitterAccount = accounts[0];
        [[NSUserDefaults standardUserDefaults] setObject:twitterAccount.username forKey:kUserIdentityTwitterUsernameKey];
        [[NSUserDefaults standardUserDefaults] setObject:twitterAccount.userFullName forKey:kUserIdentityFullNameKey];
		
		SLRequest *followRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"] parameters:@{ @"screen_name" : @"robocat", @"follow" : @"true" }];
		[followRequest setAccount:twitterAccount];
		
		[followRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
			[RKDispatch mainQueue:^{
				if (!error) {
					[[NSUserDefaults standardUserDefaults] setBool:YES forKey:RKRobocatViewControllerHaveFollowedKey];
					[[NSUserDefaults standardUserDefaults] synchronize];
				}
				
				if (completion) completion(error == nil);
			}];
		}];
	}];
}

+ (void)subscribeWithEmail:(NSString *)email completion:(void (^)(BOOL success))completion {
	if (email == nil || [email isEqualToString:@""]) {
		completion(NO);
		return;
	}
    
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:kUserIdentityEmailAddressKey];
	
	NSString *method = @"listSubscribe";
	NSString *urlString = [NSString stringWithFormat:@"https://us1.api.mailchimp.com/1.2/?output=json&method=%@&apikey=%@", method, kMailchimpAPIKey];
	urlString = [NSString stringWithFormat:@"%@&send_welcome=false&double_optin=false&id=%@&merge_vars=&email_address=%@", urlString, kMailchimpListId, email];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
		if (!error) {
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:RKRobocatViewControllerHaveSubscribedKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		
		if (completion) completion(error == nil);
	}];
}

+ (void)rateAppWithCompletion:(void (^)(BOOL success))completion {
    NSString *reviewURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", self.appId];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:RKRobocatViewControllerHaveRatedKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	if (completion) completion(YES);
}

+ (void)showMoreAppsFromRobocat {
	NSString *appsURL = @"itms-apps://itunes.com/apps/robocat";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:appsURL]];
}

+ (void)showSendFeedbackPopup {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHaveFollowed];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	__block RKFeedbackViewController *feedbackViewController = [RKFeedbackViewController feedbackViewController];
	
	[feedbackViewController presentInWindow:[[UIApplication sharedApplication] keyWindow] withCloseHandler:^{
		feedbackViewController = nil;
	}];
}

+ (BOOL)shouldShowRateView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[self sharedInstance] isFirstLaunch]) {
        return NO;
    }
    
	if ([defaults boolForKey:kRatedCurrentVersion]) {
		return NO;
	}
	
	NSDate *dateOfFirstLaunch = [NSDate dateWithTimeIntervalSince1970:[defaults doubleForKey:kFirstUseDate]];
	NSTimeInterval timeSinceFirstLaunch = [[NSDate date] timeIntervalSinceDate:dateOfFirstLaunch];
	NSTimeInterval timeUntilRate = 60 * 60 * 24 * kDaysToRatePrompt;
	
	if (timeSinceFirstLaunch < timeUntilRate) {
		return NO;
	}
	
	return YES;
}

+ (BOOL)shouldShowFollowView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
	if ([defaults boolForKey:kRatedCurrentVersion] == NO || [defaults boolForKey:kHaveFollowed] == YES) {
		return NO;
	}
	
	if ([defaults boolForKey:RKRobocatViewControllerHaveFollowedKey] == YES
		&& [defaults boolForKey:RKRobocatViewControllerHaveLikedKey] == YES) {
		return NO;
	}
	
	if ([defaults objectForKey:kRatedCurrentVersionDate] == nil) {
		[defaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kRatedCurrentVersionDate];
		return NO;
	}
	
	NSDate *dateOfRate = [NSDate dateWithTimeIntervalSince1970:[defaults doubleForKey:kRatedCurrentVersionDate]];
	NSTimeInterval timeSinceRate = [[NSDate date] timeIntervalSinceDate:dateOfRate];
	NSTimeInterval timeUntilFollow = 60 * 60 * 24 * kDaysToFollowPrompt;
	
	if (timeSinceRate < timeUntilFollow) {
		return NO;
	}
	
	return YES;
}

#pragma mark - Helpers

+ (void)openTwitterApp {
    NSString *username = @"robocat";
	NSURL *twitterURL = [NSURL URLWithString:[NSString stringWithFormat:@"twitter://%@", username]];
	
	if ([[UIApplication sharedApplication] canOpenURL:twitterURL]) {
		[[UIApplication sharedApplication] openURL:twitterURL];
	} else {
		NSURL *safariURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.twitter.com/%@", username]];
		[[UIApplication sharedApplication] openURL:safariURL];
	}
}

#pragma mark - Observers

- (void)applicationDidBecomeActive:(NSNotification *)notification {
	[Flurry logEvent:@"Did open application" timed:YES];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
	[Flurry logEvent:@"Did open application"];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[RKSocial rateAppWithCompletion:nil];
	}
}

@end
