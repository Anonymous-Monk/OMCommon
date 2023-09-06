//
//  BaseViewController.m
//  Project
//
//  Created by Paperman on 14-1-1.
//  Copyright (c) 2014年 Paperman. All rights reserved.
//

#import "BaseViewController.h"
#import "ISSAdditions+NSObject.h"
#import "ISSAdditions+UIColor.h"

#define DEFAULT_BACK_IMAGE              @"btn_bar_back.png"
#define DEFAULT_BACKGROUND_IMAGE        @"btn_bar_back.png"

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];                    /// 去除视图边扩展
    [self setAutomaticallyAdjustsScrollViewInsets:NO];                  /// 去控制留白以及坐标问题
    [self.view setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];   /// 色调调整模式
    if (self.title == nil) {
        [self setTitle:NSLocalizedString(NSStringFromClass([self class]), nil)];
    }

    self.view.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [self setDefaultBackButton];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)dealloc {
    [self unregisterNotify];
}

- (void)setLocalizedString {
}

- (void)setDefaultBackButton {
    NSString *title = @"返回";
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:self action:@selector(backBarAction:)];
    [self.navigationItem setBackBarButtonItem:backBarItem];
}

- (void)backBarAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
