//
//  RKCatnipSDK.h
//  Robokit
//
//  Created by Kristian Andersen on 28/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKCatnipSDK : NSObject

+ (RKCatnipSDK *)sharedSDK;

- (void)takeOff:(NSString *)applicationToken;
- (void)checkForUpdates;
- (NSURL *)catnipURLForString:(NSString *)urlString;

@end
