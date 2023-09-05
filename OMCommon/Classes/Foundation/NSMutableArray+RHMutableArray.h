//
//  NSMutableArray+RHMutableArray.h
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (RHMutableArray)

/**
 安全的添加一个对象
 
 @param object 对象
 */
- (void)rh_addSafeObject:(id)object;

/**
 根据索引安全的插入一个对象
 
 @param object 对象
 @param index NSUInteger
 */
- (void)rh_insertSafeObject:(id)object
                      index:(NSUInteger)index;

/**
 根据索引安全的插入一个数组
 
 @param array NSArray
 @param indexSet NSIndexSet
 */
- (void)rh_insertSafeArray:(NSArray *)array
                  indexSet:(NSIndexSet *)indexSet;

/**
 根据索引安全的删除一个对象
 
 @param index NSUInteger
 */
- (void)rh_safeRemoveObjectAtIndex:(NSUInteger)index;

/**
 根据范围安全的删除
 
 @param range NSRange
 */
- (void)rh_safeRemoveObjectsInRange:(NSRange)range;

@end
