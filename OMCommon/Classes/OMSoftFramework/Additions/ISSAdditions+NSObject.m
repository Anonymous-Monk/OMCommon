#import "ISSAdditions+NSObject.h"

static inline NSMutableArray *sharedCacheInstances() {
    static NSMutableArray *instances;
    static dispatch_once_t instancesToken;
    dispatch_once(&instancesToken, ^{
        instances = [NSMutableArray array];
    });
    return instances;
}

@implementation NSObject (ISSCategory)

+ (BOOL)isEmpty:(id)obj
{
    if (obj == nil || obj == NULL) {
        return YES;
    }
    if ([obj isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *s = (NSString *)obj;
        if ([s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
            return YES;
        }
        return NO;
    }
    return YES;
}

+ (instancetype)sharedInstance {
    @synchronized(self) {
        for (id subInstance in sharedCacheInstances()) {
            if ([subInstance isMemberOfClass:[self class]]) {
                return subInstance;
            }
        }
        id instance = [[self alloc] init];
        [sharedCacheInstances() addObject:instance];
        return instance;
    }
}

- (void)registerNotifyName:(NSString *)aName selector:(SEL)aSelector {
    [self registerNotifyName:aName selector:aSelector object:nil];
}

- (void)registerNotifyName:(NSString *)aName selector:(SEL)aSelector object:(id)anObject {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:aSelector name:aName object:anObject];
}

- (id)registerNotifyName:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block {
    return [[NSNotificationCenter defaultCenter] addObserverForName:name object:obj queue:queue usingBlock:block];
}

- (void)unregisterNotify {
    [self unregisterNotifyName:nil object:nil];
}

- (void)unregisterNotifyName:(NSString *)aName {
    [self unregisterNotifyName:aName object:nil];
}

- (void)unregisterNotifyName:(NSString *)aName object:(id)anObject {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:aName object:anObject];
}

- (void)postNotificationName:(NSString *)aName {
    [self postNotificationName:aName object:nil];
}

- (void)postNotificationName:(NSString *)aName object:(id)anObject {
    [self postNotificationName:aName object:anObject userInfo:nil];
}

- (void)postNotificationName:(NSString *)aName userInfo:(NSDictionary *)aUserInfo {
    [self postNotificationName:aName object:nil userInfo:aUserInfo];
}

- (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject userInfo:aUserInfo];
}

- (NSString *)jsonString
{
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];

    if (error != nil) {
        NSLog(@"NSDictionary JSONString error: %@", [error localizedDescription]);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end
