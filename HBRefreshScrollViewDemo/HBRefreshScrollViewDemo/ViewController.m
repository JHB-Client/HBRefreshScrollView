//
//  ViewController.m
//  HBRefreshScrollViewDemo
//
//  Created by admin on 2020/3/5.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ViewController.h"
#import "MyTableView.h"
#import "HBRefresher.h"
@interface ViewController ()
@property (nonatomic, strong) MyTableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.navigationController.navigationBarHidden = false;
    
    self.tableView = [[MyTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    HBRefresher *refresher = [[HBRefresher alloc] initWithFrame:CGRectMake(0, -100, self.view.bounds.size.width, 100)];
    
    self.tableView.refresher = refresher;
    [self.tableView.refresher addTarget:self refreshAction:@selector(refreshData)];
    [self.tableView.refresher beginRefresh];
}

- (void)refreshData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.refresher endRefresh];
    });
    
}

@end
