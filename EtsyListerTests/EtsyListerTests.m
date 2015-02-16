//
//  EtsyListerTests.m
//  EtsyListerTests
//
//  Created by Rick Windham on 1/28/15.
//  Copyright (c) 2015 Rick Windham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "EtsyDataSource.h"

@interface EtsyListerTests : XCTestCase
@property (nonatomic, strong) EtsyDataSource    *dataSource;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) XCTestExpectation *expect;
@end

@implementation EtsyListerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _dataSource = [[EtsyDataSource alloc] init];
    _tableView  = [[UITableView alloc] init];
    _tableView.dataSource = _dataSource;
    _expect     = [self expectationWithDescription:@"Page Loaded"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    _dataSource = nil;
    _tableView = nil;
}

- (void)testQueryResultSize {
    NSInteger expected = _dataSource.fetchBatchSize + 1;
    __typeof__(self) __weak weakSelf = self;
    _dataSource.loadBlock = ^{
        [weakSelf.expect fulfill];
    };
    
    [_dataSource getFirstPageForTableView:_tableView withKeywords:@"leather"];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *err){
        _dataSource.loadBlock = nil;
    }];
    
    XCTAssertEqual(expected, [weakSelf.dataSource tableView:weakSelf.tableView numberOfRowsInSection:1], @"supposed to be %li", (long)expected);

}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
