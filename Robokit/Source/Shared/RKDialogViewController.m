//
//  RKModalViewController.m
//  Robokit
//
//  Created by Kristian Andersen on 24/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKDialogViewController.h"

@interface RKDialogViewController ()

@property (copy, nonatomic) void (^closeHandler)(void);

@end

@implementation RKDialogViewController

- (void)presentInWindow:(UIWindow *)window withCloseHandler:(void (^)(void))closeHandler {
	self.view.alpha = 0;
	
	self.view.frame = window.bounds;
	[window addSubview:self.view];
	
	[UIView animateWithDuration:.3 animations:^{
		self.view.alpha = 1;
	}];
	
	self.closeHandler = closeHandler;
}

- (void)close {
	[UIView animateWithDuration:.3 animations:^{
		self.view.alpha = 0;
	} completion:^(BOOL finished) {
		[self.view removeFromSuperview];
		if (self.closeHandler) {
            self.closeHandler();
            self.closeHandler = nil;
        }
	}];
}

@end
