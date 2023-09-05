//
//  UIBarButtonItem+RHBarItem.m
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import "UIBarButtonItem+RHBarItem.h"

@implementation UIBarButtonItem (RHBarItem)

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image
                                  highImage:(UIImage *)highImage
                                     target:(id)target
                                     action:(SEL)action
                           forControlEvents:(UIControlEvents)controlEvents

{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [btn sizeToFit];
    
    [btn addTarget:target action:action forControlEvents:controlEvents];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
