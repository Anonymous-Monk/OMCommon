//
//  RHSystemCommon.m
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import "RHSystemCommon.h"

#pragma mark App版本号
RH_EXTERN void rhAppVersion() {
    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

#pragma mark 系统版本
RH_EXTERN float rhFSystemVersion() {
    return ([[[UIDevice currentDevice] systemVersion] floatValue]);
}

RH_EXTERN double rhDSystemVersion(void) {
    return ([[[UIDevice currentDevice] systemVersion] doubleValue]);
}

RH_EXTERN NSString* rhSSystemVersion(void) {
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark 当前系统是否大于某个版本
RH_EXTERN BOOL isIOS6(void) {
    return ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0);
}
RH_EXTERN BOOL isIOS7(void) {
    return ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0);
}
RH_EXTERN BOOL isIOS8(void) {
    return ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0);
}
RH_EXTERN BOOL isIOS9(void) {
    return ([[[UIDevice currentDevice]systemVersion]floatValue] >= 9.0);
}
RH_EXTERN BOOL isIOS10(void) {
    return ([[[UIDevice currentDevice]systemVersion]floatValue] >= 10.0);
}
RH_EXTERN BOOL isIOS11(void) {
    return ([[[UIDevice currentDevice]systemVersion]floatValue] >= 11.0);
}

RH_EXTERN BOOL isIPhoneX(void) {
    // 判断是否是iPhone X
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO);
}

RH_EXTERN BOOL isiPhoneXMax(void) {
    // 判断是否是iPhone Xs Max
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO);
}

RH_EXTERN BOOL isIPad(void) {
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}


#pragma mark AppDelegate对象
RH_EXTERN id rhAppDelegateInstance(void) {
    return [[UIApplication sharedApplication] delegate];
}

#pragma mark - Application
RH_EXTERN UIApplication * rhApplication(void) {
    return [UIApplication sharedApplication];
}

#pragma mark - KeyWindow
RH_EXTERN UIWindow * rhKeyWindow(void) {
    if([[[UIApplication sharedApplication] delegate] window]){
        return [[[UIApplication sharedApplication] delegate] window];
    }else {
        if (@available(iOS 13.0,*)) {
            NSArray *arr = [[[UIApplication sharedApplication] connectedScenes] allObjects];
            UIWindowScene *windowScene =  (UIWindowScene *)arr[0];
            UIWindow *mainWindow = [windowScene valueForKeyPath:@"delegate.window"];
            if(mainWindow){
                return mainWindow;
            }else{
                return [UIApplication sharedApplication].windows.lastObject;
            }
        }else {
            return [UIApplication sharedApplication].keyWindow;
        }
    }
}

#pragma mark - NotiCenter
RH_EXTERN NSNotificationCenter * rhNotificationCenter(void) {
    return [NSNotificationCenter defaultCenter];
}

#pragma mark - NSUserDefault
RH_EXTERN NSUserDefaults * rhNSUserDefaults(void) {
    return [NSUserDefaults standardUserDefaults];
}

#pragma mark 获取当前语言
RH_EXTERN NSString * rhCurrentLanguage(void) {
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

#pragma mark Library/Caches 文件路径
RH_EXTERN NSURL * rhFilePath(void) {
    return [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
}

#pragma mark 获取temp路径
RH_EXTERN NSString * rhPathTemp(void) {
    return NSTemporaryDirectory();
}

#pragma mark 获取沙盒 Document路径
RH_EXTERN NSString * rhPathDocument(void) {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

#pragma mark 获取沙盒 Cache
RH_EXTERN NSString * rhPathCache(void) {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

#pragma mark 获取沙盒 home 目录路径
RH_EXTERN NSString * rhPathHome(void) {
    return NSHomeDirectory();
}

RH_EXTERN void rhOpenURL(NSString *url) {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{}
                                     completionHandler:^(BOOL success) {
                if (success) {
                    RHLog(@"更新链接链接成功");
                }
            }];
        } else {
            // Fallback on earlier versions
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
#pragma clang diagnostic pop
        }
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
#pragma clang diagnostic pop
    }
}

RH_EXTERN void rhExitApplication(NSTimeInterval duration,void(^block)(void)) {
    [UIView animateWithDuration:duration animations:block completion:^(BOOL finished) {
        exit(0);
    }];
}


#pragma mark 复制文字内容
RH_EXTERN void rhCopyContent(NSString *content) {
    [[UIPasteboard generalPasteboard] setString:content];
}

#pragma mark 中文字体
RH_EXTERN UIFont * rhChineseSystem(CGFloat fontSize) {
    return [UIFont fontWithName:@"Heiti SC" size:fontSize];
}

RH_EXTERN UIFont * rhSystemFont(CGFloat fontSize) {
    return [UIFont systemFontOfSize:fontSize];
}

RH_EXTERN UIFont * rhBoldSystemFont(CGFloat fontSize) {
    return [UIFont boldSystemFontOfSize:fontSize];
}

RH_EXTERN UIFont * rhItalicSystemFont(CGFloat fontSize) {
    return [UIFont italicSystemFontOfSize:fontSize];
}

RH_EXTERN UIFont * rhFont(NSString *name,CGFloat fontSize) {
    return [UIFont fontWithName:name size:fontSize];
}


#pragma mark - 图片
RH_EXTERN UIImage * rhImageNamed(NSString *imageName) {
    return [UIImage imageNamed:imageName];
}

RH_EXTERN UIImage * rhImageNamedAndRenderingMode(NSString *imageName, UIImageRenderingMode renderingMode) {
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:renderingMode];
}


RH_EXTERN NSIndexPath * rhIndexPath(NSInteger section, NSInteger row) {
    return [NSIndexPath indexPathForRow:row inSection:section];
}


