//
//  EtsyDataSource.m
//  EtsyLister
//
//  Created by Rick Windham on 1/28/15.
//  Copyright (c) 2015 Rick Windham. All rights reserved.
//

#import "EtsyDataSource.h"
#import "Cumulus.h"

@interface EtsyDataSource ()
@property (nonatomic, strong) CMResource        *etsy;
@property (nonatomic, strong) NSNumber          *totalCount;
@property (nonatomic, assign) NSNumber          *nextPage;
@property (nonatomic, strong) NSMutableArray    *results;
@property (nonatomic, assign) BOOL              fetchingNext;
@end

@implementation EtsyDataSource

#pragma mark - lifecycle methods

- (instancetype)init {
    if (self = [super init]) {
        _etsy = [CMResource withURL:@"https://api.etsy.com/v2/listings/active"];
        _etsy.query = @{@"api_key": @"liwecjs0c3ssk6let4p1wqt9",
                        @"includes": @"MainImage"};
        _results = [NSMutableArray array];
        _fetchingNext = NO;
        NSLog(@"initialized...");
    }
    
    return self;
}

#pragma mark - data fetching methods

- (void)getFirstPageForTableView:(UITableView *)tableView withKeywords:(NSString *)keywords {
    NSLog(@"getResults");
    [_results removeAllObjects];
    _totalCount = nil;
    _nextPage = nil;
    
    NSMutableDictionary *newQuery = [NSMutableDictionary dictionaryWithDictionary:_etsy.query];
    newQuery[@"keywords"] = [keywords stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [newQuery removeObjectForKey:@"page"];
    _etsy.query = newQuery;
    
    [_etsy getWithCompletionBlock:^(CMResponse *response) {
        _totalCount = [response.result objectForKey:@"count"];
        _nextPage = [[response.result objectForKey:@"pagination"] objectForKey:@"next_page"];
        
        [_results addObjectsFromArray:[response.result objectForKey:@"results"]];
        
        NSLog(@"---> %lu ---> %@ ---> %@", (unsigned long)_results.count, _nextPage, _totalCount);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [tableView reloadData];
            
            if (_loadBlock) {
                _loadBlock();
            }
        });
    }];
}

- (void)fetchNextPageForTableView:(UITableView *)tableView {
    if (_nextPage) {
        NSLog(@"fetching...");
        NSMutableDictionary *newQuery = [NSMutableDictionary dictionaryWithDictionary:_etsy.query];
        newQuery[@"page"] = _nextPage;
        _etsy.query = newQuery;
        
        [_etsy getWithCompletionBlock:^(CMResponse *response) {
            _nextPage = [[response.result objectForKey:@"pagination"] objectForKey:@"next_page"];
            
            [_results addObjectsFromArray:[response.result objectForKey:@"results"]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView reloadData];
                
                if (_loadBlock) {
                    _loadBlock();
                }
                _fetchingNext = NO;
            });
            
            NSLog(@"fetched");
        }];
    }
}

#pragma mark - table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_fetchingNext == NO && indexPath.row >= _results.count - 10) {
        _fetchingNext = YES;
        [self fetchNextPageForTableView:tableView];
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EtsyCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    if (indexPath.row > _results.count -1) {
        cell.textLabel.text = @"Loading...";
    } else {
        cell.textLabel.text = [[_results objectAtIndex:indexPath.row] objectForKey:@"title"];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _totalCount.intValue;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
