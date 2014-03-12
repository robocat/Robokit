//
//  RKSoundPlayer.h
//  Robokit
//
//  Created by Ulrik Damm on 28/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kRKSoundPlayerButtonClickedEvent;
extern NSString * const kRKSoundPlayerFollowedOnTwitterEvent;
extern NSString * const kRKSoundPlayerLikedOnFacebookEvent;
extern NSString * const kRKSoundPlayerRatedEvent;

@interface RKSoundPlayer : NSObject

+ (void)playSound:(NSString *)soundName;
+ (void)playSound:(NSString *)soundName obeyMuted:(BOOL)obey;
+ (void)playSound:(NSString *)soundName withCompletion:(void (^)(void))completion;
+ (void)playSound:(NSString *)soundName obeyMuted:(BOOL)obey withCompletion:(void (^)(void))completion;

+ (void)registerSound:(NSString *)soundName forEvent:(NSString *)event;

+ (void)playSoundForEvent:(NSString *)event;
+ (void)playSoundForEvent:(NSString *)event withCompletion:(void (^)(void))completion;

+ (BOOL)isMuted;
+ (void)setMuted:(BOOL)muted;

@end
