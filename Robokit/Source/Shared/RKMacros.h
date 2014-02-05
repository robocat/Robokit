//
//  RKMacros.h
//  Robokit
//
//  Created by Ulrik Damm on 29/9/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#define RK_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define RK_IS_IPHONE (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
#define RK_IS_IPHONE_5 (RK_IS_IPHONE && UIScreen.mainScreen.bounds.size.height > 480)
#define RK_IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00)
#define RK_IS_IOS_7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")
#define RK_IS_SIMULATOR (TARGET_IPHONE_SIMULATOR)

#define RK_SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define RK_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define RK_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define RK_SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define RK_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#ifndef RGB
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#endif

#ifndef RGBA
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#endif

#ifndef MAIN_QUEUE_ONLY
#define MAIN_QUEUE_ONLY \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
NSAssert(dispatch_get_current_queue() == dispatch_get_main_queue(), @"-[%@ %@] -> Not on main queue", NSStringFromClass(self.class), NSStringFromSelector(_cmd)); \
_Pragma("clang diagnostic pop")
#endif
