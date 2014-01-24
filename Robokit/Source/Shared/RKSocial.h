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

+ (BOOL)hasLikedOnFacebook;
+ (BOOL)hasFollowedOnTwitter;
+ (BOOL)hasSubscribed;
+ (BOOL)hasRated;

+ (void)setShouldShowFollowUs:(BOOL)shouldShow;

+ (void)likeOnFacebookWithCompletion:(void (^)(BOOL success))completion;
+ (void)subscribeWithEmail:(NSString *)email completion:(void (^)(BOOL success))completion;
+ (void)followOnTwitterWithCompletion:(void (^)(BOOL success))completion;
+ (void)rateAppWithCompletion:(void (^)(BOOL success))completion;
+ (void)showMoreAppsFromRobocat;
+ (void)openAppStorePageForAppId:(NSString *)appId;

+ (void)showRateThisAppPopup;
+ (void)showFollowUsPopup;
+ (void)showWhatsNewPopup;
+ (void)showSendFeedbackPopup;

@end
