//
//  RobokitTests.m
//  RobokitTests
//
//  Created by Ulrik Damm on 27/9/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RKSocial.h"

@interface RKSocialTests : XCTestCase

@end

@implementation RKSocialTests


- (void)setUp {
    [super setUp];
    
    [NSUserDefaults resetStandardUserDefaults];
}

- (void)testUpdatesCurrentVersionOnUpgrade {
    NSString *previousVersion = @"0.1";
    [[NSUserDefaults standardUserDefaults] setObject:previousVersion forKey:@"kUserDefaultAppVersion"];
    
    [RKSocial initializeFlurryWithAppId:@"cat.robo.Robokit"];
    XCTAssertNotEqual(previousVersion, [RKSocial appVersion], @"Did not update app version on upgrade");
}

- (void)testLikeOnFacebookUpdatesLikedValue {
    [RKSocial likeOnFacebookWithCompletion:^(BOOL success) {
        XCTAssertTrue([RKSocial hasLikedOnFacebook], @"Liking on facebook doesn't update liked value");
    }];
}

- (void)testRateAppSetsRatedValue {
    [RKSocial rateAppWithCompletion:^(BOOL success) {
        XCTAssertTrue([RKSocial hasRated], @"Rating app doesn't update rated value");
    }];
}

- (void)testSubscribeWithEmailSetsSubscribedValue {
    [RKSocial subscribeWithEmail:@"test@test.dk" completion:^(BOOL success) {
        XCTAssertTrue([RKSocial hasSubscribed], @"Subscribing to newsletter doesn't update subscribed value");
    }];
}


@end
