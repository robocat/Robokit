//
//  RKLocalization.h
//  Ultraviolet2
//
//  Created by Ulrik Damm on 26/9/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *RKLocalized(NSString *str);
NSString *RKLocalizedFromTable(NSString *str, NSString *table);

NSString *RKLocalizedWithFormat(NSString *str, ...);
NSString *RKLocalizedFromTableWithFormat(NSString *str, NSString *table, ...);

void RKLocalizedLabel(UILabel *label, NSString *str);
void RKLocalizedLabelFromTable(UILabel *label, NSString *str, NSString *table);
void RKLocalizedLabelWithFormat(UILabel *label, NSString *str, ...);
void RKLocalizedLabelFromTableWithFormat(UILabel *label, NSString *str, NSString *table, ...);

void RKLocalizedButton(UIButton *button, NSString *str);
void RKLocalizedButtonFromTable(UIButton *button, NSString *str, NSString *table);
void RKLocalizedButtonWithFormat(UIButton *button, NSString *str, ...);
void RKLocalizedButtonFromTableWithFormat(UIButton *button, NSString *str, NSString *table, ...);

@interface NSString (RKLocalization)

- (NSString *)localizedString;

@end
