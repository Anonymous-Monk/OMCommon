//
//  RHCommon.h
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 *  通用宏
 */

#pragma mark - C语言

#ifdef __cplusplus
#define RH_EXTERN_C_BEGIN  extern "C" {
#define RH_EXTERN_C_END  }
#else
#define RH_EXTERN_C_BEGIN
#define RH_EXTERN_C_END
#endif

RH_EXTERN_C_BEGIN

#ifndef RH_CLAMP // return the clamped value
#define RH_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))
#endif

#ifndef RH_SWAP // swap two value
#define RH_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif


#pragma mark - 日志打印
// 日志打印 RHLog
#ifdef DEBUG
#       define RHLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#       define RHLog(...)
#endif

#pragma mark - Extern and Inline  functions 内联函数  外联函数
/*／EXTERN 外联函数*/
#if !defined(RH_EXTERN)
#  if defined(__cplusplus)
#   define RH_EXTERN extern "C"
#  else
#   define RH_EXTERN extern
#  endif
#endif

/*INLINE 内联函数*/
#if !defined(RH_INLINE)
# if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#  define RH_INLINE static inline
# elif defined(__cplusplus)
#  define RH_INLINE static inline
# elif defined(__GNUC__)
#  define RH_INLINE static __inline__
# else
#  define RH_INLINE static
# endif
#endif

#pragma mark - Assert functions Assert 断言
//iAssert 断言
#define RHAssert(expression, ...) \
do { if(!(expression)) { \
RHLog(@"%@", \
[NSString stringWithFormat: @"Assertion failure: %s in %s on line %s:%d. %@",\
#expression, \
__PRETTY_FUNCTION__, \
__FILE__, __LINE__,  \
[NSString stringWithFormat:@"" __VA_ARGS__]]); \
abort(); } \
} while(0)

#define RHAssertNil(condition, description, ...) NSAssert(!(condition), (description), ##__VA_ARGS__)
#define RHCAssertNil(condition, description, ...) NSCAssert(!(condition), (description), ##__VA_ARGS__)

#define RHAssertNotNil(condition, description, ...) NSAssert((condition), (description), ##__VA_ARGS__)
#define RHCAssertNotNil(condition, description, ...) NSCAssert((condition), (description), ##__VA_ARGS__)

#define RHAssertMainThread() NSAssert([NSThread isMainThread], @"This method must be called on the main thread")
#define RHCAssertMainThread() NSCAssert([NSThread isMainThread], @"This method must be called on the main thread")


#pragma mark - 方法禁用提示
#undef RHDeprecated
#define RHDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

#pragma mark - weak / strong

#define RHWeakSelf        @RHWeakify(self);
#define RHStrongSelf      @RHStrongify(self);

/*！
 * 强弱引用转换，用于解决代码块（block）与强引用self之间的循环引用问题
 * 调用方式: `@RHKit_Weakify`实现弱引用转换，`@RHKit_Strongify`实现强引用转换
 *
 * 示例：
 * @kWeakify
 * [obj block:^{
 * @kStrongify
 * self.property = something;
 * }];
 */
#ifndef RHWeakify
#if DEBUG
#if __has_feature(objc_arc)
#define RHWeakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define RHWeakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define RHWeakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define RHWeakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

/*！
 * 强弱引用转换，用于解决代码块（block）与强引用对象之间的循环引用问题
 * 调用方式: `@RHKit_Weakify(object)`实现弱引用转换，`@RHKit_Strongify(object)`实现强引用转换
 *
 * 示例：
 * @kWeakify(object)
 * [obj block:^{
 * @kStrongify(object)
 * strong_object = something;
 * }];
 */
#ifndef RHStrongify
#if DEBUG
#if __has_feature(objc_arc)
#define RHStrongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define RHStrongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define RHStrongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define RHStrongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#define RH_PROPERTY_STRING(name) @property(nonatomic,copy)NSString *name
#define RH_PROPERTY_ASSIGN(name) @property(nonatomic,assign)NSInteger name
#define RH_PROPERTY_STRONG(type,name) @property(nonatomic,strong)type *name


#pragma mark - 懒加载
#define RHLazy(object, assignment) (object = object ?: assignment)

/**
 Synthsize a dynamic object property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @param association  ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, retain) UIColor *myColor;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 RHSYNTH_DYNAMIC_PROPERTY_OBJECT(myColor, setMyColor, RETAIN, UIColor *)
 @end
 */
#ifndef RHSYNTH_DYNAMIC_PROPERTY_OBJECT
#define RHSYNTH_DYNAMIC_PROPERTY_OBJECT(_getter_, _setter_, _association_, _type_) \
- (void)_setter_ : (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## _association_); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif


RH_EXTERN_C_END
