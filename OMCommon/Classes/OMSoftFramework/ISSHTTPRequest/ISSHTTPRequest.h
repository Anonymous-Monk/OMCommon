//
//  ISSHTTPRequest.h
//  oumaSoftFramework
//
//  Created by Paperman on 16/3/29.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ISSHTTPRequest;

#if NS_BLOCKS_AVAILABLE
typedef void (^ISSRequestSuccessBlock)(ISSHTTPRequest *request, NSDictionary *result);
typedef void (^ISSRequestFailureBlock)(ISSHTTPRequest *request, NSError *error);
#endif

@interface ISSHTTPRequest : NSObject

@property (copy, nonatomic, readonly) NSString *tag;
@property (copy, nonatomic, readonly) NSDictionary *wrapperParameters;
@property (weak, nonatomic, readonly) NSURLSessionTask *task;

/**
 * HTTP 请求（POST）
 * @param URLString 接口名
 * @param parameters 请求参数
 * @param view loading指示器父视图
 * @param success 成功回调
 * @param failure 失败回调
 *
 */
+ (void)requestWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters indicatorView:(UIView *)view
               success:(ISSRequestSuccessBlock)success failure:(ISSRequestFailureBlock)failure;

+ (void)requestTextWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters indicatorView:(UIView *)view
                   success:(ISSRequestSuccessBlock)success failure:(ISSRequestFailureBlock)failure;

/**
 * HTTP 请求（POST）
 * @param URLString 接口名
 * @param parameters 请求参数
 * @param success 成功回调
 * @param failure 失败回调
 *
 */
+ (void)requestWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
               success:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure;

@end
