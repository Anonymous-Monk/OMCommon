//
//  NSURL+RHURL.h
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSURL (RHURL)

/**
 通过传入的URL地址打开外部浏览器
 
 @param urlString URL地址
 */
+ (void)rh_openBrowserWithURL:(NSString *)urlString;

/**
 获取Document URL Path
 
 @return NSURL
 */
+ (NSURL *)rh_getDocumentURLPath;

/**
 获取Library URL Path
 
 @return NSURL
 */
+ (NSURL *)rh_getLibraryURLPath;

/**
 获取Caches URL Path
 
 @return NSURL
 */
+ (NSURL *)rh_getCachesURLPath;

@end
