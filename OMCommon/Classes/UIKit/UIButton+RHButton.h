//
//  UIButton+RHButton.h
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RHImagePosition) {
    RHImagePositionLeft = 0,              //图片在左，文字在右，默认
    RHImagePositionRight = 1,             //图片在右，文字在左
    RHImagePositionTop = 2,               //图片在上，文字在下
    RHImagePositionBottom = 3,            //图片在下，文字在上
};

typedef void (^RHTouchedButtonBlock)(NSInteger tag);

@interface UIButton (RHButton)

/**
 *  @brief  设置按钮额外热区
 */
@property (nonatomic, assign) UIEdgeInsets rh_touchAreaInsets;

/**
 *  @brief  使用颜色设置按钮背景
 *
 *  @param backgroundColor 背景颜色
 *  @param state           按钮状态
 */
- (void)rh_setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)rh_setImagePosition:(RHImagePosition)postion spacing:(CGFloat)spacing;

/**
 This method will show the activity indicator in place of the button text.
 */
- (void)rh_showIndicator;

/**
 This method will remove the indicator and put thebutton text back in place.
 */
- (void)rh_hideIndicator;
/*
 add Action Block
 */
-(void)rh_addActionHandler:(RHTouchedButtonBlock)touchHandler;

@end

NS_ASSUME_NONNULL_END
