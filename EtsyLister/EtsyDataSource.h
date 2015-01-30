//
//  EtsyDataSource.h
//  EtsyLister
//
//  Created by Rick Windham on 1/28/15.
//  Copyright (c) 2015 Rick Windham. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LoadBlock)();

@interface EtsyDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (copy) LoadBlock loadBlock;

- (void)getFirstPageForTableView:(UITableView *)tableView withKeywords:(NSString *)keywords;

@end
