//
//  NSMutableDictionary+RHMutableDictionary.m
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import "NSMutableDictionary+RHMutableDictionary.h"

@implementation NSMutableDictionary (RHMutableDictionary)

- (void)rh_setSafeObject:(id)object
                  forKey:(id)key {
    
    if ([key isKindOfClass:[NSNull class]]) {
        
        return;
    }
    
    if ([object isKindOfClass:[NSNull class]]) {
        
        [self setValue:@""
                forKey:key];
        
    } else {
        [self setValue:object
                forKey:key];
    }
}

- (id)rh_safeObjectForKey:(id)key {
    
    if (key != nil) {
        
        return [self objectForKey:key];
        
    } else {
        
        return nil;
    }
}

- (id)rh_safeKeyForValue:(id)value {
    
    for (id key in self.allKeys) {
        
        if ([value isEqual:[self objectForKey:key]]) {
            
            return key;
        }
    }
    return nil;
}

@end
