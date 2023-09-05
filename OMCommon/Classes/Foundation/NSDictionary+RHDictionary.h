//
//  NSDictionary+RHDictionary.h
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (RHDictionary)

/**
 将指定的URL字符串转成NSDictionary
 
 @param urlString URL字符串, 格式: http://www.xxxx.com?a=1&b=2 || a=1&b=2
 @return NSDictionary
 */
+ (NSDictionary *)rh_dictionaryWithURLString:(NSString *)urlString;

@end
