//
//  RKSocial.h
//  Ultraviolet2
//
//  Created by Ulrik Damm on 26/9/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kRKSocialDidUpdateFromPreviousVersionNotification;

extern NSString * const kRKSocialUpdatePreviousVersionKey;
extern NSString * const kRKSocialUpdateCurrentVersionKey;

enum {
    RKModalBackgroundStyleLight = 0,
    RKModalBackgroundStyleDark
};

typedef NSInteger RKModalBackgroundStyle;

@interface RKSocial : NSObject

+ (void)initializeSocialFeaturesWithAppId:(NSString *)appId appName:(NSString *)appName newInThisVersion:(NSString *)newsString;
+ (void)initializeFlurryWithAppId:(NSString *)flurryAppId;

+ (void)getNewestAppVersionFromAppStoreWithCompletion:(void (^)(NSString *version))completion;

+ (void)setModalBackgroundStyle:(RKModalBackgroundStyle)modalBackgroundStyle;
+ (RKModalBackgroundStyle)modalBackgroundStyle;

+ (NSString *)appId;
+ (NSString *)appName;
+ (NSString *)appVersion;
+ (NSString *)appBuildVersion;
+ (NSString *)supportEmailAddress;

+ (BOOL)hasLikedOnFacebook;
+ (BOOL)hasFollowedOnTwitter;
+ (BOOL)hasSubscribed;
+ (BOOL)hasRated;

+ (void)setShouldAutomaticallyShowFollowUs:(BOOL)shouldShow;
+ (void)setShouldAutomaticallyShowRateUs:(BOOL)shouldShow;
+ (void)setSupportEmailAddress:(NSString *)supportEmailAddress;
+ (void)setVersionFormatInWhatsNewPopup:(NSString *)versionFormat; /* %{build} is replaced with the build number, %{version} is replaced with the short version */

+ (void)likeOnFacebookWithCompletion:(void (^)(BOOL success))completion;
+ (void)subscribeWithEmail:(NSString *)email completion:(void (^)(BOOL success))completion;
+ (void)followOnTwitterWithCompletion:(void (^)(BOOL success))completion;
+ (void)rateAppWithCompletion:(void (^)(BOOL success))completion;

+ (void)showMoreAppsFromRobocat;
+ (NSURL *)linkToAppStorePageForAppId:(NSString *)appId;
+ (void)openAppStorePageForAppId:(NSString *)appId;

+ (void)showRateThisAppPopup;
+ (void)showFollowUsPopup;
+ (void)showWhatsNewPopup;
+ (void)showSendFeedbackPopup;

+ (BOOL)shouldShowRateView;
+ (BOOL)shouldShowFollowView;

@end
