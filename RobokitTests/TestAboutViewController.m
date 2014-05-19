//
//  TestAboutViewController.m
//  Robokit
//
//  Created by Kristian Andersen on 10/04/14.
//  Copyright (c) 2014 Robocat. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RKAboutRobocatViewController.h"

@interface TestAboutViewController : XCTestCase

@property(nonatomic, strong) RKAboutRobocatViewController *viewController;
@end

@implementation TestAboutViewController

- (void)setUp
{
    [super setUp];

    self.viewController = [RKAboutRobocatViewController aboutRobocatViewController];
}

- (void)tearDown
{
    self.viewController = nil;

    [super tearDown];
}

- (void)testCanInstantiateViewController {
    XCTAssertNotNil(self.viewController);
}

@end
