//
//  RKCatnipSDK.m
//  Robokit
//
//  Created by Kristian Andersen on 28/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKCatnipSDK.h"
#import "RKCatnipStory.h"
#import "RKCatnipStoryViewController.h"
#import "NSURLRequest+RKAdditions.h"

#import <RSEnvironment/RSEnvironment.h>

#define kCNCatnipSubscriberToken @"kCNCatnipSubscriberToken"
#define kCNCatnipLastUpdatedKey @"kCNCatnipLastUpdatedKey"
#define kCNCatnipStoryStatusDictionary @"kCNCatnipStoryStatusDictionary"
//#define kCNBaseURL @"http://catnip.robocatapps.com/v1/"
#define kCNBaseURL @"http://192.168.1.82.xip.io:3000/v1/"

#define kCNSubscriberInfoPlatformkey @"platform"
#define kCNSubscriberInfoHardwareNamekey @"hardware"
#define kCNSubscriberInfoSystemVersionkey @"systemVersion"
#define kCNSubscriberInfoBundleIdKey @"bundleID"
#define kCNSubscriberInfoLocaleKey @"locale"

@interface RKCatnipSDK ()<NSURLConnectionDelegate> {
    NSString *_subscriberToken;
    NSDate *_lastUpdated;
}

@property (nonatomic, strong, readonly) NSURL *baseURL;
@property (nonatomic, strong) NSString *appToken;
@property (nonatomic, strong) NSDate *lastUpdated;

@end

@implementation RKCatnipSDK

#pragma mark - Initialization

+ (instancetype)sharedSDK {
    static RKCatnipSDK *_sharedSDK = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSDK = [[RKCatnipSDK alloc] init];
    });
    
    return _sharedSDK;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _baseURL = [NSURL URLWithString:kCNBaseURL];
    }
    
    return self;
}

#pragma mark - Public CatnipSDK

- (void)takeOff:(NSString *)appToken {
    self.appToken = appToken;
}

- (NSMutableDictionary *)subscriberInfo {
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    info[kCNSubscriberInfoPlatformkey] = @"ios";
    info[kCNSubscriberInfoHardwareNamekey] = [RSEnvironment hardware].modelName;
    info[kCNSubscriberInfoSystemVersionkey] = [[RSEnvironment system].version string];
    info[kCNSubscriberInfoBundleIdKey] = [RSEnvironment app].bundleID;
    info[kCNSubscriberInfoLocaleKey] = [[NSLocale currentLocale] localeIdentifier];
    
    
    return info;
}

- (void)checkForUpdates {
    if (!self.appToken) {
        NSLog(@"CatnipSDK: No application token found! Please configure with [CatnipSDK takeOff:@\"YOUR-APP-TOKEN-HERE\"]");
        [self runCompletion:nil];
        
        return;
    }
    
    NSMutableDictionary *info = [self subscriberInfo];
    NSString *subscriber_token = [self subscriberToken];
    if (subscriber_token) {
        info[@"subscriber_token"] = subscriber_token;
    }
    info[@"app_token"] = [self appToken];
    
    NSURL *url = [self catnipURLForString:@"stories"];
    NSURLRequest *request = [NSURLRequest postRequestWithURL:url parameters:info];
    
    NSLog(@"URL WAS: %@", [url absoluteString]);
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"CatnipSDK: Connection error when trying to check for updates. %@", [connectionError description]);
            [self runCompletion:nil];
            
            return;
        }
        
        if (data) {
            [self parseCheckForUpdateData:data];
        }
    }];
}

- (void)parseCheckForUpdateData:(NSData *)data {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            NSLog(@"CatnipSDK: JSON de-serialization error when parsing stories for checking for updates. %@", [error localizedDescription]);
            [self runCompletion:nil];
            return;
        }
        
        if (!jsonObj || ![jsonObj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"CatnipSDK: Got invalid JSON response from server when checking for updates.");
            [self runCompletion:nil];
            return;
        }
        
        NSDictionary *response = (NSDictionary *)jsonObj;
        if (response[@"subscriber"]) {
            [self setSubscriberToken:response[@"subscriber"]];
        }
        
        id storiesObj = response[@"stories"];
        if (!storiesObj || ![storiesObj isKindOfClass:[NSArray class]]) {
            NSLog(@"CatnipSDK: Got invalid JSON response from server when checking for updates.");
            [self runCompletion:nil];
            return;
        }
        
        
        NSArray *stories = (NSArray *)storiesObj;
        NSMutableArray *newStories = [NSMutableArray arrayWithCapacity:stories.count];
        for (NSDictionary *storyDict in stories) {
            RKCatnipStory *story = [[self localStories] objectForKey:[storyDict[@"id"] stringValue]];
            if (!story) {
                story = [RKCatnipStory storyWithDictionary:storyDict];
                [[self localStories] setObject:story forKey:story.identifier];
            }
            
            if (story.status != CNCatnipStoryStatusRead && [story.published timeIntervalSince1970] > [self.lastUpdated timeIntervalSince1970]) {
                [newStories addObject:story];
            }
        }
        [self updateLocalStories];
        
        if (newStories.count > 0) {
            RKCatnipStory *story = [newStories lastObject];
            [self setLastUpdated:[NSDate date]];
            __strong RKCatnipStoryViewController *viewController = [self viewControllerWithStory:story];
            [self runCompletion:viewController];
            return;
        }
        
        
        [self runCompletion:nil];
        
    });
}

- (RKCatnipStoryViewController *)viewControllerWithStory:(RKCatnipStory *)story {
    if (!story) {
        return nil;
    }
    
    RKCatnipStoryViewController *viewController = [RKCatnipStoryViewController catnipStoryViewControllerWithStory:story];
    story.status = CNCatnipStoryStatusRead;
    [[self localStories] setObject:story forKey:story.identifier];
    [self updateLocalStories];
    
    return viewController;
}

- (void)runCompletion:(RKCatnipStoryViewController *)viewController {
    if (!viewController) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentModalInWindow:[[UIApplication sharedApplication] keyWindow] withColseHandler:nil];
    });
}

#pragma mark - CatnipSDK ()

- (NSURL *)catnipURLForString:(NSString *)string {
    NSString *sToken = [self subscriberToken];
    if (!sToken) {
        sToken = @"";
    }
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@?app_token=%@&subscriber_token=%@", string, self.appToken, sToken] relativeToURL:self.baseURL];
}



- (NSMutableDictionary *)localStories {
    static NSMutableDictionary *_localStories;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *statusData = [defaults dataForKey:kCNCatnipStoryStatusDictionary];
        if (statusData) {
            NSDictionary *statusDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:statusData];
            _localStories = [NSMutableDictionary dictionaryWithDictionary:statusDictionary];
        } else {
            _localStories = [NSMutableDictionary dictionary];
        }
        
    });
    
    return _localStories;
}

- (void)updateLocalStories {
    NSData *statusData = [NSKeyedArchiver archivedDataWithRootObject:[NSDictionary dictionaryWithDictionary:[self localStories]]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:statusData forKey:kCNCatnipStoryStatusDictionary];
    [defaults synchronize];
}

- (NSString *)subscriberToken {
    if (_subscriberToken) {
        return _subscriberToken;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:kCNCatnipSubscriberToken];
}

- (void)setSubscriberToken:(NSString *)subscriberToken {
    _subscriberToken = subscriberToken;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_subscriberToken forKey:kCNCatnipSubscriberToken];
    [defaults synchronize];
}

- (NSDate *)lastUpdated {
    if (_lastUpdated) {
        return _lastUpdated;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _lastUpdated = [defaults objectForKey:kCNCatnipLastUpdatedKey];
    
    if (!_lastUpdated) {
        _lastUpdated = [NSDate dateWithTimeIntervalSince1970:0];
    }
    
    return _lastUpdated;
}

- (void)setLastUpdated:(NSDate *)lastUpdated {
    _lastUpdated = lastUpdated;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_lastUpdated forKey:kCNCatnipLastUpdatedKey];
}

@end
