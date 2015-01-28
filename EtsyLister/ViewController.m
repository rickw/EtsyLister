//
//  ViewController.m
//  EtsyLister
//
//  Created by Rick Windham on 1/28/15.
//  Copyright (c) 2015 Rick Windham. All rights reserved.
//

#import "ViewController.h"
#import "EtsyDataSource.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) EtsyDataSource *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _dataSource = [[EtsyDataSource alloc] init];
    _tableView.dataSource = _dataSource;
    _tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    ViewController *__weak weakSelf = self;
    
    _dataSource.block = ^{
        NSLog(@"I AM BLOCK");
        [weakSelf.tableView reloadData];
    };
    
    [_dataSource getFirstPageWithBlock:^{
        [_tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
