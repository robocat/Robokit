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
#import "RKAboutRobocatViewController.h"
#import "UIApplication+RKAdditions.h"

@implementation RKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
	self.window.rootViewController = [[UIViewController alloc] init];
	
	[application enableShareSheetOnScreenshot];
	
	UIImageView *background = [[UIImageView alloc] initWithFrame:self.window.bounds];
	background.image = [UIImage imageNamed:@"Background"];
	background.contentMode = UIViewContentModeScaleAspectFill;
	[self.window.rootViewController.view addSubview:background];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
	[button setTitle:@"About Robocat" forState:UIControlStateNormal];
	button.frame = CGRectMake(20, 20, 280, 40);
	[button addTarget:self action:@selector(aboutRobocat:) forControlEvents:UIControlEventTouchUpInside];
	[self.window.rootViewController.view addSubview:button];
	
	[RKSocial initializeSocialFeaturesWithAppId:@"" appName:@"Test app" newInThisVersion:@"· news"];
	[RKAdView initializeAdsWithRevMobAppId:@"52308b3d41cc3374b0000003" testingMode:YES];
	
	RKAdView *adView = [[RKAdView alloc] initWithFrame:CGRectMake(0, self.window.frame.size.height - 50, 320, 50)];
	[self.window.rootViewController.view addSubview:adView];
	[adView loadAd];
	
	RKAboutRobocatViewController *aboutvc = [RKAboutRobocatViewController aboutRobocatViewController];
	[self.window.rootViewController presentViewController:aboutvc animated:YES completion:nil];
    
    return YES;
}

- (void)aboutRobocat:(id)sender {
	RKAboutRobocatViewController *viewController = [RKAboutRobocatViewController aboutRobocatViewController];
	[self.window.rootViewController presentViewController:viewController animated:YES completion:nil];
}

@end
