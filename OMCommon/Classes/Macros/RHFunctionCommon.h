//
//  RHFunctionCommon.h
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <sys/time.h>
#import <pthread.h>
#import "RHCommon.h"

/*
 *  通用方法
 */

RH_EXTERN_C_BEGIN

#pragma mark - dispatch 线程队列

/**
 Returns a dispatch_time delay from now.
 */
RH_EXTERN dispatch_time_t dispatch_time_delay(NSTimeInterval second);

/**
 Returns a dispatch_wall_time delay from now.
 */
RH_EXTERN dispatch_time_t dispatch_walltime_delay(NSTimeInterval second);

/**
 Returns a dispatch_wall_time from NSDate.
 */
RH_EXTERN dispatch_time_t dispatch_walltime_date(NSDate *date);

/**
 Whether in main queue/thread.
 */
RH_EXTERN bool dispatch_is_main_queue(void);

/**
 Submits a block for asynchronous execution on a main queue and returns immediately.
 */
RH_EXTERN void dispatch_async_on_main_queue(void (^block)(void));

/**
 Submits a block for execution on a main queue and waits until the block completes.
 */
RH_EXTERN void dispatch_sync_on_main_queue(void (^block)(void));

/**
 Initialize a pthread mutex.
 */
RH_EXTERN void pthread_mutex_init_recursive(pthread_mutex_t *mutex, bool recursive);

#pragma mark - 其他方法
/**
 Convert CFRange to NSRange
 @param range CFRange @return NSRange
 */
RH_EXTERN NSRange RHNSRangeFromCFRange(CFRange range);

/**
 Convert NSRange to CFRange
 @param range NSRange @return CFRange
 */
RH_EXTERN CFRange RHCFRangeFromNSRange(NSRange range);

/**
 Same as CFAutorelease(), compatible for iOS6
 @param arg CFObject @return same as input
 */
RH_EXTERN CFTypeRef RHCFAutorelease(CFTypeRef CF_RELEASES_ARGUMENT arg);

/**
 Profile time cost.
 @param block    code to benchmark
 @param complete code time cost (millisecond)
 
 Usage:
 RHBenchmark(^{
 // code
 }, ^(double ms) {
 NSLog("time cost: %.2f ms",ms);
 });
 
 */
RH_EXTERN void RHBenchmark(void (^block)(void), void (^complete)(double ms));

//获取编译时间
RH_EXTERN NSDate *_RHCompileTime(const char *data, const char *time);

#pragma mark - 随机数
/*!
 *  获取一个随机整数范围在：[0,i)包括0，不包括i
 *
 *  @param i 最大的数
 *
 *  @return 获取一个随机整数范围在：[0,i)包括0，不包括i
 */
/*!
 rand()和random()实际并不是一个真正的伪随机数发生器，在使用之前需要先初始化随机种子，否则每次生成的随机数一样。
 arc4random() 是一个真正的伪随机算法，不需要生成随机种子，因为第一次调用的时候就会自动生成。而且范围是rand()的两倍。在iPhone中，RAND_MAX是0x7fffffff (2147483647)，而arc4random()返回的最大值则是 0x100000000 (4294967296)。
 精确度比较：arc4random() > random() > rand()。
 */
RH_EXTERN NSInteger rhRandomNumber(NSInteger i);

#pragma mark - 判断空类型

#pragma mark 字符串是否为空
RH_EXTERN BOOL rhStringIsEmpty(NSString *string);

#pragma mark 判断字符串是否含有空格
RH_EXTERN BOOL rhStringIsBlank(NSString *string);

#pragma mark 数组是否为空
RH_EXTERN BOOL rhArrayIsEmpty(NSArray *array);

#pragma mark 字典是否为空
RH_EXTERN BOOL rhDictIsEmpty(NSDictionary *dic);

#pragma mark 字典是否为空
RH_EXTERN BOOL rhObjectIsEmpty(id _object);




#pragma mark - 从本地文件读取数据
RH_EXTERN NSData * rhGetDataWithContentsOfFile(NSString *fileName, NSString *type);

#pragma mark - json data

#pragma mark json 解析 data 数据
RH_EXTERN NSDictionary * rhGetDictionaryWithData(NSData *data);

#pragma mark json 解析 ，直接从本地文件读取 json 数据，返回 NSDictionary
RH_EXTERN NSDictionary * rhGetDictionaryWithContentsOfFile(NSString *fileName, NSString *type);

#pragma mark json 解析 ，json string 转 NSDictionary，返回 NSDictionary
RH_EXTERN NSDictionary * rhGetDictionaryWithJsonString(NSString *jsonString);

#pragma mark - Encode Decode 方法
// NSDictionary -> NSString
RH_EXTERN NSString* rhDecodeObjectFromDic(NSDictionary *dic, NSString *key);
// NSArray + index -> id
RH_EXTERN id        rhDecodeSafeObjectAtIndex(NSArray *arr, NSInteger index);
// NSDictionary -> NSString
RH_EXTERN NSString     * rhDecodeStringFromDic(NSDictionary *dic, NSString *key);
// NSDictionary -> NSString ？ NSString ： defaultStr
RH_EXTERN NSString* rhDecodeDefaultStrFromDic(NSDictionary *dic, NSString *key,NSString * defaultStr);
// NSDictionary -> NSNumber
RH_EXTERN NSNumber     * rhDecodeNumberFromDic(NSDictionary *dic, NSString *key);
// NSDictionary -> NSDictionary
RH_EXTERN NSDictionary * rhDecodeDicFromDic(NSDictionary *dic, NSString *key);
// NSDictionary -> NSArray
RH_EXTERN NSArray      * rhDecodeArrayFromDic(NSDictionary *dic, NSString *key);
RH_EXTERN NSArray      * rhDecodeArrayFromDicUsingParseBlock(NSDictionary *dic, NSString *key, id(^parseBlock)(NSDictionary *innerDic));

#pragma mark - Encode Decode 方法
// (nonull Key: nonull NSString) -> NSMutableDictionary
RH_EXTERN void rhEncodeUnEmptyStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key);
// nonull objec -> NSMutableArray
RH_EXTERN void rhEncodeUnEmptyObjctToArray(NSMutableArray *arr,id object);
// (nonull (Key ? rhey : defaultStr) : nonull Value) -> NSMutableDictionary
RH_EXTERN void rhEncodeDefaultStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key,NSString * defaultStr);
// (nonull Key: nonull object) -> NSMutableDictionary
RH_EXTERN void rhEncodeUnEmptyObjctToDic(NSMutableDictionary *dic,NSObject *object, NSString *key);

#pragma mark - 获取手机空间容量
RH_EXTERN long long rhTotalDiskSpaceInBytes(void);
RH_EXTERN long long rhFreeDiskSpaceInBytes(void);

RH_EXTERN_C_END
