//
//  NSURL+RHURL.m
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import "NSURL+RHURL.h"
#import "NSString+RHString.h"

@implementation NSURL (RHURL)

+ (void)rh_openBrowserWithURL:(NSString *)urlString {
    
    [[UIApplication sharedApplication] openURL:[self URLWithString:urlString]];
}

+ (NSURL *)rh_getURLForDirectory:(NSSearchPathDirectory)directory {
    
    NSArray *rh_urlArray = [NSFileManager.defaultManager URLsForDirectory:directory
                                                                inDomains:NSUserDomainMask];
    
    return rh_urlArray.lastObject;
}

+ (NSURL *)rh_getDocumentURLPath {
    
    return [self rh_getURLForDirectory:NSDocumentDirectory];
}

+ (NSURL *)rh_getLibraryURLPath {
    
    return [self rh_getURLForDirectory:NSLibraryDirectory];
}

+ (NSURL *)rh_getCachesURLPath {
    
    return [self rh_getURLForDirectory:NSCachesDirectory];
}

@end
