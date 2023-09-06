//
//  BaseTableViewController.h
//  Project
//
//  Created by Paperman on 14-1-1.
//  Copyright (c) 2014年 Paperman. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"

/**
 * 自定义TableViewController 集成 刷新/加载/完成 方法
 */

@interface BaseTableViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>

@property (strong, nonatomic, readonly) PullTableView *pullTableView;
@property (strong, nonatomic, readonly) NSLayoutConstraint *topTableView;
@property (strong, nonatomic, readonly) NSLayoutConstraint *bottomTableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

- (void)refreshData;
- (void)loadMoreData;
- (void)dataCompleted;
- (void)reloadData;

@end
