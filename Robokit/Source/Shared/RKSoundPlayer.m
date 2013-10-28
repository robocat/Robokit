//
//  RKSoundPlayer.m
//  Robokit
//
//  Created by Ulrik Damm on 28/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKSoundPlayer.h"
#import <AudioToolbox/AudioToolbox.h>

void systemSoundCompleted(SystemSoundID ssID, void* clientData);

@interface RKSoundPlayer ()

@property (strong, nonatomic) NSMutableDictionary *callbacks;

@end

@implementation RKSoundPlayer

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

@end

void systemSoundCompleted(SystemSoundID ssID, void *clientData) {
	AudioServicesDisposeSystemSoundID(ssID);
	
	void (^callback)(void) = [[RKSoundPlayer sharedInstance] callbacks][[NSString stringWithFormat:@"%i", (unsigned int)ssID]];
	if (callback) {
		callback();
	}
}
