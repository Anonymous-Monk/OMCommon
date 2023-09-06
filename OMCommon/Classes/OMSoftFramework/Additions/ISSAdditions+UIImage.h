//  UIImageAdditions
//  Project
//
//  Created by Paperman on 14-1-1.
//  Copyright (c) 2014年 Paperman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ISSCategory)

/**
 * Color转Image
 * @param color         Color
 * @param size          Size
 *
 */
+ (UIImage *)imageWithColor:(UIColor *)color forSize:(CGSize)size;

/**
 * View转Image/获取View快照
 * @param view          View
 *
 */
+ (UIImage *)imageWithView:(UIView *)view;


- (UIImage *)imageWithScale:(CGFloat)scale;

@end
