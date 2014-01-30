//
//  GCDispatch.h
//  Ultraviolet2
//
//  Created by Ulrik Damm on 20/6/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define weakify \
	autoreleasepool {} \
	#pragma clang diagnostic push \
	#pragma clang diagnostic ignored "-Wunused-variable" \
	__weak typeof(self) weakSelf = self \
	#pragma clang diagnostic pop

#define strongify autoreleasepool {} if (!weakSelf) return; typeof(self) self = weakSelf
#define strongify_return(default_return) autoreleasepool {} if (!weakSelf) return default_return; typeof(self) self = weakSelf

typedef enum {
	GCDispatchStop = 0,
	GCDispatchContinue,
} GCDispatchRecursionStatus;

@interface RKDispatch : NSObject

+ (void)after:(NSTimeInterval)time callback:(void (^)(void))callback;
+ (void)async:(void (^)(void))callback;
+ (void)async:(void (^)(void))callback after:(NSTimeInterval)time;
+ (void)mainQueue:(void (^)(void))callback;
+ (void)privateQueue:(dispatch_queue_t)queue callback:(void (^)(void))callback;
+ (void)recursiveBlock:(GCDispatchRecursionStatus (^)(void))block;

@end
