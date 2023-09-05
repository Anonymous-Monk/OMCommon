//
//  UIControl+RHSound.h
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (RHSound)

//不同事件增加不同声音
- (void)rh_setSoundNamed:(NSString *)name forControlEvent:(UIControlEvents)controlEvent;

@end
