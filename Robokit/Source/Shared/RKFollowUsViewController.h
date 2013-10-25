//
//  FollowUsViewController.h
//  Thermo
//
//  Created by Ulrik Damm on 15/10/12.
//
//

#import <UIKit/UIKit.h>
#import "RKDialogViewController.h"

@interface RKFollowUsViewController : RKDialogViewController

+ (RKFollowUsViewController *)followUsViewControllerWithMailchimpId:(NSString *)mailchimpId APIKey:(NSString *)apiKey;

@end
