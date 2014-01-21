//
//  UILabel+RKLocalization.m
//  Robokit
//
//  Created by Ulrik Damm on 21/01/14.
//  Copyright (c) 2014 Robocat. All rights reserved.
//

#import "UILabel+RKLocalization.h"
#import "RKLocalization.h"

@implementation UILabel (RKLocalization)

- (void)rkLocalize {
	[self rkLocalize:self.text];
}

- (void)rkLocalize:(NSString *)localization {
	self.text = RKLocalized(localization);
}

@end
