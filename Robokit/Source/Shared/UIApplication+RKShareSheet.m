//
//  UIApplication+RKShareSheet.m
//  Robokit
//
//  Created by Ulrik Damm on 16/12/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "UIApplication+RKShareSheet.h"

@implementation UIApplication (RKShareSheet)

- (void)enableShareSheetOnScreenshot {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rkUserDidTakeScreenshot:) name:UIApplicationUserDidTakeScreenshotNotification object:self];
}

- (void)rkUserDidTakeScreenshot:(NSNotification *)notification {
	if ([self.delegate respondsToSelector:@selector(shouldShowRobokitScreenshotShareSheet)]) {
		if (![(id<RKApplicationShareSheetDelegate>)self.delegate shouldShowRobokitScreenshotShareSheet]) return;
	}
	
	UIGraphicsBeginImageContextWithOptions([[UIScreen mainScreen] bounds].size, YES, [[UIScreen mainScreen] scale]);
	[[[[UIApplication sharedApplication] keyWindow] layer] renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	NSArray *activities = nil;
	NSArray *items = @[ image ];
	
	if ([self.delegate respondsToSelector:@selector(stringToAddToRobokitScreenshotShareSheet)]) {
		items = [items arrayByAddingObject:[(id<RKApplicationShareSheetDelegate>)self.delegate stringToAddToRobokitScreenshotShareSheet]];
	}
	
	if ([self.delegate respondsToSelector:@selector(activitiesToShowInRobokitScreenshotShareSheet)]) {
		activities = [(id<RKApplicationShareSheetDelegate>)self.delegate activitiesToShowInRobokitScreenshotShareSheet];
	}
	
	UIActivityViewController *shareSheet = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:activities];
	[[[self keyWindow] rootViewController] presentViewController:shareSheet animated:YES completion:nil];
}

@end
