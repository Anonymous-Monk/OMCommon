//
//  ISSHTTPRequest.m
//  oumaSoftFramework
//
//  Created by Paperman on 16/3/29.
//
//

#import "ISSHTTPRequest.h"
#import "ISSHTTPSessionManager.h"
#import "ISSAdditions+NSObject.h"
#import "MBProgressHUD.h"

@interface ISSHTTPResponseSerializer : AFJSONResponseSerializer
@end
@implementation ISSHTTPResponseSerializer
- (instancetype)init {
    self = [super init];
    if (self) {
        self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/xml", @"text/plain", @"application/javascript", @"application/x-www-form-urlencoded", @"image/*", nil];
    }
    return self;
}
@end

@interface ISSHTTPRequest() {
    NSMutableArray *_paramArray;
    MBProgressHUD *_indicatorView;
}
@property (strong, nonatomic) NSString *decryptKey;
@end

@implementation ISSHTTPRequest

+ (instancetype)httpRequestWrapperParams:(NSDictionary *)parameters
{
    ISSHTTPRequest *request = [[ISSHTTPRequest alloc] init];
    if (request) {
        request->_wrapperParameters = [parameters copy];
    }
    return request;
}

+ (ISSHTTPSessionManager *)iss_RequestSessionManager {
    static ISSHTTPSessionManager *requestManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestManager = [[ISSHTTPSessionManager alloc] initWithBaseURL:nil];
        requestManager.responseSerializer = [ISSHTTPResponseSerializer serializer];
        requestManager.requestSerializer.timeoutInterval = 15.f;
        requestManager.securityPolicy.allowInvalidCertificates = NO;
    });
    return requestManager;
}

+ (ISSHTTPSessionManager *)iss_RequestSessionManager1 {
    static ISSHTTPSessionManager *requestManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        requestManager = [[ISSHTTPSessionManager alloc] initWithBaseURL:nil];
        requestManager.responseSerializer = serializer;
        requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", @"text/xml", @"text/plain", @"application/javascript", @"application/x-www-form-urlencoded", @"image/*", nil];
        requestManager.requestSerializer.timeoutInterval = 15.f;
        requestManager.securityPolicy.allowInvalidCertificates = NO;
    });
    return requestManager;
}

+ (void)requestWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters indicatorView:(UIView *)view
               success:(ISSRequestSuccessBlock)success failure:(ISSRequestFailureBlock)failure;
{
    NSLog(@"request parameters:%@", [parameters jsonString]);
    ISSHTTPRequest *request = [ISSHTTPRequest httpRequestWrapperParams:parameters];
    ISSHTTPSessionManager *manager = [[self class] iss_RequestSessionManager];
    [manager requestWithURL:URLString parameters:request.wrapperParameters
                      start:^(NSURLSessionDataTask *task) {
                          request->_task = task;
                          [request showIndicatorInView:view];
                          NSLog(@"request URL:%@", task.originalRequest.URL.absoluteString);
                      } success:^(NSURLSessionDataTask *task, id responseObject) {
                          [request hideIndicator];
                          if (responseObject) {
                              NSLog(@"response success:%@", [responseObject jsonString]);
                              if (success) {
                                  success(request, responseObject);
                              }
                          } else {
                              NSError *error = [NSError errorWithDomain:@"服务端返回参数错误" code:0 userInfo:nil];
                              NSLog(@"response error:%@", error);
                              if (failure) {
                                  failure(request, error);
                              }
                          }
                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                          NSLog(@"response error:%@", error);
                          error = [[self class] handleResponseWithError:error];
                          [request hideIndicator];
                          if (failure) {
                              failure(request, error);
                          }
                      }];
}

+ (void)requestTextWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters indicatorView:(UIView *)view
               success:(ISSRequestSuccessBlock)success failure:(ISSRequestFailureBlock)failure
{
    NSLog(@"request parameters:%@", [parameters jsonString]);
    ISSHTTPRequest *request = [ISSHTTPRequest httpRequestWrapperParams:parameters];
    ISSHTTPSessionManager *manager = [[self class] iss_RequestSessionManager1];
    [manager requestWithURL:URLString parameters:request.wrapperParameters
                      start:^(NSURLSessionDataTask *task) {
                          request->_task = task;
                          [request showIndicatorInView:view];
                          NSLog(@"request URL:%@", task.originalRequest.URL.absoluteString);
                      } success:^(NSURLSessionDataTask *task, id responseObject) {
                          [request hideIndicator];
                          if (responseObject) {
                              NSLog(@"response success:%@", [responseObject jsonString]);
                              if (success) {
                                  success(request, responseObject);
                              }
                          } else {
                              NSError *error = [NSError errorWithDomain:@"服务端返回参数错误" code:0 userInfo:nil];
                              NSLog(@"response error:%@", error);
                              if (failure) {
                                  failure(request, error);
                              }
                          }
                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                          NSLog(@"response error:%@", error);
                          error = [[self class] handleResponseWithError:error];
                          [request hideIndicator];
                          if (failure) {
                              failure(request, error);
                          }
                      }];
}

+ (void)requestWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
               success:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure{
    
    ISSHTTPSessionManager *manager = [ISSHTTPSessionManager sharedInstance];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters headers:nil progress:uploadProgress success:success failure:failure];
}
+ (NSError *)handleResponseWithError:(NSError *)error  {
    if (error == nil) return nil;
    NSString *errorMssage = nil;
    switch (error.code) {
        case NSURLErrorTimedOut:
            errorMssage = @"网络超时，请稍后再试";
            break;
        case NSURLErrorNetworkConnectionLost:
            errorMssage = @"网络连接不稳定";
            break;
        case NSURLErrorNotConnectedToInternet:
            errorMssage = @"网络连接已断开";
            break;
        default:
            errorMssage = @"服务器故障或网络链接失败";
            break;
    }
    return [NSError errorWithDomain:errorMssage code:error.code userInfo:error.userInfo];
}

- (void)showIndicatorInView:(UIView *)view {
    if (view && _indicatorView == nil) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        _indicatorView = [[MBProgressHUD alloc] initWithFrame:screenBounds];
        _indicatorView.removeFromSuperViewOnHide = YES;
        [view addSubview:_indicatorView];
        [_indicatorView show:NO];
    }
}

- (void)hideIndicator {
    if (_indicatorView != nil) {
        [_indicatorView hide:NO];
        _indicatorView = nil;
    }
}
@end
