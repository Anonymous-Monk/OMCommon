//
//  PullCollectionView.h
//  Project
//
//  Created by Paperman on 14-1-1.
//  Copyright (c) 2014年 Paperman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PullCollectionView, PullRefreshHeaderView, PullLoadMoreFooterView, PullMessageInterceptor;
@protocol PullCollectionViewDelegate <NSObject>

/* After one of the delegate methods is invoked a loading animation is started, to end it use the respective status update property */
@required
- (void)pullCollectionViewDidTriggerRefresh:(PullCollectionView *)pullCollectionView;
- (void)pullCollectionViewDidTriggerLoadMore:(PullCollectionView *)pullCollectionView;

@end

@interface PullCollectionView : UICollectionView {
    PullRefreshHeaderView *refreshView;
    PullLoadMoreFooterView *loadMoreView;
    
    // Since we use the contentInsets to manipulate the view we need to store the the content insets originally specified.
    UIEdgeInsets realContentInsets;
    
    // For intercepting the scrollView delegate messages.
    PullMessageInterceptor * delegateInterceptor;
    
    // Config
    UIImage *pullArrowImage;
    UIColor *pullBackgroundColor;
    UIColor *pullTextColor;
    NSDate *pullLastRefreshDate;
    
    // Status
    BOOL pullScrollIsRefreshing;
    BOOL pullScrollIsLoadingMore;
    BOOL displayPullScrollRefresh;
    BOOL displayPullScrollLoadingMore;
    
    // Delegate
    __unsafe_unretained id<PullCollectionViewDelegate> pullDelegate;
}

/* The configurable display properties of PullTableView. Set to nil for default values */
@property (nonatomic, retain) UIImage *pullArrowImage;
@property (nonatomic, retain) UIColor *pullBackgroundColor;
@property (nonatomic, retain) UIColor *pullTextColor;

/* Set to nil to hide last modified text */
@property (nonatomic, retain) NSDate *pullLastRefreshDate;

/* Properties to set the status of the refresh/loadMore operations. */
/* After the delegate methods are triggered the respective properties are automatically set to YES. After a refresh/reload is done it is necessary to set the respective property to NO, otherwise the animation won't disappear. You can also set the properties manually to YES to show the animations. */

- (void)setPullScrollIsRefreshing:(BOOL)isRefreshing;
- (void)setPullScrollIsLoadingMore:(BOOL)isLoadingMore;

/* Delegate */
@property (nonatomic, assign) IBOutlet id<PullCollectionViewDelegate> pullDelegate;

- (void)setDisplayPullScrollRefresh:(BOOL)isRefreshDisplay;
- (void)setDisplayPullScrollLoadingMore:(BOOL)isLoadingMoreDisplay;

@end
