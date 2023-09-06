//  UIImageAdditions
//  Project
//
//  Created by Paperman on 14-1-1.
//  Copyright (c) 2014年 Paperman. All rights reserved.
//

#import "ISSAdditions+UIImage.h"

@implementation UIImage (ISSCategory)

+ (UIImage *)imageWithColor:(UIColor *)color forSize:(CGSize)size {
    CGRect frameRect=CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor); //image frame color
    CGContextFillRect(ctx, frameRect);
    UIImage*image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage*image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)imageWithScale:(CGFloat)scale {
    UIImage *result = [UIImage imageWithCGImage:self.CGImage scale:scale orientation:self.imageOrientation];
    return [result imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
