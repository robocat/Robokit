//
//  UIApplication+RKShareSheet.h
//  Robokit
//
//  Created by Ulrik Damm on 16/12/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RKApplicationShareSheetDelegate <UIApplicationDelegate>

@optional

- (NSString *)stringToAddToRobokitScreenshotShareSheet;

- (BOOL)shouldShowRobokitScreenshotShareSheet;

- (NSArray *)activitiesToShowInRobokitScreenshotShareSheet;

@end

@interface UIApplication (RKShareSheet)

- (void)enableShareSheetOnScreenshot;

@end
