//
//  GCDispatch.h
//  Ultraviolet2
//
//  Created by Ulrik Damm on 20/6/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RK_WEAKIFY() __weak typeof(self) weakSelf = self
#define RK_STRONGIFY() if (!weakSelf) return; typeof(self) self = weakSelf
#define RK_STRONGIFY_RETURN(default_return) if (!weakSelf) return default_return; typeof(self) self = weakSelf
#define RK_STRONGIFY_UNUSED() if (!weakSelf) return

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
