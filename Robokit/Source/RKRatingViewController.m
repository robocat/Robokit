//
//  RatingViewController.m
//  Thermo
//
//  Created by Willi Wu on 21/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RKRatingViewController.h"
#import "Robokit.h"
#import "Flurry.h"

@interface RKRatingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *rateTitle;
@property (weak, nonatomic) IBOutlet UILabel *rateText;
@property (weak, nonatomic) IBOutlet UIButton *noThanksButton;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (weak, nonatomic) IBOutlet UIView *starsView;
@property (weak, nonatomic) IBOutlet UIView *rateView;

@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;

@property (strong, nonatomic) NSArray *stars;
@property (assign, nonatomic) NSInteger starCount;

@property (copy, nonatomic) void (^closeHandler)(void);

@end

@implementation RKRatingViewController

#pragma mark - View lifecycle

+ (RKRatingViewController *)ratingViewController {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RKRatingViewController" bundle:nil];
	RKRatingViewController *ratingViewController = [storyboard instantiateInitialViewController];
	return ratingViewController;
}

- (void)presentInWindow:(UIWindow *)window withCloseHandler:(void (^)(void))closeHandler {
	self.view.alpha = 0;
	
	self.view.frame = window.bounds;
	[window addSubview:self.view];
	
	[UIView animateWithDuration:.3 animations:^{
		self.view.alpha = 1;
	}];
	
	self.closeHandler = closeHandler;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.rateTitle.text = [NSString stringWithFormat:RKLocalizedFromTable(@"TITLE_RATE_%@", NSStringFromClass(self.class)), [RKSocial appName]];
	[self.noThanksButton setTitle:RKLocalizedFromTable(@"NO_THANKS_BUTTON", NSStringFromClass(self.class)) forState:UIControlStateNormal];
	[self.rateButton setTitle:RKLocalizedFromTable(@"RATE_BUTTON", NSStringFromClass(self.class)) forState:UIControlStateNormal];
	
	self.stars = @[ self.star1, self.star2, self.star3, self.star4, self.star5 ];
	
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.rateView.bounds];
	toolbar.translucent = YES;
	[self.rateView insertSubview:toolbar atIndex:0];
	self.rateView.backgroundColor = [UIColor clearColor];
	
	self.rateView.clipsToBounds = YES;
	self.rateView.layer.cornerRadius = 10;
	
	UIInterpolatingMotionEffect *motionEffectx = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	motionEffectx.minimumRelativeValue = @( -20 );
	motionEffectx.maximumRelativeValue = @(  20 );
	[self.rateView addMotionEffect:motionEffectx];
	
	UIInterpolatingMotionEffect *motionEffecty = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	motionEffecty.minimumRelativeValue = @( -20 );
	motionEffecty.maximumRelativeValue = @(  20 );
	[self.rateView addMotionEffect:motionEffecty];
	
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
	[self.starsView addGestureRecognizer:panGesture];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
	[self.starsView addGestureRecognizer:tapGesture];
	
	[self setStarCount:5];
}

- (void)didPan:(UIPanGestureRecognizer *)panGesture {
	NSInteger starCount = [panGesture locationInView:self.starsView].x / self.starsView.frame.size.width * self.stars.count + 1;
	[self setStarCount:starCount];
}

- (void)didTap:(UITapGestureRecognizer *)tapGesture {
	NSInteger starCount = [tapGesture locationInView:self.starsView].x / self.starsView.frame.size.width * self.stars.count + 1;
	[self setStarCount:starCount];
}

- (void)setStarCount:(NSInteger)starCount {
	starCount = MIN(MAX(starCount, 1), self.stars.count);
	_starCount = starCount;
	
	int i;
	for (i = 0; i < self.stars.count; i++) {
		UIImage *image = (i < starCount? [UIImage imageNamed:@"fullstar"]: [UIImage imageNamed:@"emptystar"]);
		[self.stars[i] setImage:image];
	}
	
	self.rateText.text = [self stringForRating:starCount];
}

- (IBAction)noThanks:(id)sender {
	[Flurry logEvent:@"Did say no thanks to rate popup"];
	
	[self close];
}

- (IBAction)rate:(id)sender {
	[Flurry logEvent:@"Did rate app on rate popup" withParameters:@{ @"Number of stars": @( self.starCount ) }];
	
	if (self.starCount >= 4) {
		[RKSocial rateAppWithCompletion:nil];
	}
	
	[self close];
}

- (void)close {
	[UIView animateWithDuration:.3 animations:^{
		self.view.alpha = 0;
	} completion:^(BOOL finished) {
		[self.view removeFromSuperview];
		if (self.closeHandler) self.closeHandler();
	}];
}

- (NSString *)stringForRating:(NSInteger)rating {
	return RKLocalizedFromTable(
	rating == 1? @"RATE_1_STAR":
	rating == 2? @"RATE_2_STARS":
	rating == 3? @"RATE_3_STARS":
	rating == 4? @"RATE_4_STARS":
	rating == 5? @"RATE_5_STARS":
	@"No rating", NSStringFromClass(self.class));
}

@end
