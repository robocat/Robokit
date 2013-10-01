//
//  RKLocalization.m
//  Ultraviolet2
//
//  Created by Ulrik Damm on 26/9/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#define NOT_AVAILABLE @"LOCALIZED_STRING_NOT_AVAILABLE"

#import "RKLocalization.h"

NSString *RKLocalized(NSString *str) {
	return RKLocalizedFromTable(str, nil);
}

NSString *RKLocalizedFromTable(NSString *str, NSString *table) {
	NSString *string = [[NSBundle mainBundle] localizedStringForKey:str value:NOT_AVAILABLE table:table];
	
	if ([string isEqualToString:NOT_AVAILABLE]) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
		return [[NSBundle bundleWithPath:path] localizedStringForKey:str value:@"NA" table:table];
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

void RKLocalizedButton(UIButton *button, NSString *str) {
    RKLocalizedButtonfromTable(button, str, nil);
}

void RKLocalizedButtonfromTable(UIButton *button, NSString *str, NSString *table) {
    NSString *string = RKLocalizedFromTable(str, table);
    
    [button setTitle:string forState:UIControlStateNormal];
}