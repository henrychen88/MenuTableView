//
//  ViewController.m
//  MenuTableView
//
//  Created by Henry on 15-2-10.
//  Copyright (c) 2015年 Henry. All rights reserved.
//

#import "ViewController.h"

#import "MenuTableView.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) MenuTableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"MenuTableView";
    
    [self.view addSubview:self.tableView];
}

- (MenuTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[MenuTableView alloc]initWithFrame:self.view.bounds];
    }
    return _tableView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
