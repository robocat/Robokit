//
//  RKAdView.h
//  Robokit
//
//  Created by Ulrik Damm on 29/9/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RKAdView : UIView

/*!
 * Initializes ads. Call in applicationDidFinishLaunching if ad removal hasn't been purchased.
 * @param appId RevMob application ID.
 * @param testingMode Disable in production.
 */
+ (void)initializeAdsWithRevMobAppId:(NSString *)appId testingMode:(BOOL)testingMode;

/*!
 * Set the user location for optimized ads.
 */
+ (void)setUserLocation:(CLLocationCoordinate2D)coordinate;

/*!
 * Call to load an ad into the view.
 */
- (void)loadAd;

@end
