//
//  RKCatnipStoryViewController.h
//  Robokit
//
//  Created by Kristian Andersen on 28/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKDialogViewController.h"
#import "RKCatnipStory.h"
#import "RKCatnipSDK.h"

@interface RKCatnipStoryViewController : RKDialogViewController

+ (RKCatnipStoryViewController *)catnipStoryViewControllerWithStory:(RKCatnipStory *)story;

@end
