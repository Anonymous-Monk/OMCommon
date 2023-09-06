#import <UIKit/UIKit.h>

@interface UIColor (ISSCategory)

/**
 * 16进制转UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

@end
