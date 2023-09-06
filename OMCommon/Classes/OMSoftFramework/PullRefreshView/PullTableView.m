//
//  PullTableView.m
//  TableViewPull
//
//  Created by Emre Berge Ergenekon on 2011-07-30.
//  Copyright 2011 Emre Berge Ergenekon. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "PullTableView.h"
#import "PullRefreshHeaderView.h"
#import "PullLoadMoreFooterView.h"

@interface PullTableView (Private) <UIScrollViewDelegate, PullRefreshHeaderDelegate, PullLoadMoreFooterDelegate>
- (void) config;
- (void) configDisplayProperties;
@end

@implementation PullTableView

# pragma mark - Initialization / Deallocation

@synthesize pullDelegate;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self config];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self config];
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (void)dealloc {
    delegateInterceptor = nil;
}

# pragma mark - Custom view configuration

- (void)config
{
    /* Message interceptor to intercept scrollView delegate messages */
    delegateInterceptor = [[PullMessageInterceptor alloc] init];
    delegateInterceptor.middleMan = self;
    delegateInterceptor.receiver = self.delegate;
    super.delegate = (id)delegateInterceptor;
    
    /* Status Properties */
    pullTableIsRefreshing = NO;
    pullTableIsLoadingMore = NO;

    [self setExtraCellLineHidden:self];
    [self addPullView];
}

- (void)addPullView
{
    if (self.pullDelegate) {
        CGFloat height = self.bounds.size.height;
        CGFloat width = self.bounds.size.width;

        /* Refresh View */
        if (!refreshView && [self.pullDelegate respondsToSelector:@selector(pullTableViewDidTriggerRefresh:)]) {
            refreshView = [[PullRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -height, width, height)];
            refreshView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
            refreshView.delegate = self;
            [self addSubview:refreshView];
            displayPullTableRefresh = YES;
        }
        
        /* Load more view init */
        if (!loadMoreView && [self.pullDelegate respondsToSelector:@selector(pullTableViewDidTriggerLoadMore:)]) {
            loadMoreView = [[PullLoadMoreFooterView alloc] initWithFrame:CGRectMake(0, height, width, height)];
            loadMoreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            loadMoreView.delegate = self;
            [self addSubview:loadMoreView];
            displayPullTableLoadingMore = YES;
        }
    }
}

# pragma mark - View changes

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat visibleTableDiffBoundsHeight = (self.bounds.size.height - MIN(self.bounds.size.height, self.contentSize.height));
    
    CGRect loadMoreFrame = loadMoreView.frame;
    loadMoreFrame.origin.y = self.contentSize.height + visibleTableDiffBoundsHeight;
    loadMoreView.frame = loadMoreFrame;
}

#pragma mark - Preserving the original behaviour

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    if(delegateInterceptor) {
        super.delegate = nil;
        delegateInterceptor.receiver = delegate;
        super.delegate = (id)delegateInterceptor;
    } else {
        super.delegate = delegate;
    }
}

- (void)setPullDelegate:(id<PullTableViewDelegate>)delegate
{
    pullDelegate = delegate;
    [self addPullView];
}

- (void)reloadData
{
    [super reloadData];
    // Give the footers a chance to fix it self.
    [loadMoreView loadMoreScrollViewDidScroll:self];
}

#pragma mark - Status Propreties

- (void)setDisplayPullTableRefresh:(BOOL)isRefreshDisplay
{
    if (displayPullTableRefresh == isRefreshDisplay) return;
    [self setPullTableIsRefreshing:NO];
    [refreshView setHidden:!isRefreshDisplay];
    displayPullTableRefresh = isRefreshDisplay;
}

- (void)setDisplayPullTableLoadingMore:(BOOL)isLoadingMoreDisplay
{
    if (displayPullTableLoadingMore == isLoadingMoreDisplay) return;
    [self setPullTableIsLoadingMore:NO];
    [loadMoreView setHidden:!isLoadingMoreDisplay];
    displayPullTableLoadingMore = isLoadingMoreDisplay;
}

- (void)setPullTableIsRefreshing:(BOOL)isRefreshing
{
    if (!pullTableIsRefreshing && isRefreshing && displayPullTableRefresh) {
        // If not allready refreshing start refreshing
        [refreshView startAnimatingWithScrollView:self];
        pullTableIsRefreshing = YES;
    } else if(pullTableIsRefreshing && !isRefreshing && displayPullTableRefresh) {
        [refreshView refreshScrollViewDataSourceDidFinishedLoading:self];
        pullTableIsRefreshing = NO;
    }
}

- (void)setPullTableIsLoadingMore:(BOOL)isLoadingMore
{
    if (!pullTableIsLoadingMore && isLoadingMore && displayPullTableLoadingMore) {
        // If not allready loading more start refreshing
        [loadMoreView startAnimatingWithScrollView:self];
        pullTableIsLoadingMore = YES;
    } else if(pullTableIsLoadingMore && !isLoadingMore && displayPullTableLoadingMore) {
        [loadMoreView loadMoreScrollViewDataSourceDidFinishedLoading:self];
        pullTableIsLoadingMore = NO;
    }
}

#pragma mark - Display properties

@synthesize pullArrowImage;
@synthesize pullBackgroundColor;
@synthesize pullTextColor;
@synthesize pullLastRefreshDate;

- (void)configDisplayProperties
{
    [refreshView setBackgroundColor:self.pullBackgroundColor textColor:self.pullTextColor arrowImage:self.pullArrowImage];
    [loadMoreView setBackgroundColor:self.pullBackgroundColor textColor:self.pullTextColor arrowImage:self.pullArrowImage];
}

- (void)setPullArrowImage:(UIImage *)aPullArrowImage
{
    if (aPullArrowImage != pullArrowImage) {
        pullArrowImage = aPullArrowImage;
        [self configDisplayProperties];
    }
}

- (void)setPullBackgroundColor:(UIColor *)aColor
{
    if (aColor != pullBackgroundColor) {
        pullBackgroundColor = aColor;
        [self configDisplayProperties];
    } 
}

- (void)setPullTextColor:(UIColor *)aColor
{
    if (aColor != pullTextColor) {
        pullTextColor = aColor;
        [self configDisplayProperties];
    } 
}

- (void)setPullLastRefreshDate:(NSDate *)aDate
{
    if (aDate != pullLastRefreshDate) {
        pullLastRefreshDate = aDate;
        [refreshView refreshLastUpdatedDate];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (displayPullTableRefresh) {
        [refreshView refreshScrollViewDidScroll:scrollView];
    }
    if (displayPullTableLoadingMore) {
        [loadMoreView loadMoreScrollViewDidScroll:scrollView];
    }
    
    // Also forward the message to the real delegate
    if ([delegateInterceptor.receiver respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [delegateInterceptor.receiver scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (displayPullTableRefresh) {
        [refreshView refreshScrollViewDidEndDragging:scrollView];
    }
    if (displayPullTableLoadingMore) {
        [loadMoreView loadMoreScrollViewDidEndDragging:scrollView];
    }
    
    // Also forward the message to the real delegate
    if ([delegateInterceptor.receiver respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [delegateInterceptor.receiver scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (displayPullTableRefresh) {
        [refreshView refreshScrollViewWillBeginDragging:scrollView];
    }
    
    // Also forward the message to the real delegate
    if ([delegateInterceptor.receiver respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [delegateInterceptor.receiver scrollViewWillBeginDragging:scrollView];
    }
}

#pragma mark - PullRefreshHeaderDelegate

- (void)refreshScrollHeaderDidTriggerRefresh:(PullRefreshHeaderView*)view
{
    pullTableIsRefreshing = YES;
    [pullDelegate pullTableViewDidTriggerRefresh:self];
}

- (NSDate*)refreshScrollHeaderDataSourceLastUpdated:(PullRefreshHeaderView*)view
{
    return self.pullLastRefreshDate;
}

#pragma mark - PullLoadMoreFooterDelegate

- (void)loadMoreScrollFooterDidTriggerLoadMore:(PullLoadMoreFooterView *)view
{
    pullTableIsLoadingMore = YES;
    [pullDelegate pullTableViewDidTriggerLoadMore:self];
}
@end
