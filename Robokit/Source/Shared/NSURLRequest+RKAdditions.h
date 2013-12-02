//
//  NSURLRequest+RKAdditions.h
//  Robokit
//
//  Created by Kristian Andersen on 07/11/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (RKAdditions)

+ (NSURLRequest *)postRequestWithURL:(NSURL *)url
                          parameters:(NSDictionary *)parameters;

@end
