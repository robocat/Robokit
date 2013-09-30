Robokit – The shared Robocat iOS toolkit
========================================

Edit your ``Podfile`` and add the following line:

```
pod 'Robokit', :git => 'git@github.com:robocat/Robokit.git', :branch => 'master'
```

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
