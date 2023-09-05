//
//  NSBundle+RHBundle.h
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (RHBundle)

/**
 获取App名称
 
 @return NSString
 */
+ (NSString *)rh_getBundleDisplayName;

/**
 获取App版本号
 
 @return NSString
 */
+ (NSString *)rh_getBundleShortVersionString;

/**
 获取Build版本号
 
 @return NSString
 */
+ (NSString *)rh_getBundleVersion;

/**
 获取App Bundle Identifier
 
 @return NSString
 */
+ (NSString *)rh_getBundleIdentifier;

@end
