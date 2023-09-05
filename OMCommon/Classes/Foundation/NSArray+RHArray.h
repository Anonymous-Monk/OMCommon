//
//  NSArray+RHArray.h
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (RHArray)

/**
 创建一个安全的Array
 
 @param object 对象, 可以为nil
 @return NSArray
 */
+ (instancetype)rh_initSafeArrayWithObject:(id)object;

/**
 从数组里获取一个id对象, 索引超出之后, 也不会崩掉
 
 @param index 对象索引
 @return id
 */
- (id)rh_safeObjectAtIndex:(NSUInteger)index;

/**
 根据Range返回对应的Array
 
 @param range range, 这里就算超出了索引也不会引起问题
 @return NSArray
 */
- (NSArray *)rh_safeArrayWithRange:(NSRange)range;

/**
 根据对象返回对应的索引
 
 @param object 对象
 @return NSUInteger
 */
- (NSUInteger)rh_safeIndexOfObject:(id)object;

/**
 根据给定的Plist文件名返回里面的数组
 
 @param name Plist文件名
 @return NSArray
 */
+ (NSArray *)rh_getArrayWithPlistName:(NSString *)name;



@end
