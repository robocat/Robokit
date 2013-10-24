//
//  UIViewController+Robokit.m
//  Robokit
//
//  Created by Kristian Andersen on 24/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "UIViewController+Robokit.h"

@implementation UIViewController (Robokit)

+ (instancetype)initialViewControllerFromStoryboardWithName:(NSString *)storyboardName  {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
	id viewController = [storyboard instantiateInitialViewController];
	return viewController;
}

@end
