//
//  RKCatnipStoryViewController.m
//  Robokit
//
//  Created by Kristian Andersen on 28/10/13.
//  Copyright (c) 2013 Robocat. All rights reserved.
//

#import "RKCatnipStoryViewController.h"
#import "CNBlurView.h"
#import "CNNavigationBar.h"

@interface RKCatnipStoryViewController () <UIWebViewDelegate>

@property (nonatomic, strong) RKCatnipStory *story;
@property (nonatomic, strong) NSURL *storyURL;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) CNNavigationBar *navigationBar;

@end

@implementation RKCatnipStoryViewController

+ (RKCatnipStoryViewController *)catnipStoryViewControllerWithStory:(RKCatnipStory *)story {
    RKCatnipStoryViewController *viewController = [[RKCatnipStoryViewController alloc] initWithStory:story];
    return viewController;
}

- (instancetype)initWithStory:(RKCatnipStory *)story {
    self = [super init];
    if (self) {
        self.story = story;
        self.storyURL = [[RKCatnipSDK sharedSDK] catnipURLForString:[NSString stringWithFormat:@"story/%@", story.identifier]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.view.opaque = NO;
    
    CNBlurView *blurView = [CNBlurView new];
    [blurView setFrame:[self.view bounds]];
    [blurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:blurView];
    
    self.navigationBar = [[CNNavigationBar alloc] initWithFrame:CGRectMake(0, 20.0f, 320.0f, 44.0f)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)];
    UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"Latest News"];
    titleItem.rightBarButtonItem = shareButton;
    titleItem.leftBarButtonItem = closeButton;
    [self.navigationBar setItems:@[titleItem]];
    [self.view addSubview:self.navigationBar];
    
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.0f, 320.0f, 1.0f)];
    shadowView.backgroundColor = [UIColor colorWithRed:40/255 green:39/255 blue:38/255 alpha:1.0f];
    [self.view addSubview:shadowView];
    
    self.webView = [[UIWebView alloc] init];
    [self.webView setDelegate:self];
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    self.webView.frame = CGRectMake(0.0f, 64.0f, 320.0f, self.view.bounds.size.height - 64.0f);
    self.webView.clipsToBounds = YES;
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.storyURL];
    [self.webView loadRequest:request];
}

- (IBAction)share:(id)sender {
    
}

- (IBAction)close:(id)sender {
    [self closeModal];
}

@end
