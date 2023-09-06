//
//  ISSMenuPopoverView.h
//  oumaSoftFramework
//
//  Created by Paperman on 16/7/7.
//
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ISSMenuItem : NSObject
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image;

@property (assign, nonatomic) NSInteger tag;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) UIImage *image;
@end

@class ISSLayerMenuPopoverView;
@protocol ISSMenuPopoverViewDelegate <NSObject>
@optional
- (void)menuPopoverView:(ISSLayerMenuPopoverView *)menuPopoverView clickedButtonAtIndex:(NSInteger)index;
@end

typedef void(^ISSMenuPopoverViewCallback)(ISSLayerMenuPopoverView *menuPopoverView, NSInteger index);

@interface ISSLayerMenuPopoverView : UIView

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)initWithDelegate:(id <ISSMenuPopoverViewDelegate>)delegate buttonTitles:(ISSMenuItem *)menuItems, ... NS_REQUIRES_NIL_TERMINATION;

@property (weak, nonatomic) id <ISSMenuPopoverViewDelegate> delegate;
- (void)setMenuPopoverViewCallback:(ISSMenuPopoverViewCallback)callback;

@property (strong, nonatomic) UIColor *popoverTintColor;

@property (strong, nonatomic) UIColor *selectedBackgroundColor;
@property (strong, nonatomic) UIColor *separatorColor;

@property (strong, nonatomic) UIColor *titleColor;

- (NSInteger)addMenuItem:(__kindof ISSMenuItem *)item;
- (__kindof ISSMenuItem *)menuItemAtIndex:(NSInteger)buttonIndex;

- (void)showFromBarButtonItem:(UIBarButtonItem *)item;
- (void)showFromView:(UIView *)view;

- (void)showFromRect:(CGRect)rect;

- (void)dismiss;

@end
NS_ASSUME_NONNULL_END
