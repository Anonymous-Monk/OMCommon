//
//  UINavigationBar+RHAdd.h
//  MXSKit
//
//  Created by zero on 2022/3/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (RHAdd)

/// 隐藏导航条底部下划线
- (UINavigationBar *)rh_hiddenNavigationBarBottomLine;
/// 设置导航栏背景色
- (UINavigationBar * (^)(UIColor *))rh_changeNavigationBarBackgroundColor;
/// 设置图片背景导航栏
- (UINavigationBar * (^)(UIImage *))rh_changeNavigationBarImage;
/// 设置导航条标题颜色和字号
- (UINavigationBar * (^)(UIColor *, UIFont *))rh_changeNavigationBarTitle;
/// 默认恢复成系统的颜色和下划线
- (void)rh_resetNavigationBarSystem;
/// 设置自定义的返回按钮
- (void)rh_changeNavigationBarBackImage:(NSString*)imageName;

@end

NS_ASSUME_NONNULL_END
