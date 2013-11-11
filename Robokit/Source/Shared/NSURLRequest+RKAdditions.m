//
//  NSURLRequest+RKAdditions.m
//  Robokit
//
//  Created by Kristian Andersen on 07/11/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "NSURLRequest+RKAdditions.h"
#import "NSString+RKAdditions.h"

@implementation NSURLRequest (RKAdditions)

+ (NSURLRequest *)postRequestWithURL:(NSURL *)url
                          parameters:(NSDictionary *)parameters {
    NSMutableString *body = [NSMutableString string];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded"
   forHTTPHeaderField:@"Content-Type"];
    
    for (NSString *key in parameters) {
        NSString *val = [parameters objectForKey:key];
        if ([body length])
            [body appendString:@"&"];
        [body appendFormat:@"%@=%@", [[key description] urlEncodedUTF8String],
         [[val description] urlEncodedUTF8String]];
    }
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

@end
