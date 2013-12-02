//
//  GCDispatch.m
//  Ultraviolet2
//
//  Created by Ulrik Damm on 20/6/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKDispatch.h"

@implementation RKDispatch

+ (void)after:(NSTimeInterval)time callback:(void (^)(void))callback {
	double delayInSeconds = time;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), callback);
}

+ (void)async:(void (^)(void))callback {
	dispatch_async(dispatch_get_global_queue(0, 0), callback);
}

+ (void)async:(void (^)(void))callback after:(NSTimeInterval)time {
    [self after:time callback:^{
        [self async:callback];
    }];
}

+ (void)mainQueue:(void (^)(void))callback {
	dispatch_async(dispatch_get_main_queue(), callback);
}

+ (void)privateQueue:(dispatch_queue_t)queue callback:(void (^)(void))callback {
	dispatch_async(queue, callback);
}

+ (void)recursiveBlock:(GCDispatchRecursionStatus (^)(void))block {
	while (block() == GCDispatchContinue);
}

@end
