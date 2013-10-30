# Robokit – The Robocat iOS Toolkit

This is the shared Robocat toolkit for iOS. The toolkit is managed using CocoaPods and is split up into several
small subspecs.

* ``Robokit/Shared``: Shared macros, function, classes and common functionality for rating, following, etc.
* ``Robokit/IAP``: Includes ``RKPurchaseManager`` to make In-App purchases easier
* ``Robokit/Ads``: Easy to use Ad banners served by iAd and Revmob
* ``Robokit/About``: ViewControllers for About Robocat and subscribing to our newsletter

## Robokit/Shared

The shared subscpec contains multiple utility macros, functions and classes along with views for app upgrades,
rating the app, sending feedback and following us. This subspec is included with any of the subspecs of Robokit.
If you only need this part, just add the following line to the ``Podfile``

```ruby
pod 'Robokit/Shared', :git => 'git@github.com:robocat/Robokit.git'
```

In your ``UIApplicationDelegate`` add the following line in your ``application:didFinishLaunchingWithOptions:``:

```objectivec
[TestFlight takeOff:@"app-testflight-token"];

NSString *thisVersionNews = (@"· Awesome new feature\n" @"· Another awesome feature");
[RKSocial initializeSocialFeaturesWithAppId:@"iTunes-App-id-here"
                                    appName:@"AppName" 
                           newInThisVersion:thisVersionNews];
```

To add support for Flurry analytics add this line to your ``UIApplicationDelegate``:

```objectivec
[RKSocial initializeFlurryWithAppId:@"flurry-app-id"];
```

To make things easier add the following line in your ``MyApp-Prefix.pch`` file:

```c
#import <Robokit/Robokit.h>
```

### Utilites

* RKSocial: automatic popups, rate this app, follow on twitter, like on facebook, subscribe to newsletter
* RKLocalization: Wrapper to the localization API. Convenience functions for localizing UILabels and UIButtons
* RKDispatch: Objective-C wrapper to grand central dispatch
* RKMacros: Handy macros

### What's new

The What's new popup will displayed everytime a user updates their app. Please make sure you change
the ``newInThisVersion`` parameter of the initialization mentioned above.

![whatsnew](https://f.cloud.github.com/assets/178181/1406632/ea2ad380-3d56-11e3-8674-d4ea536931f0.png)

### Rate App

The popup for rating the app will automatically be displayed sometime after a user has installed the app
or updated the app from a previous version.

![rate](https://f.cloud.github.com/assets/178181/1406631/ea29ddc2-3d56-11e3-8e5e-23559a73c9a1.png)

If the user rates the app 3 stars or less the feedback popup will appear. The feedback submitted will
be sent to both Flurry and TestFlight.

![feedback](https://f.cloud.github.com/assets/178181/1406630/ea096506-3d56-11e3-8fae-cc83d1872bce.png)

### Follow us

The follow us popup will displayed 2 days after app install or update.

![followus](https://f.cloud.github.com/assets/178181/1406633/ea2b939c-3d56-11e3-9932-7046426700f7.png)

## Robokit/IAP

Include ``RKPurchaseManager`` which makes it a lot easier to deal with In-App purchaes.

In your ``UIApplicationDelegate``'s ``application:didFinishLaunchingWithOptions:`` add the following line:

```objectivec
[RKPurchaseManager loadFeaturesWithIds:@[ AD_REMOVE_FEATURE_ID, OTHER_AWESOME_FEATURE_ID ]];
```

Then you can just add the following line to purchase a feature:

```objectivec
if (![RKPurchaseManager isFeaturePurchased:AD_REMOVE_FEATURE_ID]) {
    [RKPurchaseManager purchaseFeature:AD_REMOVE_FEATURE_ID];
}
```

Or the following line to restore purchases:

```objectivec
[RKPurchaseManager restoreAllPurchases];
```

There are several notifications you can listen for to handle purchases, restores and errors:

```objectivec
extern NSString * const kRKPurchasesManagerDidLoadProductInfoNotification;
extern NSString * const kRKPurchasesManagerDidPurchaseFeatureNotification; // userInfo: FeatureIdKey => purchased feature ID as NSString
extern NSString * const kRKPurchasesManagerPurchaseDidFailNotification; // userInfo: FeatureIdKey => failed purchase feature ID as NSString
extern NSString * const kRKPurchasesManagerPurchaseWasCancelledNotification; // userInfo: FeatureIdKey => cancelled purchase feature ID as NSString
extern NSString * const kRKPurchasesManagerPurchaseNotAvailableNotification; // userInfo: FeatureIdKey => failed purchase feature ID as NSString
extern NSString * const kRKPurchasesManagerPurchaseRestoreDidFinish;
extern NSString * const kRKPurchasesManagerPurchaseRestoreDidFail; // userInfo: kRKPurchasesManagerErrorKey => error as NSError

extern NSString * const kRKPurchasesManagerFeatureIdKey;
extern NSString * const kRKPurchasesManagerErrorKey;
```



## Robokit/Ads

TODO: Ulrik, add some text here!

## Robokit/About

Robokit has a subspecificiation for the default About Robocat UIViewController that is used across most of our apps.
Add the following line to the ``Podfile`` to include the code and assets.

```ruby
pod 'Robokit/About', :git => 'git@github.com:robocat/Robokit.git'
```

![about](https://f.cloud.github.com/assets/178181/1406644/3c741908-3d57-11e3-896c-89db9abcddce.png)&nbsp;
![newsletter](https://f.cloud.github.com/assets/178181/1406645/3c945948-3d57-11e3-8067-687a0ec9918f.png)

