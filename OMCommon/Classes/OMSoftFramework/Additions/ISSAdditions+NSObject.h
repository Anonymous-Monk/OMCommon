#import <Foundation/Foundation.h>

@interface NSObject (ISSCategory)

+ (BOOL)isEmpty:(id)obj;

/**
 * 获取单利
 */
+ (instancetype)sharedInstance;

/**
 * 注册通知
 */
- (void)registerNotifyName:(NSString *)aName selector:(SEL)aSelector;
- (void)registerNotifyName:(NSString *)aName selector:(SEL)aSelector object:(id)anObject;
- (id)registerNotifyName:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block;

/**
 * 注销通知
 */
- (void)unregisterNotify;
- (void)unregisterNotifyName:(NSString *)aName;
- (void)unregisterNotifyName:(NSString *)aName object:(id)anObject;

/**
 * 发送通知
 */
- (void)postNotificationName:(NSString *)aName;
- (void)postNotificationName:(NSString *)aName object:(id)anObject;
- (void)postNotificationName:(NSString *)aName userInfo:(NSDictionary *)aUserInfo;
- (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

- (NSString *)jsonString;

@end
