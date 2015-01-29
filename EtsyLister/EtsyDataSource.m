//
//  EtsyDataSource.m
//  EtsyLister
//
//  Created by Rick Windham on 1/28/15.
//  Copyright (c) 2015 Rick Windham. All rights reserved.
//

#import "EtsyDataSource.h"
#import "Cumulus.h"
#import "EtsyCell.h"

@interface EtsyDataSource ()
@property (strong, nonatomic) CMResource        *etsy;
@property (strong, nonatomic) NSNumber          *totalCount;
@property (assign)            NSNumber          *nextPage;
@property (strong, nonatomic) NSMutableArray    *results;
@property (assign)            BOOL              fetchingNext;
@end

@implementation EtsyDataSource

#pragma mark - lifecycle methods

- (instancetype)init {
    if (self = [super init]) {
        _etsy = [CMResource withURL:@"https://api.etsy.com/v2/listings/active"];
        _etsy.query = @{@"api_key": @"liwecjs0c3ssk6let4p1wqt9",
                        @"includes": @"MainImage"};
        _etsy.contentType = CMContentTypeJSON;
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

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"end decelerating");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // this isn't the best way to load more data, but it works for now
    if (_fetchingNext == NO && indexPath.row >= _results.count - 10) {
        _fetchingNext = YES;
        [self fetchNextPageForTableView:tableView];
    }
    
    NSLog(@"===> %lu %li", (unsigned long)_results.count, (long)indexPath.row);
    
    EtsyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EtsyCell"];
    if (cell == nil) {
        cell = [[EtsyCell alloc] init];
    }
    
    if (indexPath.row >= _results.count) {
        cell.textLabel.text = @"Loading...";
    } else {
        cell.textLabel.text = [[_results objectAtIndex:indexPath.row] objectForKey:@"title"];
    }
    
    [cell fadeIn];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _totalCount.intValue + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
