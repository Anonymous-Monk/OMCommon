//
//  NSData+RHData.h
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RHDataBaseType) {
    
    CLDataBaseType64 = 64,
    CLDataBaseType76 = 76
};

@interface NSData (RHData)

/**
 将指定的图片转成NSData, 可输入指定压缩比例
 
 @param image UIImage
 @param compressionQuality 压缩比例
 @return NSData
 */
+ (NSData *)rh_compressOriginalImage:(UIImage *)image
                  compressionQuality:(CGFloat)compressionQuality;

/**
 将制定的APNs NSData转成NSString
 
 @param data NSData
 @return NSString
 */
+ (NSString *)rh_replacingAPNsTokenWithData:(NSData *)data;

#pragma mark - Base 64加密/解密
/**
 将Base 64的字符串转成NSData
 
 @param string NSString
 @return NSData
 */
+ (NSData *)rh_transformDataWithBase64EncodedString:(NSString *)string;

/**
 将指定的NSData转成64或76的字符串
 
 @param data NSData
 @param wrapWidth CLDataBaseType
 @return NSString
 */
+ (NSString *)rh_transformBase64EncodedStringWithData:(NSData *)data
                                            wrapWidth:(RHDataBaseType)wrapWidth;

#pragma mark - AES加密/解密
/**
 利用AES加密NSData
 
 @param key NSString
 @param encryptData NSData
 @return NSData
 */
- (NSData *)rh_encryptedDataWithAESKey:(NSString *)key
                           encryptData:(NSData *)encryptData;

/**
 利用AES解密NSData
 
 @param key NSString
 @param decryptData NSData
 @return NSData
 */
- (NSData *)rh_decryptedDataWithAESKey:(NSString *)key
                           decryptData:(NSData *)decryptData;

#pragma mark - 3DES加密/解密
/**
 利用3DES加密NSData
 
 @param key NSString
 @param encryptData NSData
 @return NSData
 */
- (NSData *)rh_encryptedDataWith3DESKey:(NSString *)key
                            encryptData:(NSData *)encryptData;

/**
 利用3DES解密NSData
 
 @param key NSString
 @param decryptData NSData
 @return NSData
 */
- (NSData *)rh_decryptedDataWith3DEKey:(NSString *)key
                           decryptData:(NSData *)decryptData;

@end
