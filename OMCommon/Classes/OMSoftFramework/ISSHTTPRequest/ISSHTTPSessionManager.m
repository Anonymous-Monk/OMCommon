//
//  ISSHTTPSessionManager.m
//  oumaSoftFramework
//
//  Created by Paperman on 16/5/17.
//
//

#import "ISSHTTPSessionManager.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@interface ISSHTTPSessionManager()
@end

@implementation ISSHTTPSessionManager

+ (void)settingNetworkActivityIndicatorManager {
    static dispatch_once_t networkActivityIndicatorManagerOnceToken;
    dispatch_once(&networkActivityIndicatorManagerOnceToken, ^{
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    });
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    [[self class] settingNetworkActivityIndicatorManager];
    self = [super initWithBaseURL:url];
    if (self) {
        __weak typeof(self) weakSelf = self;
        [self setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
            if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
                NSString *domain = challenge.protectionSpace.host;
                if ([weakSelf.securityPolicy evaluateServerTrust:serverTrust forDomain:domain]) {
                    *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                    if (credential) {
                        return NSURLSessionAuthChallengeUseCredential;
                    } else {
                        return NSURLSessionAuthChallengePerformDefaultHandling;
                    }
                } else {
                    NSMutableArray *policies = [NSMutableArray array];
                    if (weakSelf.securityPolicy.validatesDomainName) {
                        [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)domain)];
                    } else {
                        [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];
                    }
                    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
                    
                    SecTrustResultType result;
                    SecTrustEvaluate(serverTrust, &result);
                    if (result == kSecTrustResultRecoverableTrustFailure) {
                        return NSURLSessionAuthChallengePerformDefaultHandling;
                    }
                    return NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                }
            } else {
                return NSURLSessionAuthChallengePerformDefaultHandling;
            }
        }];
        
        [self setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest *(NSURLSession *session, NSURLSessionTask *task, NSURLResponse *response, NSURLRequest *request) {
            if (![task.originalRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
                NSMutableURLRequest *redirectRequest = [task.originalRequest mutableCopy];
                redirectRequest.URL = request.URL;
                return redirectRequest;
            }
            return request;
        }];
    }
    return self;
}

- (NSURLSessionDataTask *)requestWithURL:(NSString *)URLString parameters:(id)parameters
                                   start:(void (^)(NSURLSessionDataTask *task))start
                                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSError *serializationError = nil;
    URLString = [URLString hasPrefix:@"http"]?URLString:[NSURL URLWithString:URLString relativeToURL:self.baseURL].absoluteString;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:URLString parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }

    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                success(dataTask, responseObject);
            }
        }
    }];
    
    if (start) {
        start(dataTask);
    }
    
    [dataTask resume];
    return dataTask;
}

- (NSURLSessionDataTask *)uploadWithURL:(NSString *)URLString parameters:(id)parameters
              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                  start:(void (^)(NSURLSessionDataTask *task))start
                                success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSError *serializationError = nil;
    URLString = [URLString hasPrefix:@"http"]?URLString:[NSURL URLWithString:URLString relativeToURL:self.baseURL].absoluteString;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }

    __block NSURLSessionDataTask *dataTask;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        NSString *tmpFilename = [NSString stringWithFormat:@"%f", [NSDate timeIntervalSinceReferenceDate]];
        NSURL *tmpFileUrl = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:tmpFilename]];
        
        NSInputStream *inputStream = request.HTTPBodyStream;
        NSOutputStream *outputStream = [[NSOutputStream alloc] initWithURL:tmpFileUrl append:NO];
        [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [inputStream open];
        [outputStream open];
        
        while ([inputStream hasBytesAvailable] && [outputStream hasSpaceAvailable]) {
            uint8_t buffer[1024];
            
            NSInteger bytesRead = [inputStream read:buffer maxLength:1024];
            if (inputStream.streamError || bytesRead < 0) {
                serializationError = inputStream.streamError;
                break;
            }
            
            NSInteger bytesWritten = [outputStream write:buffer maxLength:(NSUInteger)bytesRead];
            if (outputStream.streamError || bytesWritten < 0) {
                serializationError = outputStream.streamError;
                break;
            }
            
            if (bytesRead == 0 && bytesWritten == 0) {
                break;
            }
        }
        
        [outputStream close];
        [inputStream close];
        
        dataTask = [self uploadTaskWithRequest:request fromFile:tmpFileUrl progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            [[NSFileManager defaultManager] removeItemAtURL:tmpFileUrl error:nil];
            if (error) {
                if (failure) {
                    failure(dataTask, error);
                }
            } else {
                if (success) {
                    success(dataTask, responseObject);
                }
            }
        }];
    } else {
        dataTask = [self uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                if (failure) {
                    failure(dataTask, error);
                }
            } else {
                if (success) {
                    success(dataTask, responseObject);
                }
            }
        }];
    }
    
    if (start) {
        start(dataTask);
    }
    
    [dataTask resume];
    
    return dataTask;
}
@end
