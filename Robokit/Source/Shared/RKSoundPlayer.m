//
//  RKSoundPlayer.m
//  Robokit
//
//  Created by Ulrik Damm on 28/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKSoundPlayer.h"
#import <AudioToolbox/AudioToolbox.h>

NSString * const kRKSoundPlayerButtonClickedEvent = @"cat.robo.kRKSoundPlayerButtonClickedEvent";
NSString * const kRKSoundPlayerFollowedOnTwitterEvent = @"cat.robo.kRKSoundPlayerFollowedOnTwitterEvent";
NSString * const kRKSoundPlayerLikedOnFacebookEvent = @"cat.robo.kRKSoundPlayerLikedOnFacebookEvent";
NSString * const kRKSoundPlayerRatedEvent = @"cat.robo.kRKSoundPlayerRatedEvent";

void systemSoundCompleted(SystemSoundID ssID, void* clientData);

@interface RKSoundPlayer ()

@property (strong, nonatomic) NSMutableDictionary *callbacks;
@property (strong, nonatomic) NSMutableDictionary *events;
@property (assign, nonatomic) BOOL muted;

@end

@implementation RKSoundPlayer

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _callbacks = [NSMutableDictionary dictionary];
    _events = [NSMutableDictionary dictionary];
    
    return self;
}

+ (RKSoundPlayer *)sharedInstance {
	static RKSoundPlayer *instance;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[RKSoundPlayer alloc] init];
	});
	
	return instance;
}

+ (void)playSound:(NSString *)soundName {
	[self playSound:soundName withCompletion:nil];
}

+ (void)playSound:(NSString *)soundName withCompletion:(void (^)(void))completion {
    if ([self isMuted]) {
        return;
    }
    
	NSString *path = [[NSBundle mainBundle] pathForResource:soundName ofType:@"caf"];
	SystemSoundID soundId;
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)([NSURL fileURLWithPath:path]), &soundId);
	
	if (completion) {
		void (^completionBlock)(void) = [completion copy];
		self.sharedInstance.callbacks[[NSString stringWithFormat:@"%i", (unsigned int)soundId]] = completionBlock;
	}
	
	AudioServicesAddSystemSoundCompletion(soundId, CFRunLoopGetMain(), kCFRunLoopDefaultMode, systemSoundCompleted, NULL);
	AudioServicesPlaySystemSound(soundId);
}

+ (void)registerSound:(NSString *)soundName forEvent:(NSString *)event {
    [[self class] sharedInstance].events[event] = soundName;
}

+ (void)playSoundForEvent:(NSString *)event {
    [[self class] playSoundForEvent:event withCompletion:nil];
}

+ (void)playSoundForEvent:(NSString *)event withCompletion:(void (^)(void))completion {
    NSString *sound = [[self class] sharedInstance].events[event];
    if (sound) {
        [[self class] playSound:sound withCompletion:completion];
    }
}

+ (BOOL)isMuted {
    return [[self class] sharedInstance].muted;
}

+ (void)setMuted:(BOOL)muted {
    [[self class] sharedInstance].muted = muted;
}

@end

void systemSoundCompleted(SystemSoundID ssID, void *clientData) {
	AudioServicesDisposeSystemSoundID(ssID);
	
	void (^callback)(void) = [[RKSoundPlayer sharedInstance] callbacks][[NSString stringWithFormat:@"%i", (unsigned int)ssID]];
	if (callback) {
		callback();
	}
}
