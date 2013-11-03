//
//  UIViewController+Robokit.m
//  Robokit
//
//  Created by Kristian Andersen on 24/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "UIViewController+RKAdditions.h"

@implementation UIViewController (RKAdditions)

+ (instancetype)rk_initialViewControllerFromStoryboardWithName:(NSString *)storyboardName  {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
	id viewController = [storyboard instantiateInitialViewController];
	return viewController;
}

@end
