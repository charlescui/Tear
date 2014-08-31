//
//  TearTests.m
//  TearTests
//
//  Created by 崔峥 on 14-8-31.
//  Copyright (c) 2014年 cuizzz. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TearTests : XCTestCase

@end

@implementation TearTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
