//
//  UIDevice+RKAdditions.m
//  Robokit
//
//  Created by Kristian Andersen on 03/11/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "UIDevice+RKAdditions.h"

@implementation UIDevice (RKAdditions)

- (BOOL)rk_isSimulartor {
    static NSString *simulatorModel = @"iPhone Simulator";
    return [[self model] isEqualToString:simulatorModel];
}

@end
