//
//  UIControl+FixMultiClick.h
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define defaultInterval .5//默认时间间隔

@interface UIControl (FixMultiClick)

@property(nonatomic,assign)NSTimeInterval timeInterval;//用这个给重复点击加间隔

@property(nonatomic,assign)BOOL isIgnoreEvent;//YES不允许点击NO允许点击

/// 用于设置单个按钮不需要被hook
@property (nonatomic, assign) BOOL isIgnore;

@end
