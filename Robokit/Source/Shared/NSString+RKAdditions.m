//
//  NSString+RKAdditions.m
//  Robokit
//
//  Created by Kristian Andersen on 07/11/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "NSString+RKAdditions.h"

@implementation NSString (RKAdditions)

- (NSString *)urlEncodedUTF8String {
    return (id)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(0, (CFStringRef)self, 0,
                                                       (CFStringRef)@";/?:@&=$+{}<>,", kCFStringEncodingUTF8));
}

@end
