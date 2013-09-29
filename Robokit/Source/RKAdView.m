//
//  RKAdView.m
//  Robokit
//
//  Created by Ulrik Damm on 29/9/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKAdView.h"
#import <RevMobAds/RevMobAds.h>

@interface RKAdView ()

@property (strong, nonatomic) RevMobBannerView *banner;

@end

@implementation RKAdView

+ (void)initializeAdsWithRevMobAppId:(NSString *)appId testingMode:(BOOL)testingMode {
	[RevMobAds startSessionWithAppID:appId];
	if (testingMode) [[RevMobAds session] setTestingMode:RevMobAdsTestingModeWithAds];
}

- (void)loadAd {
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

@end