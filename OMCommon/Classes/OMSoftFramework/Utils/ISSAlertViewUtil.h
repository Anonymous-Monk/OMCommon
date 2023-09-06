//
//  AlertViewUtil.h
//  oumaSoftiPhone
//
//  Created by Paperman on 17/1/21.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ISSAlertView;
typedef void(^ISSAlertViewBlock)(ISSAlertView *alertView, NSInteger buttonIndex);

@interface ISSAlertView : UIAlertView

@property (copy, nonatomic) void (^alertViewBlock) (ISSAlertView *alertView, NSInteger buttonIndex);

@end

@interface ISSAlertViewUtil : NSObject

+ (ISSAlertView *)showAlertView:(NSString *)title message:(NSString *)message
                     clickBlock:(ISSAlertViewBlock)block
              cancelButtonTitle:(NSString *)cancelButtonTitle
              otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (ISSAlertView *)showAlertView:(NSString *)title message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtonTitle:(NSString *)otherButtonTitle
                     clickBlock:(ISSAlertViewBlock)block;

+ (ISSAlertView *)showAlertView:(NSString *)title message:(NSString *)message
              cancelButtonTitle:(NSString *)cancelButtonTitle
                     clickBlock:(ISSAlertViewBlock)block;
@end
