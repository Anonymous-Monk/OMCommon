//
//  BaseNavigationController.h
//  Project
//
//  Created by Paperman on 14-1-1.
//  Copyright (c) 2014年 Paperman. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 带有返回手势NavigationController
 */

@interface BaseNavigationController : UINavigationController

@property (assign, nonatomic) BOOL popGestureEnabled;

@end
