#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const DefaultKeyboardPadding;

@interface UIViewController (ISSCategory)

/**
 *  Will return a newly instantiated view controller of the current class using
 *  the standard init method without a nibName or bundle.
 *
 *  @return UIViewController / relative subclass
 */
+ (instancetype)viewController;

/**
 *  Will return a newly instantiated view controller based on the current class.
 *  The current class as a string will be used as the nibName.
 *
 *  @return UIViewController / relative subclass
 */
+ (instancetype)viewControllerFromNIB;

/** return a newly instantiated view controller of the Storyboard name
 */
+ (instancetype)viewControllerFromStoryboardName:(NSString *)name;

/** return a newly instantiated view controller based on the Storyboard
 */
+ (instancetype)viewControllerFromStoryboard:(UIStoryboard *)storyboard;

/** 处理键盘出现时界面调整
 */
- (void)handleTextFieldWillEditing:(UITextField *)textField;
@end
