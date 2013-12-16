//
//  UIApplication+RKShareSheet.m
//  Robokit
//
//  Created by Ulrik Damm on 16/12/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "UIApplication+RKAdditions.h"

@implementation UIApplication (RKAdditions)

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

+ (NSString *)rkDeviceTokenFromData:(NSData *)data {
	char tokenString[65] = {};
	const uint8_t *bytes = data.bytes;
	
	int i;
	for (i = 0; i < 32; i++) {
		uint8_t ls = bytes[i] & 0x0f;
		uint8_t ms = bytes[i] >> 4;
		tokenString[i * 2 + 0] = ('0' + ms > '9'? 'A' + (ms - 10): '0' + ms);
		tokenString[i * 2 + 1] = ('0' + ls > '9'? 'A' + (ls - 10): '0' + ls);
	}
	
	NSString *deviceToken = [NSString stringWithCString:tokenString encoding:NSASCIIStringEncoding];
	
	return deviceToken;
}

@end
