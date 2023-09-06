//
//  ISSHTTPSessionManager.h
//  oumaSoftFramework
//
//  Created by Paperman on 16/5/17.
//
//

#import <AFNetworking/AFNetworking.h>


@interface ISSHTTPSessionManager : AFHTTPSessionManager

- (NSURLSessionDataTask *)requestWithURL:(NSString *)URLString parameters:(id)parameters
                         start:(void (^)(NSURLSessionDataTask *task))start
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (NSURLSessionDataTask *)uploadWithURL:(NSString *)URLString parameters:(id)parameters
              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                  start:(void (^)(NSURLSessionDataTask *task))start
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
