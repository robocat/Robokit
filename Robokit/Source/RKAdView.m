//
//  RKAdView.m
//  Robokit
//
//  Created by Ulrik Damm on 29/9/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKAdView.h"
#import <iAd/iAd.h>

#ifdef COCOAPODS
#import <RevMobAds.h>
#else
#import <RevMobAds/RevMobAds.h>
#endif

@interface RKAdView () <ADBannerViewDelegate>

@property (strong, nonatomic) RevMobBannerView *banner;
@property (strong, nonatomic) ADBannerView *iAdBanner;

@end

@implementation RKAdView

+ (void)initializeAdsWithRevMobAppId:(NSString *)appId testingMode:(BOOL)testingMode {
	[RevMobAds startSessionWithAppID:appId];
	if (testingMode) [[RevMobAds session] setTestingMode:RevMobAdsTestingModeWithAds];
}

- (void)loadAd {
	if ([self.class iAdsAvailable]) {
		self.iAdBanner = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
		self.iAdBanner.delegate = self;
		[self addSubview:self.iAdBanner];
	} else {
		[self loadRevMob];
	}
}

- (void)loadRevMob {
	self.banner = [[RevMobAds session] bannerView];
	self.banner.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	[self addSubview:self.banner];
	
	[self.banner loadWithSuccessHandler:^(RevMobBannerView *banner) {
		
	} andLoadFailHandler:^(RevMobBannerView *banner, NSError *error) {
		[self loadCustomAd];
	} onClickHandler:^(RevMobBannerView *banner) {
		
	}];
}

- (void)loadCustomAd {
	UIButton *thermoButton = [UIButton buttonWithType:UIButtonTypeCustom];
	thermoButton.frame = CGRectMake(0, 0, 320, 50);
	[thermoButton setBackgroundImage:[UIImage imageNamed:@"thermo_ad"] forState:UIControlStateNormal];
	[thermoButton addTarget:self action:@selector(thermoAdPressed:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:thermoButton];
}

- (void)thermoAdPressed:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=414215658"]];
}

+ (BOOL)iAdsAvailable {
    NSArray *supportedCountries = @[ @"ES", @"US", @"UK", @"CA", @"FR", @"DE", @"IT", @"JP" ];
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
	
    return [supportedCountries containsObject:countryCode];
}

#pragma mark - iAd delegate

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	[self.iAdBanner removeFromSuperview];
	[self loadRevMob];
}

@end
