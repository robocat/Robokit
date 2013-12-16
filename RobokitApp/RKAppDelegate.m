//
//  RKAppDelegate.m
//  Robokit
//
//  Created by Ulrik Damm on 27/9/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKAppDelegate.h"
#import "Robokit.h"
#import "RKAdView.h"
#import "RKCatnipSDK.h"
#import "UIApplication+RKShareSheet.h"

@implementation RKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
	[application enableShareSheetOnScreenshot];
	
	UIImageView *background = [[UIImageView alloc] initWithFrame:self.window.bounds];
	background.image = [UIImage imageNamed:@"Background"];
	background.contentMode = UIViewContentModeScaleAspectFill;
	[self.window addSubview:background];
	
	[RKSocial initializeSocialFeaturesWithAppId:@"" appName:@"Test app" newInThisVersion:@"· news"];
	[RKAdView initializeAdsWithRevMobAppId:@"52308b3d41cc3374b0000003" testingMode:YES];
    [[RKCatnipSDK sharedSDK] takeOff:@"9205e40339b200fb867f5f1c77d0f612"];
	
	
	UIViewController *viewController = [[UIViewController alloc] init];
	self.window.rootViewController = viewController;
	[self.window addSubview:viewController.view];
	
	RKAdView *adView = [[RKAdView alloc] initWithFrame:CGRectMake(0, self.window.frame.size.height - 50, 320, 50)];
	[viewController.view addSubview:adView];
	[adView loadAd];
	
//	[RKSocial showFollowUsPopup];
//    [RKSocial showRateThisAppPopup];
	[[RKCatnipSDK sharedSDK] checkForUpdates];
    
    
    return YES;
}

@end
