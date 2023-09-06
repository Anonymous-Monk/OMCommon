//
//  BaseNavigationController.m
//  Project
//
//  Created by Paperman on 14-1-1.
//  Copyright (c) 2014年 Paperman. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ISSAdditions+UIColor.h"
#import "ISSAdditions+UIImage.h"

@interface BaseNavigationController()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDelegate:self];
    [self.interactivePopGestureRecognizer setDelegate:self];
    self.popGestureEnabled = YES;
    
    UIColor *bgColor = [UIColor colorWithHexString:@"#24252B"];
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:bgColor forSize:CGSizeMake(1, 64)] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationBar setTranslucent:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

#pragma mark UIGestureRecognizerDelegate
- (void)handleSwipes:(UISwipeGestureRecognizer *)swipeGestureRecognizer {
    if (self.popGestureEnabled) {
        [self popViewControllerAnimated:YES];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.popGestureEnabled;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue < 10.0) {
        [[navigationController transitionCoordinator] notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            if ([context isCancelled])
            {
                UIViewController *fromViewController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
                [self navigationController:navigationController willShowViewController:fromViewController animated:animated];
                if ([self respondsToSelector:@selector(navigationController:didShowViewController:animated:)])
                {
                    NSTimeInterval animationCompletion = [context transitionDuration] * [context percentComplete];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (uint64_t)animationCompletion * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        NSLog(@"PopGestureCanceled :%@", fromViewController);
                    });
                }
            }
        }];
    } else {
        [[navigationController transitionCoordinator] notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            if ([context isCancelled])
            {
                UIViewController *fromViewController = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
                [self navigationController:navigationController willShowViewController:fromViewController animated:animated];
                if ([self respondsToSelector:@selector(navigationController:didShowViewController:animated:)])
                {
                    NSTimeInterval animationCompletion = [context transitionDuration] * [context percentComplete];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (uint64_t)animationCompletion * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        NSLog(@"PopGestureCanceled :%@", fromViewController);
                    });
                }
            }
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate {
    [self.interactivePopGestureRecognizer setEnabled:YES];
}
@end
