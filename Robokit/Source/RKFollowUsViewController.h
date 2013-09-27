//
//  FollowUsViewController.h
//  Thermo
//
//  Created by Ulrik Damm on 15/10/12.
//
//

#import <UIKit/UIKit.h>

@interface RKFollowUsViewController : UIViewController

+ (RKFollowUsViewController *)followUsViewControllerWithMailchimpId:(NSString *)mailchimpId APIKey:(NSString *)apiKey;
- (void)presentInWindow:(UIWindow *)window withCloseHandler:(void (^)(void))closeHandler;

@end
