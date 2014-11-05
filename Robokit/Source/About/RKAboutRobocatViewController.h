//
//  RSAboutRobocatViewController.h
//  Televised
//
//  Created by Kristian Andersen on 9/20/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKAboutRobocatViewController : UIViewController

// Default is YES
@property (assign, nonatomic) BOOL showsDoneButton;

+ (RKAboutRobocatViewController *)aboutRobocatViewController;

@end
