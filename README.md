Robokit – The shared Robocat iOS toolkit
========================================

Usage: add this to applicationDidFinishLaunching
```objective-c
[RKSocial initializeSocialFeaturesWithAppId:@"appId" appName:@"App Name" newInThisVersion:@"· what's new"];
```

NOTE: add this line to Pods-resources.sh to add cocoapods support for xcassets
```bash
actool --output-format human-readable-text --notices --warnings --platform iphonesimulator --minimum-deployment-target 7.0 --target-device iphone --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app" `find . -name '*.xcassets'`
```

