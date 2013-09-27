//
//  RKAppDelegate.m
//  Robokit
//
//  Created by Ulrik Damm on 27/9/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKAppDelegate.h"
#import "RKSocial.h"

@implementation RKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
	UIImageView *background = [[UIImageView alloc] initWithFrame:self.window.bounds];
	background.image = [UIImage imageNamed:@"Background"];
	background.contentMode = UIViewContentModeScaleAspectFill;
	[self.window addSubview:background];
	
	[RKSocial initializeSocialFeaturesWithAppId:@"" appName:@"Test app" newInThisVersion:@"· news"];
	
	[RKSocial showRateThisAppPopup];
	
    return YES;
}

@end
