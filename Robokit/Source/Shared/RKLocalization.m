//
//  RKLocalization.m
//  Ultraviolet2
//
//  Created by Ulrik Damm on 26/9/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#define NOT_AVAILABLE @"LOCALIZED_STRING_NOT_AVAILABLE"

#import "RKLocalization.h"

void RKLocalizationSetPreferredLanguage(NSString *language) {
	[[NSUserDefaults standardUserDefaults] setObject:@[ language ] forKey:@"AppleLanguages"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

NSString *RKLocalizationPreferredLanguage(void) {
	return [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] firstObject];
}

NSString *RKLocalized(NSString *str) {
	return RKLocalizedFromTable(str, nil);
}

NSString *RKLocalizedFromTable(NSString *str, NSString *table) {
	NSString *languageCode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] firstObject];
	NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:languageCode ofType:@"lproj"]];
	
	NSString *string = [bundle localizedStringForKey:str value:NOT_AVAILABLE table:table];
	
	if (!string || [string isEqualToString:NOT_AVAILABLE]) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
		return [[NSBundle bundleWithPath:path] localizedStringForKey:str value:@"---" table:table]?: @"---";
	}
	
    return string;
}

NSString *RKLocalizedWithFormat(NSString *str, ...) {
	va_list vars;
	va_start(vars, str);
	
	NSString *string = [[NSString alloc] initWithFormat:RKLocalized(str) arguments:vars];
	
	va_end(vars);
	return string;
}

NSString *RKLocalizedFromTableWithFormat(NSString *str, NSString *table, ...) {
	va_list vars;
	va_start(vars, table);
	
	NSString *string = [[NSString alloc] initWithFormat:RKLocalizedFromTable(str, table) arguments:vars];
	
	va_end(vars);
	return string;
}

void RKLocalizedLabel(UILabel *label, NSString *str) {;
    RKLocalizedLabelFromTable(label, str, nil);
}

void RKLocalizedLabelFromTable(UILabel *label, NSString *str, NSString *table) {
    NSString *string = RKLocalizedFromTable(str, table);
    
    [label setText:string];
}

void RKLocalizedLabelWithFormat(UILabel *label, NSString *str, ...) {
    va_list vars;
    va_start(vars, str);
    
    NSString *string = [[NSString alloc] initWithFormat:RKLocalized(str) arguments:vars];
    [label setText:string];
    
    va_end(vars);
}

void RKLocalizedLabelFromTableWithFormat(UILabel *label, NSString *str, NSString *table, ...) {
    va_list vars;
    va_start(vars, table);
    
    NSString *string = [[NSString alloc] initWithFormat:RKLocalizedFromTable(str, table) arguments:vars];
    [label setText:string];
    
    va_end(vars);
}

void RKLocalizedButton(UIButton *button, NSString *str) {
    RKLocalizedButtonFromTable(button, str, nil);
}

void RKLocalizedButtonFromTable(UIButton *button, NSString *str, NSString *table) {
    NSString *string = RKLocalizedFromTable(str, table);
    
    [button setTitle:string forState:UIControlStateNormal];
}

void RKLocalizedButtonWithFormat(UIButton *button, NSString *str, ...) {
    va_list vars;
    va_start(vars, str);
    
    NSString *string = [[NSString alloc] initWithFormat:RKLocalized(str) arguments:vars];
    [button setTitle:string forState:UIControlStateNormal];
    
    va_end(vars);
}

void RKLocalizedButtonFromTableWithFormat(UIButton *button, NSString *str, NSString *table, ...) {
    va_list vars;
    va_start(vars, table);
    
    NSString *string = [[NSString alloc] initWithFormat:RKLocalizedFromTableWithFormat(str, table) arguments:vars];
    [button setTitle:string forState:UIControlStateNormal];
    
    va_end(vars);
}

@implementation NSString (RKLocalization)

- (NSString *)localizedString {
	return RKLocalized(self);
}

@end
