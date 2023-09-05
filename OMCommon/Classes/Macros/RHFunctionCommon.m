//
//  RHFunctionCommon.m
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import "RHFunctionCommon.h"

#pragma mark - dispatch 线程队列

/**
 Returns a dispatch_time delay from now.
 */
RH_EXTERN dispatch_time_t dispatch_time_delay(NSTimeInterval second) {
    return dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}

/**
 Returns a dispatch_wall_time delay from now.
 */
RH_EXTERN dispatch_time_t dispatch_walltime_delay(NSTimeInterval second) {
    return dispatch_walltime(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
}

/**
 Returns a dispatch_wall_time from NSDate.
 */
RH_EXTERN dispatch_time_t dispatch_walltime_date(NSDate *date) {
    NSTimeInterval interval;
    double second, subsecond;
    struct timespec time;
    dispatch_time_t milestone;
    
    interval = [date timeIntervalSince1970];
    subsecond = modf(interval, &second);
    time.tv_sec = second;
    time.tv_nsec = subsecond * NSEC_PER_SEC;
    milestone = dispatch_walltime(&time, 0);
    return milestone;
}

/**
 Whether in main queue/thread.
 */
RH_EXTERN bool dispatch_is_main_queue() {
    return pthread_main_np() != 0;
}

/**
 Submits a block for asynchronous execution on a main queue and returns immediately.
 */
RH_EXTERN void dispatch_async_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/**
 Submits a block for execution on a main queue and waits until the block completes.
 */
RH_EXTERN void dispatch_sync_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

/**
 Initialize a pthread mutex.
 */
RH_EXTERN void pthread_mutex_init_recursive(pthread_mutex_t *mutex, bool recursive) {
#define RHMUTEX_ASSERT_ON_ERROR(x_) do { \
__unused volatile int res = (x_); \
assert(res == 0); \
} while (0)
    assert(mutex != NULL);
    if (!recursive) {
        RHMUTEX_ASSERT_ON_ERROR(pthread_mutex_init(mutex, NULL));
    } else {
        pthread_mutexattr_t attr;
        RHMUTEX_ASSERT_ON_ERROR(pthread_mutexattr_init (&attr));
        RHMUTEX_ASSERT_ON_ERROR(pthread_mutexattr_settype (&attr, PTHREAD_MUTEX_RECURSIVE));
        RHMUTEX_ASSERT_ON_ERROR(pthread_mutex_init (mutex, &attr));
        RHMUTEX_ASSERT_ON_ERROR(pthread_mutexattr_destroy (&attr));
    }
#undef RHMUTEX_ASSERT_ON_ERROR
}

#pragma mark - 其他方法
/**
 Convert CFRange to NSRange
 @param range CFRange @return NSRange
 */
RH_EXTERN NSRange RHNSRangeFromCFRange(CFRange range) {
    return NSMakeRange(range.location, range.length);
}

/**
 Convert NSRange to CFRange
 @param range NSRange @return CFRange
 */
RH_EXTERN CFRange RHCFRangeFromNSRange(NSRange range) {
    return CFRangeMake(range.location, range.length);
}

/**
 Same as CFAutorelease(), compatible for iOS6
 @param arg CFObject @return same as input
 */
RH_EXTERN CFTypeRef RHCFAutorelease(CFTypeRef CF_RELEASES_ARGUMENT arg) {
    if (((long)CFAutorelease + 1) != 1) {
        return CFAutorelease(arg);
    } else {
        id __autoreleasing obj = CFBridgingRelease(arg);
        return (__bridge CFTypeRef)obj;
    }
}

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
RH_EXTERN void RHBenchmark(void (^block)(void), void (^complete)(double ms)) {
    // <QuartzCore/QuartzCore.h> version
    /*
     extern double CACurrentMediaTime (void);
     double begin, end, ms;
     begin = CACurrentMediaTime();
     block();
     end = CACurrentMediaTime();
     ms = (end - begin) * 1000.0;
     complete(ms);
     */
    
    // <sys/time.h> version
    struct timeval t0, t1;
    gettimeofday(&t0, NULL);
    block();
    gettimeofday(&t1, NULL);
    double ms = (double)(t1.tv_sec - t0.tv_sec) * 1e3 + (double)(t1.tv_usec - t0.tv_usec) * 1e-3;
    complete(ms);
}

RH_EXTERN NSDate *_RHCompileTime(const char *data, const char *time) {
    NSString *timeStr = [NSString stringWithFormat:@"%s %s",data,time];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd yyyy HH:mm:ss"];
    [formatter setLocale:locale];
    return [formatter dateFromString:timeStr];
}


#pragma mark - 随机数
RH_EXTERN NSInteger rhRandomNumber(NSInteger i) {
    return arc4random() % i;
}

#pragma mark 字符串是否为空
RH_EXTERN BOOL rhStringIsEmpty(NSString *string) {
    return ([string isKindOfClass:[NSNull class]] || string == nil || [string length] < 1);
}

#pragma mark - 判断字符串是否含有空格
RH_EXTERN BOOL rhStringIsBlank(NSString *string) {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < string.length; ++i) {
        unichar c = [string characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark 数组是否为空
RH_EXTERN BOOL rhArrayIsEmpty(NSArray *array) {
    return (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0);
}

#pragma mark 字典是否为空
RH_EXTERN BOOL rhDictIsEmpty(NSDictionary *dic) {
    return (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0);
}

#pragma mark 字典是否为空
RH_EXTERN BOOL rhObjectIsEmpty(id object) {
    return (object == nil
            || [object isKindOfClass:[NSNull class]]
            || ([object respondsToSelector:@selector(length)] && [(NSData *)object length] == 0)
            || ([object respondsToSelector:@selector(count)] && [(NSArray *)object count] == 0));
}



#pragma mark - 从本地文件读取数据
RH_EXTERN NSData* rhGetDataWithContentsOfFile(NSString *fileName, NSString *type){
    return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:type]];
}

#pragma mark - json 解析 data 数据
RH_EXTERN NSDictionary* rhGetDictionaryWithData(NSData *data) {
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

#pragma mark json 解析 ，直接从本地文件读取 json 数据，返回 NSDictionary

RH_EXTERN NSDictionary * rhGetDictionaryWithContentsOfFile(NSString *fileName, NSString *type){
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:type]];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

#pragma mark json 解析 ，json string 转 NSDictionary，返回 NSDictionary
RH_EXTERN NSDictionary * rhGetDictionaryWithJsonString(NSString *jsonString){
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err)
    {
        NSLog(@"json 解析失败：%@",dict);
        return nil;
    }
    return dict;
}












#pragma mark - Decode
RH_EXTERN NSString* rhDecodeObjectFromDic(NSDictionary *dic, NSString *key)
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id temp = [dic objectForKey:key];
    NSString *value = @"";
    if (rhObjectIsEmpty(temp))   {
        if ([temp isKindOfClass:[NSString class]]) {
            value = temp;
        }else if([temp isKindOfClass:[NSNumber class]]){
            value = [temp stringValue];
        }
        return value;
    }
    return nil;
}

RH_EXTERN NSString* rhDecodeDefaultStrFromDic(NSDictionary *dic, NSString *key,NSString * defaultStr)
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id temp = [dic objectForKey:key];
    NSString *value = defaultStr;
    if (rhObjectIsEmpty(temp))   {
        if ([temp isKindOfClass:[NSString class]]) {
            value = temp;
        }else if([temp isKindOfClass:[NSNumber class]]){
            value = [temp stringValue];
        }
        
        return value;
    }
    return value;
}

RH_EXTERN id rhDecodeSafeObjectAtIndex(NSArray *arr, NSInteger index)
{
    if (rhArrayIsEmpty(arr)) {
        return nil;
    }
    
    if ([arr count]-1<index) {
        RHAssert([arr count]-1<index);
        return nil;
    }
    
    return [arr objectAtIndex:index];
}



RH_EXTERN NSString* rhDecodeStringFromDic(NSDictionary *dic, NSString *key)
{
    if (rhDictIsEmpty(dic))
    {
        return nil;
    }
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSString class]])
    {
        if ([temp isEqualToString:@"(null)"]) {
            return @"";
        }
        return temp;
    }
    else if ([temp isKindOfClass:[NSNumber class]])
    {
        return [temp stringValue];
    }
    return nil;
}

RH_EXTERN NSNumber* rhDecodeNumberFromDic(NSDictionary *dic, NSString *key)
{
    if (rhDictIsEmpty(dic))
    {
        return nil;
    }
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSString class]])
    {
        return [NSNumber numberWithDouble:[temp doubleValue]];
    }
    else if ([temp isKindOfClass:[NSNumber class]])
    {
        return temp;
    }
    return nil;
}

RH_EXTERN NSDictionary * rhDecodeDicFromDic(NSDictionary *dic, NSString *key)
{
    if (rhDictIsEmpty(dic))
    {
        return nil;
    }
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSDictionary class]])
    {
        return temp;
    }
    return nil;
}

RH_EXTERN NSArray      * rhDecodeArrayFromDic(NSDictionary *dic, NSString *key)
{
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSArray class]])
    {
        return temp;
    }
    return nil;
}

RH_EXTERN NSArray      * rhDecodeArrayFromDicUsingParseBlock(NSDictionary *dic, NSString *key, id(^parseBlock)(NSDictionary *innerDic))
{
    NSArray *tempList = rhDecodeArrayFromDic(dic, key);
    if ([tempList count])
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[tempList count]];
        for (NSDictionary *item in tempList)
        {
            id dto = parseBlock(item);
            if (dto) {
                [array addObject:dto];
            }
        }
        return array;
    }
    return nil;
}


#pragma mark - Encode

RH_EXTERN void rhEncodeUnEmptyStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key)
{
    if (rhDictIsEmpty(dic))
    {
        return;
    }
    
    if (rhStringIsEmpty(object))
    {
        return;
    }
    
    if (rhStringIsEmpty(key))
    {
        return;
    }
    
    [dic setObject:object forKey:key];
}

RH_EXTERN void rhEncodeUnEmptyObjctToArray(NSMutableArray *arr,id object)
{
    if (rhArrayIsEmpty(arr))
    {
        return;
    }
    
    if (rhObjectIsEmpty(object))
    {
        return;
    }
    
    [arr addObject:object];
}

RH_EXTERN void rhEncodeDefaultStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key,NSString * defaultStr)
{
    if (rhDictIsEmpty(dic))
    {
        return;
    }
    
    if (rhStringIsEmpty(object))
    {
        object = defaultStr;
    }
    
    if (rhStringIsEmpty(key))
    {
        return;
    }
    
    [dic setObject:object forKey:key];
}

RH_EXTERN void rhEncodeUnEmptyObjctToDic(NSMutableDictionary *dic,NSObject *object, NSString *key)
{
    if (rhDictIsEmpty(dic))
    {
        return;
    }
    if (rhObjectIsEmpty(object))
    {
        return;
    }
    if (rhStringIsEmpty(key))
    {
        return;
    }
    
    [dic setObject:object forKey:key];
}

RH_EXTERN long long rhTotalDiskSpaceInBytes(void) {
    if (@available(iOS 11.0, *)) {
        NSURL* url = [[NSURL alloc]initFileURLWithPath:[NSString stringWithFormat:@"%@",NSHomeDirectory()]];
        NSError* error =nil;
        NSDictionary * dict = [url resourceValuesForKeys:@[NSURLVolumeTotalCapacityKey]error:&error];
        if (error) {
            return 0;
        }
        long long space = [dict[NSURLVolumeTotalCapacityKey] longLongValue];
        return space;
    } else {
        NSError * error =nil;
        NSDictionary * systemAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
        if (error) {
            return 0;
        }
        long long space = [systemAttributes[NSFileSystemSize] longLongValue];
        return space;
    }
}

RH_EXTERN long long rhFreeDiskSpaceInBytes(void) {
    if (@available(iOS 11.0, *)) {
        NSURL* url = [[NSURL alloc]initFileURLWithPath:[NSString stringWithFormat:@"%@",NSHomeDirectory()]];
        NSError* error =nil;
        NSDictionary * dict = [url resourceValuesForKeys:@[NSURLVolumeAvailableCapacityForImportantUsageKey]error:&error];
        if (error) {
            return 0;
        }
        long long space = [dict[NSURLVolumeAvailableCapacityForImportantUsageKey] longLongValue];
        return space;
    } else {
        NSError * error =nil;
        NSDictionary * systemAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
        if (error) {
            return 0;
        }
        long long space = [systemAttributes[NSFileSystemFreeSize] longLongValue];
        return space;
    }
}
