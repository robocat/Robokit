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
#import "RKDispatch.h"

#define RKRobocatViewControllerHaveFollowedKey @"RKRobocatViewControllerHaveFollowedKey"
#define RKRobocatViewControllerHaveLikedKey @"RKRobocatViewControllerHaveLikedKey"
#define RKRobocatViewControllerHaveSubscribedKey @"RKRobocatViewControllerHaveSubscribedKey"
#define RKRobocatViewControllerHaveRatedKey @"RKRobocatViewControllerHaveRatedKey"

#define kFirstUseDate @"kFirstUseDate"
#define kRatedCurrentVersion @"kRatedCurrentVersion"
#define kRatedCurrentVersionDate @"kRatedCurrentVersionDate"
#define kFollowShown @"kFollowShown"
#define kHaveFollowed @"kHaveFollowed"
#define kUserDefaultAppVersion @"kUserDefaultAppVersion"

#define kDaysToRatePrompt 2
#define kDaysToFollowPrompt 2

#define kMailchimpAPIKey @"0707e00bae61425cb207a028f7730a89-us1"
#define kMailchimpListId @"f864e02a1c"

static NSString *RKAppId;
static NSString *RKAppName;

@implementation RKSocial

+ (void)initializeSocialFeaturesWithAppId:(NSString *)appId appName:(NSString *)appName newInThisVersion:(NSString *)newsString {
	RKAppId = appId;
	RKAppName = appName;
	
	NSString *versionString = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
	
	if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultAppVersion]) {
		if (![[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultAppVersion] isEqualToString:versionString]) {
			[[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRatedCurrentVersion];
			[[NSUserDefaults standardUserDefaults] setBool:NO forKey:kFollowShown];
			[[NSUserDefaults standardUserDefaults] setBool:NO forKey:kHaveFollowed];
			[[NSUserDefaults standardUserDefaults] setDouble:[[NSDate date] timeIntervalSince1970] forKey:kFirstUseDate];
			NSString *versionString = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
			NSString *title = [NSString stringWithFormat:@"What's New in %@ %@?", RKAppName, versionString];
			
			[[[UIAlertView alloc] initWithTitle:title message:newsString delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Rate ★", nil] show];
		}
	}
	
	[[NSUserDefaults standardUserDefaults] setValue:versionString forKey:kUserDefaultAppVersion];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[RKDispatch after:5 callback:^{
		if ([self shouldShowRateView]) {
			[self showRateThisAppPopup];
		} else if ([self shouldShowFollowView]) {
			[self showFollowUsPopup];
		}
	}];
}

+ (void)showRateThisAppPopup {
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRatedCurrentVersion];
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

+ (NSString *)appId {
	return RKAppId;
}

+ (NSString *)appName {
	return RKAppName;
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

+ (void)likeOnFacebookWithCompletion:(void (^)(BOOL success))completion {
	if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/235384996484325"]]) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:RKRobocatViewControllerHaveLikedKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	if (completion) completion(YES);
}

+ (void)subscribeWithEmail:(NSString *)email completion:(void (^)(BOOL success))completion {
	if (email == nil || [email isEqualToString:@""]) {
		completion(NO);
		return;
	}
	
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
		
		SLRequest *followRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"] parameters:@{ @"screen_name" : @"robocat", @"follow" : @"true" }];
		[followRequest setAccount:twitterAccount];
		
		[followRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
			if (!error) {
				[[NSUserDefaults standardUserDefaults] setBool:YES forKey:RKRobocatViewControllerHaveFollowedKey];
				[[NSUserDefaults standardUserDefaults] synchronize];
			}
			
			if (completion) completion(error == nil);
		}];
	}];
}

+ (void)rateAppWithCompletion:(void (^)(BOOL success))completion {
	NSString *reviewURL = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", self.appId];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:RKRobocatViewControllerHaveRatedKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	if (completion) completion(YES);
}

+ (void)showMoreAppsFromRobocat {
	NSString *appsURL = @"itms-apps://itunes.com/apps/robocat";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:appsURL]];
}

+ (BOOL)shouldShowRateView {
	if ([[NSUserDefaults standardUserDefaults] doubleForKey:kFirstUseDate] == 0) {
		[[NSUserDefaults standardUserDefaults] setDouble:[[NSDate date] timeIntervalSince1970] forKey:kFirstUseDate];
		return NO;
	}
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:kRatedCurrentVersion]) {
		return NO;
	}
	
	NSDate *dateOfFirstLaunch = [NSDate dateWithTimeIntervalSince1970:[[NSUserDefaults standardUserDefaults] doubleForKey:kFirstUseDate]];
	NSTimeInterval timeSinceFirstLaunch = [[NSDate date] timeIntervalSinceDate:dateOfFirstLaunch];
	NSTimeInterval timeUntilRate = 60 * 60 * 24 * kDaysToRatePrompt;
	
	if (timeSinceFirstLaunch < timeUntilRate) {
		return NO;
	}
	
	return YES;
}

+ (BOOL)shouldShowFollowView {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:kFollowShown] == YES || [[NSUserDefaults standardUserDefaults] boolForKey:kRatedCurrentVersion] == NO || [[NSUserDefaults standardUserDefaults] boolForKey:kHaveFollowed] == YES) {
		return NO;
	}
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:RKRobocatViewControllerHaveFollowedKey] == YES
		&& [[NSUserDefaults standardUserDefaults] boolForKey:RKRobocatViewControllerHaveLikedKey] == YES) {
		return NO;
	}
	
	if ([[NSUserDefaults standardUserDefaults] objectForKey:kRatedCurrentVersionDate] == nil) {
		[[NSUserDefaults standardUserDefaults] setDouble:[[NSDate date] timeIntervalSince1970] forKey:kRatedCurrentVersionDate];
		return NO;
	}
	
	NSDate *dateOfRate = [NSDate dateWithTimeIntervalSince1970:[[NSUserDefaults standardUserDefaults] doubleForKey:kRatedCurrentVersionDate]];
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

@end
