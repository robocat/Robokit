//
//  RKPurchaseManager.m
//  Robokit
//
//  Created by Ulrik Damm on 29/9/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKPurchaseManager.h"
#import "UIDevice+RKAdditions.h"
#import "Flurry.h"
#import "RKMacros.h"
#import <StoreKit/StoreKit.h>

NSString * const kRKPurchasesManagerDidLoadProductInfoNotification = @"cat.robo.kRKPurchasesManagerDidLoadProductInfoNotification";
NSString * const kRKPurchasesManagerDidPurchaseFeatureNotification = @"cat.robo.kRKPurchasesManagerDidPurchaseFeatureNotification";
NSString * const kRKPurchasesManagerPurchaseDidFailNotification = @"cat.robokRKPurchasesManagerPurchaseDidFailNotification";
NSString * const kRKPurchasesManagerPurchaseWasCancelledNotification = @"cat.robo.kRKPurchasesManagerPurchaseWasCancelledNotification";
NSString * const kRKPurchasesManagerPurchaseNotAvailableNotification = @"cat.robo.kRKPurchasesManagerPurchaseNotAvailableNotification";
NSString * const kRKPurchasesManagerPurchaseRestoreDidFinish = @"cat.robo.kRKPurchasesManagerPurchaseRestoreDidFinish";
NSString * const kRKPurchasesManagerPurchaseRestoreDidFail = @"cat.robo.kRKPurchasesManagerPurchaseRestoreDidFail";

NSString * const kRKPurchasesManagerFeatureIdKey = @"kRKPurchasesManagerFeatureIdKey";
NSString * const kRKPurchasesManagerTransactionIdKey = @"kRKPurchasesManagerTransactionIdKey";
NSString * const kRKPurchasesManagerPurchaseDateKey = @"kRKPurchasesManagerPurchaseDateKey";
NSString * const kRKPurchasesManagerErrorKey = @"kRKPurchasesManagerErrorKey";

@interface RKPurchaseManager () <SKRequestDelegate, SKPaymentTransactionObserver>

@property (strong, nonatomic) NSDictionary *products;
@property (assign, nonatomic) BOOL simulated;

@end

@implementation RKPurchaseManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _simulated = NO;
    if ([[UIDevice currentDevice] rk_isSimulartor]) {
        _simulated = YES;
    }
    
    return self;
}

+ (RKPurchaseManager *)sharedInstance {
	static RKPurchaseManager *instance;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[RKPurchaseManager alloc] init];
	});
	
	return instance;
}

+ (void)loadFeaturesWithIds:(NSArray *)featureIds {
	[[SKPaymentQueue defaultQueue] addTransactionObserver:[self sharedInstance]];
	
	NSSet *products = [NSSet setWithArray:featureIds];
	SKRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:products];
	request.delegate = [self sharedInstance];
	[request start];
}

+ (BOOL)isProductsLoaded {
	return ([[self sharedInstance] products] != nil);
}

+ (BOOL)isFeaturePurchased:(NSString *)featureId {
	return [[NSUserDefaults standardUserDefaults] boolForKey:featureId];
}

+ (NSString *)priceOfFeature:(NSString *)featureId {
    if ([self isSimulatedPurchases]) {
        return @"Simulated";
    }
    
	if (![self isProductsLoaded]) {
		return @"$??";
	}
	
	SKProduct *product = [[self sharedInstance] products][featureId];
	
	if (!product.price) {
		return @"$??";
	}
	
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	[numberFormatter setLocale:product.priceLocale];
	NSString *formattedString = [numberFormatter stringFromNumber:product.price];
	
	return formattedString;
}

+ (void)purchaseFeature:(NSString *)featureId {
    if ([self isSimulatedPurchases]) {
        [self productWasPurchased:featureId transactionId:@"tid" purchaseDate:[NSDate date]];
        return;
    }
    
	[Flurry logEvent:@"Did attempt to purchase something" withParameters:@{ @"Feature ID": featureId }];
	
	if (![SKPaymentQueue canMakePayments]) {
		NSDictionary *userInfo = @{ kRKPurchasesManagerFeatureIdKey: featureId };
		[[NSNotificationCenter defaultCenter] postNotificationName:kRKPurchasesManagerPurchaseNotAvailableNotification object:nil userInfo:userInfo];
	}
	
	if ([[[self sharedInstance] products] count] == 0) {
		NSDictionary *userInfo = @{ kRKPurchasesManagerFeatureIdKey: featureId };
		[[NSNotificationCenter defaultCenter] postNotificationName:kRKPurchasesManagerPurchaseDidFailNotification object:nil userInfo:userInfo];
		return;
	}
	
	SKProduct *product = [[self sharedInstance] products][featureId];
	[[SKPaymentQueue defaultQueue] addPayment:[SKPayment paymentWithProduct:product]];
}

+ (void)restoreAllPurchases {
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

+ (BOOL)isSimulatedPurchases {
	if (RK_IS_SIMULATOR) return YES;
	
    return [[self class] sharedInstance].simulated;
}

+ (void)setSimulatedPurchases:(BOOL)simulated {
    [[self class] sharedInstance].simulated = YES;
}

#pragma mark - Store Kit Callbacks

+ (void)productWasPurchased:(NSString *)featureId transactionId:(NSString *)transactionId purchaseDate:(NSDate *)purchaseDate {
	[Flurry logEvent:@"Did actually purchase something" withParameters:@{ @"Feature ID": featureId }];
	
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:featureId];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	NSDictionary *userInfo = @{ kRKPurchasesManagerFeatureIdKey: featureId,
								kRKPurchasesManagerTransactionIdKey: transactionId,
								kRKPurchasesManagerPurchaseDateKey: purchaseDate };
	[[NSNotificationCenter defaultCenter] postNotificationName:kRKPurchasesManagerDidPurchaseFeatureNotification object:nil userInfo:userInfo];
}

+ (void)productWasRestored:(NSString *)featureId transactionId:(NSString *)transactionId purchaseDate:(NSDate *)purchaseDate {
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:featureId];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	NSDictionary *userInfo = @{ kRKPurchasesManagerFeatureIdKey: featureId,
								kRKPurchasesManagerTransactionIdKey: transactionId,
								kRKPurchasesManagerPurchaseDateKey: purchaseDate };
	[[NSNotificationCenter defaultCenter] postNotificationName:kRKPurchasesManagerDidPurchaseFeatureNotification object:nil userInfo:userInfo];
}

+ (void)productPurchaseFailed:(NSString *)featureId {
	NSDictionary *userInfo = @{ kRKPurchasesManagerFeatureIdKey: featureId };
	[[NSNotificationCenter defaultCenter] postNotificationName:kRKPurchasesManagerPurchaseDidFailNotification object:nil userInfo:userInfo];
}

+ (void)productPurchaseCancelled:(NSString *)featureId {
	NSDictionary *userInfo = @{ kRKPurchasesManagerFeatureIdKey: featureId };
	[[NSNotificationCenter defaultCenter] postNotificationName:kRKPurchasesManagerPurchaseWasCancelledNotification object:nil userInfo:userInfo];
}

#pragma mark - Store Kit Payment Transaction observer

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for (SKPaymentTransaction *transaction in transactions) {
		NSString *featureId = transaction.payment.productIdentifier;
		
		if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
			if (![self.class isFeaturePurchased:featureId]) {
				[self.class productWasPurchased:featureId transactionId:transaction.transactionIdentifier purchaseDate:transaction.transactionDate];
			}
			
			[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
		} else if (transaction.transactionState == SKPaymentTransactionStateRestored) {
			if (![self.class isFeaturePurchased:featureId]) {
				[self.class productWasRestored:featureId transactionId:transaction.transactionIdentifier purchaseDate:transaction.transactionDate];
			}
			
			[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
		} else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
			if (transaction.error) {
				[self.class productPurchaseFailed:featureId];
			} else {
				[self.class productPurchaseCancelled:featureId];
			}
			
			[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
		}
	}
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
	[[NSNotificationCenter defaultCenter] postNotificationName:kRKPurchasesManagerPurchaseRestoreDidFinish object:nil];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
	NSDictionary *userInfo = @{ kRKPurchasesManagerErrorKey: error };
	[[NSNotificationCenter defaultCenter] postNotificationName:kRKPurchasesManagerPurchaseRestoreDidFail object:nil userInfo:userInfo];
}

#pragma mark - Store Kit Request delegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
	if ([response.invalidProductIdentifiers count] > 0) {
		NSLog(@"invalid product identifiers: %@", response.invalidProductIdentifiers);
	}
	
	NSMutableDictionary *productDict = [NSMutableDictionary dictionary];
	
	for (SKProduct *product in response.products) {
		productDict[product.productIdentifier] = product;
	}
	
	self.products = productDict;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kRKPurchasesManagerDidLoadProductInfoNotification object:nil];
}

@end
