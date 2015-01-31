//
//  ViewController.m
//  EtsyLister
//
//  Created by Rick Windham on 1/28/15.
//  Copyright (c) 2015 Rick Windham. All rights reserved.
//

#import "ViewController.h"
#import "EtsyDataSource.h"
#import "EtsyCell.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (weak, nonatomic) IBOutlet UITextField    *textEntry;
@property (weak, nonatomic) IBOutlet UIButton       *searchButton;
@property (strong, nonatomic)        EtsyDataSource *dataSource;
@end

@implementation ViewController

#pragma mark - lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _dataSource = [[EtsyDataSource alloc] init];
    _tableView.dataSource = _dataSource;
    _tableView.delegate = _dataSource;
    
    [_textEntry addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(endEditing)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    [_dataSource getFirstPageForTableView:_tableView withKeywords:@"leather"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"DID RECEIVE");
}

#pragma mark - action methods

- (IBAction)searchAction:(id)sender {
    [_textEntry resignFirstResponder];
    [_dataSource getFirstPageForTableView:_tableView withKeywords:_textEntry.text];
    [_tableView reloadData];
}

- (void)endEditing {
    [self.view endEditing:YES];
}

#pragma mark - text field event methods

- (void)textFieldDidChange:(id)sender {
    if (_textEntry.text.length > 3 && _searchButton.enabled == NO) {
        _searchButton.enabled = YES;
        _textEntry.returnKeyType = UIReturnKeyGo;
        [_textEntry resignFirstResponder];
        [_textEntry becomeFirstResponder];
    } else if (_textEntry.text.length <= 3 && _searchButton.enabled == YES) {
        _searchButton.enabled = NO;
        _textEntry.returnKeyType = UIReturnKeyDone;
        [_textEntry resignFirstResponder];
        [_textEntry becomeFirstResponder];
    }
    
}

#pragma mark - text field delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchAction:nil];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_tableView.visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(EtsyCell *)obj fadeOut];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_tableView.visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(EtsyCell *)obj fadeIn];
    }];
}

@end
