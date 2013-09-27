//
//  RKSocial.h
//  Ultraviolet2
//
//  Created by Ulrik Damm on 26/9/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKSocial : NSObject

+ (void)initializeSocialFeaturesWithAppId:(NSString *)appId appName:(NSString *)appName newInThisVersion:(NSString *)newsString;

+ (NSString *)appId;
+ (NSString *)appName;

+ (BOOL)hasLikedOnFacebook;
+ (BOOL)hasFollowedOnTwitter;
+ (BOOL)hasSubscribed;
+ (BOOL)hasRated;

+ (void)likeOnFacebookWithCompletion:(void (^)(BOOL success))completion;
+ (void)subscribeWithEmail:(NSString *)email completion:(void (^)(BOOL success))completion;
+ (void)followOnTwitterWithCompletion:(void (^)(BOOL success))completion;
+ (void)rateAppWithCompletion:(void (^)(BOOL success))completion;
+ (void)showMoreAppsFromRobocat;

+ (void)showRateThisAppPopup;
+ (void)showFollowUsPopup;

@end
