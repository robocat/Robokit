//
//  RKPurchaseManager.h
//  Robokit
//
//  Created by Ulrik Damm on 29/9/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kRKPurchasesManagerDidLoadProductInfoNotification;
extern NSString * const kRKPurchasesManagerDidPurchaseFeatureNotification; // userInfo: FeatureIdKey => purchased feature ID as NSString
extern NSString * const kRKPurchasesManagerPurchaseDidFailNotification; // userInfo: FeatureIdKey => failed purchase feature ID as NSString
extern NSString * const kRKPurchasesManagerPurchaseWasCancelledNotification; // userInfo: FeatureIdKey => cancelled purchase feature ID as NSString
extern NSString * const kRKPurchasesManagerPurchaseNotAvailableNotification; // userInfo: FeatureIdKey => failed purchase feature ID as NSString
extern NSString * const kRKPurchasesManagerPurchaseRestoreDidFinish;
extern NSString * const kRKPurchasesManagerPurchaseRestoreDidFail; // userInfo: kRKPurchasesManagerErrorKey => error as NSError

extern NSString * const kRKPurchasesManagerFeatureIdKey;
extern NSString * const kRKPurchasesManagerTransactionIdKey;
extern NSString * const kRKPurchasesManagerPurchaseDateKey;
extern NSString * const kRKPurchasesManagerErrorKey;

@interface RKPurchaseManager : NSObject

/*!
 * Load product information. Call in applicationDidFinishLaunching.
 * @param featureIds An array with all available IAPs.
 */
+ (void)loadFeaturesWithIds:(NSArray *)featureIds;

/*!
 * Call to find out if product info has been loaded yet.
 * @return YES if product info has been loaded.
 */
+ (BOOL)isProductsLoaded;

/*!
 * Purchase the specified feature. Listen for notifications with the specified featureId as the kRKPurchasesManagerFeatureIdKey key in the user info dictionary.
 * @param featureId The ID of the IAP to purchase.
 */
+ (void)purchaseFeature:(NSString *)featureId;

/*!
 * Returns wether or not a feature has been purchased.
 * @param featureId The IAP id.
 * @return YES if the feature has been purchased.
 */
+ (BOOL)isFeaturePurchased:(NSString *)featureId;

/*!
 * Returns the price of the specified feature in the local currency.
 * @param featureId The IAP id;
 * @return A price string in local currency with currency identifier (e.g. "$0.99", "7 kr", etc.)
 */
+ (NSString *)priceOfFeature:(NSString *)featureId;

/*!
 * Restore all previously purchased features. Will call the purchased feature notification for all restored features, and call the did restore notification when done, or the restore failed notification on failure.
 */
+ (void)restoreAllPurchases;

/*!
 * Returns wether or not purchases are being simulated / faked.
 * Simulated purchases can be enabled through the setSimulatedPurchases:
 * method.
 * @return YES if purchases are being simulated
 */
+ (BOOL)isSimulatedPurchases;

/*!
 * Specify wether or not purchases should be simulated. The Default is NO.
 * This can be helpfull when running on iOS simulator or TestFlight builds.
 * @param simulated Indicates wether purchases should be simulated or not
 */
+ (void)setSimulatedPurchases:(BOOL)simulated;

@end
