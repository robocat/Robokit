Robokit – The shared Robocat iOS toolkit
========================================

The toolkit is split into smaller subsoecs so you only have to specify the parts needed:

```
Robokit/Social	# All utility classes including follow us and rating popups
Robokit/About	# About Us and Newsletter signup
Robokit/Ads	# Ad banner and IAP
```

You can add either one or more of the subspecs or all of them by using just ``'Robokit'``. Edit your ``Podfile`` and add the following line:

```
pod 'Robokit', :git => 'git@github.com:robocat/Robokit.git', :branch => 'master'
```

If you add the ``Robokit/Ads`` spec you will need to manually link the ``iAd``, ``StoreKit`` and ``AdSupport`` frameworks with your target.

Usage: add this to applicationDidFinishLaunching
```objective-c
[RKSocial initializeSocialFeaturesWithAppId:@"appId" appName:@"App Name" newInThisVersion:@"· what's new"];
```

**NOTE:** 
The official Cocoapods doesn't yet support xcassets in pods. Install this version for support: [https://github.com/ulrikdamm/CocoaPods](https://github.com/ulrikdamm/CocoaPods)

Features
========

* RKSocial: automatic popups, rate this app, follow on twitter, like on facebook, subscribe to newsletter
* About Robocat: Standard About Robocat modal view
* RKAdView: Easily integrate RevMob ads
* RKPurchaseManager: Super easy IAPs
* RKLocalization: Wrapper to the localization API
* RKDispatch: Objective-C wrapper to grand central dispatch
* RKMacros: Handy macros
