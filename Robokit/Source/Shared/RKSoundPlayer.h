//
//  RKSoundPlayer.h
//  Robokit
//
//  Created by Ulrik Damm on 28/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKSoundPlayer : NSObject

+ (void)playSound:(NSString *)soundName;
+ (void)playSound:(NSString *)soundName withCompletion:(void (^)(void))completion;

@end
