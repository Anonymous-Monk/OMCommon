//
//  AlertViewUtil.m
//  oumaSoftiPhone
//
//  Created by Paperman on 17/1/21.
//
//

#import "ISSAlertViewUtil.h"

@implementation ISSAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        super.delegate = self;
    }
    return self;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.alertViewBlock) {
        self.alertViewBlock(self, buttonIndex);
    }
}
@end

@implementation ISSAlertViewUtil

+ (ISSAlertView *)showAlertView:(NSString *)title message:(NSString *)message
                     clickBlock:(ISSAlertViewBlock)block
              cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
{
    ISSAlertView *alertView = [[ISSAlertView alloc] init];
    alertView.title = title;
    alertView.message = message;
    alertView.alertViewBlock = block;
    if (cancelButtonTitle) {
        NSInteger index = [alertView addButtonWithTitle:cancelButtonTitle];
        [alertView setCancelButtonIndex:index];
    }
    if (otherButtonTitles) {
        va_list args;
        NSInteger index = 1;
        va_start(args, otherButtonTitles);
        for (NSString *item = otherButtonTitles; item != nil; item = va_arg(args, NSString *)) {
            [alertView addButtonWithTitle:item];
            index++;
        }
        va_end(args);
    }
    [alertView show];
    return alertView;
}

+ (ISSAlertView *)showAlertView:(NSString *)title message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtonTitle:(NSString *)otherButtonTitle
                     clickBlock:(ISSAlertViewBlock)block;
{
    return [self showAlertView:title message:message clickBlock:block cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
}

+ (ISSAlertView *)showAlertView:(NSString *)title message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
                     clickBlock:(ISSAlertViewBlock)block;
{
    return [self showAlertView:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitle:nil clickBlock:block];
}
@end
