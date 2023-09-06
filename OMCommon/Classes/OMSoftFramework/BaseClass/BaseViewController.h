//
//  BaseViewController.h
//  Project
//
//  Created by Paperman on 14-1-1.
//  Copyright (c) 2014年 Paperman. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 自定义基础ViewController 设置automaticallyAdjustsScrollViewInsets为NO 设置标题文字
 */

@interface BaseViewController : UIViewController

/** 设置本地化文字
 */
- (void)setLocalizedString;

/** 默认返回按钮触发事件
 */
- (void)backBarAction:(id)sender;

@end
