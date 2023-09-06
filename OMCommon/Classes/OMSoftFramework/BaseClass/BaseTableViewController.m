//
//  BaseTableViewController.m
//  Project
//
//  Created by Paperman on 14-1-1.
//  Copyright (c) 2014年 Paperman. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController()
@property (strong, nonatomic) IBOutlet PullTableView *pullTableView;
@property (strong, nonatomic) UILabel *noResultLable;
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.pullTableView == nil) {
        _pullTableView = [[PullTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.pullTableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_pullTableView];

        self.pullTableView.dataSource = self;
        self.pullTableView.delegate = self;
        self.pullTableView.backgroundColor = [UIColor clearColor];
        self.pullTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.pullTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        self.pullTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        
        id viewDict = NSDictionaryOfVariableBindings(_pullTableView);
        NSArray *topConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_pullTableView]" options:0 metrics:nil views:viewDict];
        NSArray *bottomConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pullTableView]|" options:0 metrics:nil views:viewDict];
        _topTableView = [topConstraints firstObject];
        _bottomTableView = [bottomConstraints firstObject];
        [self.view addConstraints:@[self.topTableView, self.bottomTableView]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_pullTableView]|" options:0 metrics:nil views:viewDict]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView: (UITableView *)tableView editingStyleForRowAtIndexPath: (NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    [self performSelector:@selector(refreshData) withObject:nil afterDelay:0];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    [self performSelector:@selector(loadMoreData) withObject:nil afterDelay:0];
}

- (void)refreshData {

}

- (void)loadMoreData {

}

- (void)dataCompleted {
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
}

- (void)reloadData {
    [_pullTableView reloadData];
    [_pullTableView setPullTableIsRefreshing:NO];
    [_pullTableView setPullTableIsLoadingMore:NO];
    if (self.dataSource.count == 0) {
        if (_noResultLable == nil) {
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            _noResultLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, width, 44)];
            self.noResultLable.textAlignment= NSTextAlignmentCenter;
            self.noResultLable.font = [UIFont systemFontOfSize:20];
            self.noResultLable.textColor = [UIColor grayColor];
            self.noResultLable.text = @"查询无记录";
            [self.pullTableView addSubview:self.noResultLable];
        }
    } else {
        [self.noResultLable removeFromSuperview];
        _noResultLable = nil;
    }
}
@end
