//
//  PullCollectionView.m
//  Project
//
//  Created by Paperman on 14-1-1.
//  Copyright (c) 2014年 Paperman. All rights reserved.
//

#import "PullCollectionView.h"
#import "PullRefreshHeaderView.h"
#import "PullLoadMoreFooterView.h"

@interface PullCollectionView (Private) <UIScrollViewDelegate, PullRefreshHeaderDelegate, PullLoadMoreFooterDelegate>
- (void) config;
- (void) configDisplayProperties;
@end

@implementation PullCollectionView

# pragma mark - Initialization / Deallocation

@synthesize pullDelegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self config];
}

- (void)dealloc {
    delegateInterceptor = nil;
}

- (void) config
{
    /* Message interceptor to intercept scrollView delegate messages */
    delegateInterceptor = [[PullMessageInterceptor alloc] init];
    delegateInterceptor.middleMan = self;
    delegateInterceptor.receiver = self.delegate;
    super.delegate = (id)delegateInterceptor;
    super.alwaysBounceVertical = YES;

    /* Status Properties */
    pullScrollIsRefreshing = NO;
    pullScrollIsLoadingMore = NO;
    displayPullScrollRefresh = YES;
    displayPullScrollLoadingMore = YES;
    
    [self addPullView];
}

- (void)addPullView {
    if (self.pullDelegate) {
        CGFloat height = self.bounds.size.height;
        CGFloat width = self.bounds.size.width;
        
        /* Refresh View */
        if (!refreshView && [self.pullDelegate respondsToSelector:@selector(pullCollectionViewDidTriggerLoadMore:)]) {
            refreshView = [[PullRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -height, width, height)];
            refreshView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
            refreshView.delegate = self;
            [self addSubview:refreshView];
        }
        
        /* Load more view init */
        if (!loadMoreView && [self.pullDelegate respondsToSelector:@selector(pullCollectionViewDidTriggerRefresh:)]) {
            loadMoreView = [[PullLoadMoreFooterView alloc] initWithFrame:CGRectMake(0, height, width, height)];
            loadMoreView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
            loadMoreView.delegate = self;
            [self addSubview:loadMoreView];
        }
    }
}

# pragma mark - View changes

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat visibleScrollDiffBoundsHeight = (self.bounds.size.height - MIN(self.bounds.size.height, self.contentSize.height));

    CGRect loadMoreFrame = loadMoreView.frame;
    loadMoreFrame.origin.y = self.contentSize.height + visibleScrollDiffBoundsHeight;
    loadMoreView.frame = loadMoreFrame;
}

#pragma mark - Preserving the original behaviour

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate
{
    if (delegateInterceptor) {
        super.delegate = nil;
        delegateInterceptor.receiver = delegate;
        super.delegate = (id)delegateInterceptor;
    } else {
        super.delegate = delegate;
    }
}

- (void)setPullDelegate:(id<PullCollectionViewDelegate>)delegate
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

- (void)setDisplayPullScrollRefresh:(BOOL)isRefreshDisplay
{
    [self setPullScrollIsRefreshing:NO];
    [refreshView setHidden:!isRefreshDisplay];
    displayPullScrollRefresh = isRefreshDisplay;
}

- (void)setDisplayPullScrollLoadingMore:(BOOL)isLoadingMoreDisplay
{
    [self setPullScrollIsLoadingMore:NO];
    [loadMoreView setHidden:!isLoadingMoreDisplay];
    displayPullScrollLoadingMore = isLoadingMoreDisplay;
}

- (void)setPullScrollIsRefreshing:(BOOL)isRefreshing
{
    if (!pullScrollIsRefreshing && isRefreshing && displayPullScrollRefresh) {
        // If not allready refreshing start refreshing
        [refreshView startAnimatingWithScrollView:self];
        pullScrollIsRefreshing = YES;
    } else if(pullScrollIsRefreshing && !isRefreshing && displayPullScrollRefresh) {
        [refreshView refreshScrollViewDataSourceDidFinishedLoading:self];
        pullScrollIsRefreshing = NO;
    }
}

- (void)setPullScrollIsLoadingMore:(BOOL)isLoadingMore
{
    if (!pullScrollIsLoadingMore && isLoadingMore && displayPullScrollLoadingMore) {
        // If not allready loading more start refreshing
        [loadMoreView startAnimatingWithScrollView:self];
        pullScrollIsLoadingMore = YES;
    } else if(pullScrollIsLoadingMore && !isLoadingMore && displayPullScrollLoadingMore) {
        [loadMoreView loadMoreScrollViewDataSourceDidFinishedLoading:self];
        pullScrollIsLoadingMore = NO;
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
    
    if (displayPullScrollRefresh) {
        [refreshView refreshScrollViewDidScroll:scrollView];
    }
    if (displayPullScrollLoadingMore) {
        [loadMoreView loadMoreScrollViewDidScroll:scrollView];
    }
    
    // Also forward the message to the real delegate
    if ([delegateInterceptor.receiver respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [delegateInterceptor.receiver scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
 
    if (displayPullScrollRefresh) {
        [refreshView refreshScrollViewDidEndDragging:scrollView];
    }
    if (displayPullScrollLoadingMore) {
        [loadMoreView loadMoreScrollViewDidEndDragging:scrollView];
    }
    
    // Also forward the message to the real delegate
    if ([delegateInterceptor.receiver respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [delegateInterceptor.receiver scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (displayPullScrollRefresh) {
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
    pullScrollIsRefreshing = YES;
    [pullDelegate pullCollectionViewDidTriggerRefresh:self];
}

- (NSDate*)refreshScrollHeaderDataSourceLastUpdated:(PullRefreshHeaderView*)view
{
    return self.pullLastRefreshDate;
}

#pragma mark - PullLoadMoreFooterDelegate

- (void)loadMoreScrollFooterDidTriggerLoadMore:(PullLoadMoreFooterView *)view
{
    pullScrollIsLoadingMore = YES;
    [pullDelegate pullCollectionViewDidTriggerLoadMore:self];
}
@end
