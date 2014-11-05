//
//  RSAboutRobocatViewController.h
//  Televised
//
//  Created by Kristian Andersen on 9/20/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKAboutRobocatViewController : UIViewController
@property (copy, nonatomic) void(^dismissAction)(RKAboutRobocatViewController *);

// Default is YES
@property (assign, nonatomic) BOOL showsDoneButton;

+ (RKAboutRobocatViewController *)aboutRobocatViewController;
+ (RKAboutRobocatViewController *)aboutRobocatViewControllerWithDismissAction:(void (^)(RKAboutRobocatViewController *))action;

@end
