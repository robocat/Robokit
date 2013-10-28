//
//  RKModalViewController.h
//  Robokit
//
//  Created by Kristian Andersen on 24/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Robokit.h"

@interface RKDialogViewController : UIViewController

- (void)presentInWindow:(UIWindow *)window withCloseHandler:(void (^)(void))closeHandler;
- (void)presentModalInWindow:(UIWindow *)window withColseHandler:(void (^)(void))closeHandler;

- (void)close;
- (void)closeModal;

@end
