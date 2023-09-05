//
//  UINavigationBar+RHAdd.m
//  MXSKit
//
//  Created by zero on 2022/3/5.
//

#import "UINavigationBar+RHAdd.h"

@implementation UINavigationBar (RHAdd)

- (UINavigationBar *)rh_hiddenNavigationBarBottomLine{
    if (@available(iOS 13.0, *)) {
        self.standardAppearance.shadowColor = [UIColor clearColor];
    }else{
        if (@available(iOS 10.0, *)){
            [self rh_hiddenLine:YES];
        }else{
            self.shadowImage = [UIImage new];
        }
    }
    return self;
}
- (UINavigationBar * (^)(UIColor *))rh_changeNavigationBarBackgroundColor{
    return ^(UIColor * color){
        if (color == UIColor.clearColor || CGColorGetAlpha(color.CGColor) <= 0.0001) {
            if (@available(iOS 13.0, *)) {
                [self.standardAppearance configureWithTransparentBackground];
                self.standardAppearance.shadowColor = [UIColor clearColor];
            }else{
                [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
                if (@available(iOS 10.0, *)){
                    [self rh_hiddenLine:YES];
                }else{
                    self.shadowImage = [UIImage new];
                }
            }
        }else{
            if (@available(iOS 13.0, *)) {
                [self.standardAppearance configureWithOpaqueBackground];
                [self.standardAppearance setBackgroundColor:color];
                [self.standardAppearance setBackgroundImage:nil];
            }else{
                [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
                [self setBarTintColor:color];
            }
        }
        return self;
    };
}
/// 设置图片背景导航栏
- (UINavigationBar * (^)(UIImage *))rh_changeNavigationBarImage{
    return ^(UIImage *image){
        UIColor *color = [UIColor colorWithPatternImage:image];
        return self.rh_changeNavigationBarBackgroundColor(color);
    };
}
- (UINavigationBar * (^)(UIColor *, UIFont *))rh_changeNavigationBarTitle{
    return ^(UIColor * color, UIFont * font){
        if (@available(iOS 13.0, *)) {
            [self.standardAppearance setTitleTextAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
        }else{
            [self setTitleTextAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
        }
        return self;
    };
}
- (void)rh_resetNavigationBarSystem{
    if (@available(iOS 13.0, *)){
        [self.standardAppearance configureWithDefaultBackground];
        self.standardAppearance.shadowImage = nil;
    }else{
        [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        if (@available(iOS 10.0, *)){
            [self rh_hiddenLine:NO];
        }else{
            self.shadowImage = nil;
        }
    }
}
- (void)rh_changeNavigationBarBackImage:(NSString*)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (@available(iOS 13.0, *)){
        [self.standardAppearance setBackIndicatorImage:image transitionMaskImage:image];
    }else{
        self.backIndicatorTransitionMaskImage = self.backIndicatorImage = image;
    }
}
/// 隐藏线条
- (void)rh_hiddenLine:(BOOL)hidden{
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        for (UIView *view in self.subviews){
            for (id obj in view.subviews) {
                if ([obj isKindOfClass:[UIImageView class]]) {
                    ((UIImageView*)obj).hidden = hidden;
                }
            }
        }
    }
}

@end
