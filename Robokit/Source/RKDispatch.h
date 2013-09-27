//
//  GCDispatch.h
//  Ultraviolet2
//
//  Created by Ulrik Damm on 20/6/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	GCDispatchStop = 0,
	GCDispatchContinue,
} GCDispatchRecursionStatus;

@interface RKDispatch : NSObject

+ (void)after:(NSTimeInterval)time callback:(void (^)(void))callback;
+ (void)async:(void (^)(void))callback;
+ (void)mainQueue:(void (^)(void))callback;
+ (void)privateQueue:(dispatch_queue_t)queue callback:(void (^)(void))callback;
+ (void)recursiveBlock:(GCDispatchRecursionStatus (^)(void))block;

@end
