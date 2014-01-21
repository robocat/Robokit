//
//  UIButton+RKLocalization.m
//  Robokit
//
//  Created by Ulrik Damm on 21/01/14.
//  Copyright (c) 2014 Robocat. All rights reserved.
//

#import "UIButton+RKLocalization.h"
#import "RKLocalization.h"

@implementation UIButton (RKLocalization)

- (void)rkLocalize {
	[self rkLocalize:[self titleForState:UIControlStateNormal]];
}

- (void)rkLocalize:(NSString *)localization {
	[self setTitle:RKLocalized(localization) forState:UIControlStateNormal];
}

@end
