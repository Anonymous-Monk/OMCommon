//
//  RHSystemCommon.h
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "RHCommon.h"

RH_EXTERN_C_BEGIN

#pragma mark App版本号
RH_EXTERN void rhAppVersion(void);

#pragma mark 系统版本
RH_EXTERN float rhFSystemVersion(void);
RH_EXTERN double rhDSystemVersion(void);
RH_EXTERN NSString* rhSSystemVersion(void);

#pragma mark 当前系统是否大于某个版本
RH_EXTERN BOOL isIOS6(void);
RH_EXTERN BOOL isIOS7(void);
RH_EXTERN BOOL isIOS8(void);
RH_EXTERN BOOL isIOS9(void);
RH_EXTERN BOOL isIOS10(void);
RH_EXTERN BOOL isIOS11(void);

RH_EXTERN BOOL isIPhoneX(void);

RH_EXTERN BOOL isiPhoneXMax(void);

RH_EXTERN BOOL isIPad(void);

#pragma mark AppDelegate对象
RH_EXTERN id rhAppDelegateInstance(void);

#pragma mark - Application
RH_EXTERN UIApplication * rhApplication(void);

#pragma mark - KeyWindow
RH_EXTERN UIWindow * rhKeyWindow(void);

#pragma mark - NotiCenter
RH_EXTERN NSNotificationCenter * rhNotificationCenter(void);

#pragma mark - NSUserDefault
RH_EXTERN NSUserDefaults * rhNSUserDefaults(void);

#pragma mark 获取当前语言
RH_EXTERN NSString * rhCurrentLanguage(void);

#pragma mark Library/Caches 文件路径
RH_EXTERN NSURL * rhFilePath(void);

#pragma mark 获取temp路径
RH_EXTERN NSString * rhPathTemp(void);

#pragma mark 获取沙盒 Document路径
RH_EXTERN NSString * rhPathDocument(void);

#pragma mark 获取沙盒 Cache
RH_EXTERN NSString * rhPathCache(void);

#pragma mark 获取沙盒 home 目录路径
RH_EXTERN NSString * rhPathHome(void);

#pragma mark 用safari打开URL
RH_EXTERN void rhOpenURL(NSString *url);

#pragma mark 强制让App直接退出
RH_EXTERN void rhExitApplication(NSTimeInterval duration,void(^block)(void));

#pragma mark 复制文字内容
RH_EXTERN void rhCopyContent(NSString *content);

#pragma mark 中文字体
RH_EXTERN UIFont * rhChineseSystem(CGFloat fontSize);
RH_EXTERN UIFont * rhSystemFont(CGFloat fontSize);
RH_EXTERN UIFont * rhBoldSystemFont(CGFloat fontSize);
RH_EXTERN UIFont * rhItalicSystemFont(CGFloat fontSize);
RH_EXTERN UIFont * rhFont(NSString *name,CGFloat fontSize);


#pragma mark - 图片
RH_EXTERN UIImage * rhImageNamed(NSString *imageName);
RH_EXTERN UIImage * rhImageNamedAndRenderingMode(NSString *imageName, UIImageRenderingMode renderingMode);

#pragma mark - NSIndexPath
RH_EXTERN NSIndexPath * rhIndexPath(NSInteger section, NSInteger row);




RH_EXTERN_C_END
