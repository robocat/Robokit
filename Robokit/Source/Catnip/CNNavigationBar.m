//
//  CNNavigationBar.m
//  CatnipSDK
//
//  Created by Kristian Andersen on 9/23/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "CNNavigationBar.h"

@implementation CNNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.shadowImage = [[UIImage imageNamed:@"navigation_shadow"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {}

@end
