//
//  RKCatnipStory.m
//  Robokit
//
//  Created by Kristian Andersen on 28/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKCatnipStory.h"

@implementation RKCatnipStory

+ (NSDateFormatter *)publishedDateFormatter {
    static NSDateFormatter *_publishedDateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _publishedDateFormatter = [[NSDateFormatter alloc] init];
        [_publishedDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        [_publishedDateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    });
    
    return _publishedDateFormatter;
}

+ (instancetype)storyWithIdentifier:(NSString *)identifier published:(NSDate *)published status:(CNCatnipStoryStatus)status {
    RKCatnipStory *story = [[RKCatnipStory alloc] init];
    story.identifier = identifier;
    story.published = published;
    story.status = status;
    
    return story;
}

+ (instancetype)storyWithDictionary:(NSDictionary *)dictionary {
    NSDateFormatter *dateFormatter = [self publishedDateFormatter];
    NSDate *published = [dateFormatter dateFromString:dictionary[@"created_at"]];
    return [[self class] storyWithIdentifier:[dictionary[@"id"] stringValue] published:published status:CNCatnipStoryStatusReceived];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.identifier forKey:@"identifier"];
    [encoder encodeObject:self.published forKey:@"published"];
    [encoder encodeObject:[NSNumber numberWithDouble:self.status] forKey:@"status"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self.identifier = [coder decodeObjectForKey:@"identifier"];
    self.published = [coder decodeObjectForKey:@"published"];
    self.status = [(NSNumber *)[coder decodeObjectForKey:@"status"] doubleValue];
    
    return self;
}

@end
