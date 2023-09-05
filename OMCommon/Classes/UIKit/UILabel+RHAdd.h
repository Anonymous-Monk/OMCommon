//
//  UILabel+RHAdd.h
//  MXSKit
//
//  Created by zero on 2022/3/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (RHAdd)

/**
 *  改变行间距
 */
+ (void)rh_changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;
/**
 *  改变字间距
 */
+ (void)rh_changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;
/**
 *  改变行间距和字间距
 */
+ (void)rh_changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

/**
 *  设置不同颜色
 */
+ (void)rh_setAttributedString:(UILabel *)attLabel withRangeOfString:(NSString *)rangOfString withValue:(UIColor *)color;

/**
 *  设置不同颜色+字号
 */
+ (void)rh_setAttributedString:(UILabel *)attLabel withRangeOfString:(NSString *)rangOfString withValue:(UIColor *)color value:(UIFont *)font;

/**
 *  设置不同字号
 */
+ (void)rh_setAttributedLabel:(UILabel *)attLabel withRangeOfString:(NSString *)rangeString value:(UIFont *)font;
/**
 *  文字中间划线
 */
+ (void)rh_setAttributedCenterLineLabel:(UILabel *)attLabel;
/**
 *  文字中间划线
 */
+ (void)rh_setAttributedCenterLineLabel:(UILabel *)attLabel text:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
