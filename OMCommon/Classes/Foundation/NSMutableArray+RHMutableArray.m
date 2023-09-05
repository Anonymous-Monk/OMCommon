//
//  NSMutableArray+RHMutableArray.m
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import "NSMutableArray+RHMutableArray.h"

@implementation NSMutableArray (RHMutableArray)

- (void)rh_addSafeObject:(id)object {
    
    if (object == nil) {
        
        return;
    } else {
        
        [self addObject:object];
    }
}

- (void)rh_insertSafeObject:(id)object
                      index:(NSUInteger)index {
    
    if (object == nil) {
        
        return;
        
    } else if (index > self.count) {
        
        [self insertObject:object
                   atIndex:self.count];
        
    } else {
        
        [self insertObject:object
                   atIndex:index];
    }
}

- (void)rh_insertSafeArray:(NSArray *)array
                  indexSet:(NSIndexSet *)indexSet {
    
    if (indexSet == nil) {
        
        return;
    } else if (indexSet.count != array.count || indexSet.firstIndex > array.count) {
        
        [self insertObject:array
                   atIndex:self.count];
        
    } else {
        
        [self insertObjects:array
                  atIndexes:indexSet];
    }
}

- (void)rh_safeRemoveObjectAtIndex:(NSUInteger)index {
    
    if (index >= self.count) {
        
        return;
    } else {
        
        [self removeObjectAtIndex:index];
    }
}

- (void)rh_safeRemoveObjectsInRange:(NSRange)range {
    
    NSUInteger location = range.location;
    NSUInteger length   = range.length;
    
    if (location + length > self.count) {
        
        return;
    } else {
        
        [self removeObjectsInRange:range];
    }
}


@end
