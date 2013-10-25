//
//  UIViewController+Robokit.h
//  Robokit
//
//  Created by Kristian Andersen on 24/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Robokit)

/*!
 * Returns the initial UIViewController of a UIStoryboard
 * with the given name.
 * @param storyboardName The name of the storyboard
 * @return The initial UIViewController from the storyboard
 */
+ (instancetype)initialViewControllerFromStoryboardWithName:(NSString *)storyboardName;

@end
