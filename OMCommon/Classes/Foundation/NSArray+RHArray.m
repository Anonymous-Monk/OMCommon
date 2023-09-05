//
//  NSArray+RHArray.m
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import "NSArray+RHArray.h"

@implementation NSArray (RHArray)

+ (instancetype)rh_initSafeArrayWithObject:(id)object {
    
    if (object == nil) {
        
        return [self array];
        
    } else {
        
        return [self arrayWithObject:object];
    }
}

- (id)rh_safeObjectAtIndex:(NSUInteger)index {
    
    if (index >= self.count) {
        
        return nil;
    } else {
        
        return [self objectAtIndex:index];
    }
}

- (NSArray *)rh_safeArrayWithRange:(NSRange)range {
    
    NSUInteger location = range.location;
    NSUInteger length   = range.length;
    
    if (location + length > self.count) {
        
        //超过了边界,就获取从loction开始所有的item
        if ((location + length) > self.count) {
            
            length = (self.count - location);
            
            return [self rh_safeArrayWithRange:NSMakeRange(location, length)];
        }
        
        return nil;
        
    } else {
        
        return [self subarrayWithRange:range];
    }
}

- (NSUInteger)rh_safeIndexOfObject:(id)object {
    
    if (object == nil) {
        
        return NSNotFound;
    } else {
        
        return [self indexOfObject:object];
    }
}

+ (NSArray *)rh_getArrayWithPlistName:(NSString *)name {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:name
                                                     ofType:@"plist"];
    
    return [NSArray arrayWithContentsOfFile:path];
}




@end
