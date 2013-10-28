//
//  RKCatnipStory.h
//  Robokit
//
//  Created by Kristian Andersen on 28/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>

enum CNCatnipStoryStatus {
    CNCatnipStoryStatusUnread = 0,
    CNCatnipStoryStatusReceived,
    CNCatnipStoryStatusRead
};

typedef NSUInteger CNCatnipStoryStatus;

@interface RKCatnipStory : NSObject

@property (nonatomic, strong) NSDate *published;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) CNCatnipStoryStatus status;

+ (instancetype)storyWithIdentifier:(NSString *)identifier published:(NSDate *)published status:(CNCatnipStoryStatus)status;
+ (instancetype)storyWithDictionary:(NSDictionary *)dictionary;

@end
