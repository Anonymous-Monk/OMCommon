//
//  NSDictionary+RHDictionary.m
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import "NSDictionary+RHDictionary.h"

@implementation NSDictionary (RHDictionary)

+ (NSDictionary *)rh_dictionaryWithURLString:(NSString *)urlString {
    
    NSString *rh_queryString;
    
    if ([urlString containsString:@"?"]) {
        
        NSArray *rh_urlArray = [urlString componentsSeparatedByString:@"?"];
        
        rh_queryString = rh_urlArray.lastObject;
    } else {
        
        rh_queryString = urlString;
    }
    
    NSMutableDictionary *rh_queryDictionary = [NSMutableDictionary dictionary];
    
    NSArray *rh_parameters = [rh_queryString componentsSeparatedByString:@"&"];
    
    [rh_parameters enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray *rh_contents = [obj componentsSeparatedByString:@"="];
        
        NSString *rh_key   = rh_contents.firstObject;
        NSString *rh_value = rh_contents.lastObject;
        
        rh_value = [rh_value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if (rh_key && rh_value) {
            
            [rh_queryDictionary setObject:rh_value
                                   forKey:rh_key];
        }
    }];
    
    return [rh_queryDictionary copy];
}


@end
