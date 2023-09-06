#import "ISSAdditions+UIViewController.h"

CGFloat const DefaultKeyboardPadding = 30;

@implementation UIViewController (ISSCategory)

+ (instancetype)viewController {
    if (![self class]) return nil;
    return [[[self class] alloc] initWithNibName:nil bundle:nil];
}

+ (instancetype)viewControllerFromNIB {
    if (![self class]) return nil;
    return [[[self class] alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (instancetype)viewControllerFromStoryboardName:(NSString *)name {
    if (![self class]) return nil;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    return [[self class] viewControllerFromStoryboard:storyboard];
}

+ (instancetype)viewControllerFromStoryboard:(UIStoryboard *)storyboard {
    if (![self class]) return nil;
    return [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)handleTextFieldWillEditing:(UITextField *)textField
{
    __weak UIViewController *weakSelf = self;
    __weak UITextField *weakTextField = textField;
    __block id kbws = [[NSNotificationCenter defaultCenter]
                       addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                           if (weakTextField.isFirstResponder) {
                               CGRect newRect = weakSelf.view.bounds;
                               if (newRect.origin.y != 0) {
                                   newRect.origin.y = 0;
                                   weakSelf.view.bounds = newRect;
                               }
                               CGRect keyboardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
                               CGRect textFieldRect = [weakTextField convertRect:weakTextField.bounds toView:nil];
                               CGFloat value = CGRectGetMaxY(textFieldRect) - CGRectGetMinY(keyboardRect) + DefaultKeyboardPadding;
                               if (value > 0) {
                                   newRect.origin.y = ABS(value);
                                   weakSelf.view.bounds = newRect;
                               }
                           }
                           [[NSNotificationCenter defaultCenter] removeObserver:kbws];
                       }];
    __block id kbwh = [[NSNotificationCenter defaultCenter]
                       addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                           if (weakTextField.isFirstResponder) {
                               CGRect newRect = weakSelf.view.bounds;
                               newRect.origin.y = 0;
                               weakSelf.view.bounds = newRect;
                           }
                           [[NSNotificationCenter defaultCenter] removeObserver:kbwh];
                       }];
}
@end
