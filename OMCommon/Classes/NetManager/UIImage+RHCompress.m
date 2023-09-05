//
//  UIImage+Compress.m
//  BANetManager
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import "UIImage+RHCompress.h"

@implementation UIImage (RHCompress)

+(JPEGImage *)rh_needCompressImage:(UIImage *)image size:(CGSize )size scale:(CGFloat )scale
{
    JPEGImage *newImage = nil;
    //创建画板
    UIGraphicsBeginImageContext(size);
    
    //写入图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //得到新的图片
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //释放画板
    UIGraphicsEndImageContext();
    
    //比例压缩
    newImage = [UIImage imageWithData:UIImageJPEGRepresentation(newImage, scale)];
    //    newImage = [UIImage imageWithData:UIImageJPEGRepresentation(newImage, 1.0) scale:scale];
    
    return newImage;
}

+(JPEGImage *)rh_needCompressImageData:(NSData *)imageData size:(CGSize )size scale:(CGFloat )scale
{
    PNGImage *image = [UIImage imageWithData:imageData];
    return [UIImage rh_needCompressImage:image size:size scale:scale];
}

+ (JPEGImage *)rh_needCenterImage:(UIImage *)image size:(CGSize )size scale:(CGFloat )scale
{
    /* 想切中间部分,待解决 */
    //#warning area of center image
    JPEGImage *newImage = nil;
    //创建画板
    UIGraphicsBeginImageContext(size);
    
    //写入图片,在中间
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //得到新的图片
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //释放画板
    UIGraphicsEndImageContext();
    
    //比例压缩
    newImage = [UIImage imageWithData:UIImageJPEGRepresentation(newImage, scale)];
    
    return newImage;
}

+(JPEGImage *)rh_jpegImageWithPNGImage:(PNGImage *)pngImage
{
    return [UIImage rh_needCompressImage:pngImage size:pngImage.size scale:1.0];
}

+(JPEGImage *)rh_jpegImageWithPNGData:(PNGData *)pngData
{
    PNGImage *pngImage = [UIImage imageWithData:pngData];
    return [UIImage rh_needCompressImage:pngImage size:pngImage.size scale:1.0];
}

+(JPEGData *)rh_jpegDataWithPNGData:(PNGData *)pngData
{
    return UIImageJPEGRepresentation([UIImage rh_jpegImageWithPNGData:pngData], 1.0);
}

+(JPEGData *)rh_jpegDataWithPNGImage:(PNGImage *)pngImage
{
    return UIImageJPEGRepresentation([UIImage rh_jpegImageWithPNGImage:pngImage], 1.0);
}

@end
