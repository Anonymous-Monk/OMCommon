//
//  UIImage+Compress.h
//  BANetManager
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIImage JPEGImage;
typedef UIImage PNGImage;
typedef NSData JPEGData;
typedef NSData PNGData;

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (RHCompress)

/**
 *  传入图片,需要的大小,比例,得到压缩图片大小
 *
 *      @prama image 需要压缩的图片
 *      @prama size  压缩后图片的大小
 *      @prama scale 压缩的比例 0.0 - 1.0
 *
 *      @return 返回新的图片
 */
+ (JPEGImage *)rh_needCompressImage:(UIImage *)image size:(CGSize )size scale:(CGFloat )scale;
+ (JPEGImage *)rh_needCompressImageData:(NSData *)imageData size:(CGSize )size scale:(CGFloat )scale;

/**
 *  传入图片,获取中间部分,需要的大小,压缩比例
 *
 *      @prama image 需要压缩的图片
 *      @prama size  压缩后图片的大小
 *      @prama scale 压缩的比例 0.0 - 1.0
 *
 *      @return 返回新的图片
 */
+ (JPEGImage *)rh_needCenterImage:(UIImage *)image size:(CGSize )size scale:(CGFloat )scale;


/**
 *  png图片转为jpeg(jpg)图片
 *
 *      @prama image 需要转为jpeg的png图片
 *
 *      @return 返回一张jpeg图片
 */
+ (JPEGImage *)rh_jpegImageWithPNGImage:(PNGImage *)pngImage;
+ (JPEGImage *)rh_jpegImageWithPNGData:(PNGData *)pngData;
+ (JPEGData *)rh_jpegDataWithPNGData:(PNGData *)pngData;
+ (JPEGData *)rh_jpegDataWithPNGImage:(PNGImage *)pngImage;

@end

NS_ASSUME_NONNULL_END
