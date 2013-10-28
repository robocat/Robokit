//
//  CNBlurView.m
//  CatnipSDK
//
//  Created by Kristian Andersen on 9/23/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "CNBlurView.h"

@interface CNBlurView ()

@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation CNBlurView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // If we don't clip to bounds the toolbar draws a thin shadow on top
    [self setClipsToBounds:YES];
    
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
    if (![self toolbar]) {
        [self setToolbar:[[UIToolbar alloc] initWithFrame:[self bounds]]];
        self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.toolbar.barTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
//        [self.layer insertSublayer:[self.toolbar layer] atIndex:0];
        [self insertSubview:self.toolbar atIndex:0];
    }
}

- (void) setBlurTintColor:(UIColor *)blurTintColor {
    [self.toolbar setBarTintColor:blurTintColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.toolbar setFrame:[self bounds]];
}

@end
