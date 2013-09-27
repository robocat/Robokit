//
//  RatingViewController.h
//  Thermo
//
//  Created by Willi Wu on 21/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKRatingViewController : UIViewController

+ (RKRatingViewController *)ratingViewController;

- (void)presentInWindow:(UIWindow *)window withCloseHandler:(void (^)(void))closeHandler;

@end
