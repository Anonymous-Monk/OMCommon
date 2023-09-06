#import "ISSAdditions+UIColor.h"

@implementation UIColor (ISSCategory)

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    hexString = [[hexString stringByReplacingOccurrencesOfString:@"#"withString:@""] uppercaseString];
    unsigned alpha, red, blue, green;
    switch ([hexString length])
    {
        case 3: /// #RGB
            alpha = 1.0f;
            red   = [UIColor hexValueToUnsigned:hexString start:0 length:1];
            green = [UIColor hexValueToUnsigned:hexString start:1 length:1];
            blue  = [UIColor hexValueToUnsigned:hexString start:2 length:1];
            break;
        case 4: /// #ARGB
            alpha = [UIColor hexValueToUnsigned:hexString start:0 length:1];
            red   = [UIColor hexValueToUnsigned:hexString start:1 length:1];
            green = [UIColor hexValueToUnsigned:hexString start:2 length:1];
            blue  = [UIColor hexValueToUnsigned:hexString start:3 length:1];
            break;
        case 6: /// #RRGGBB
            alpha = 1.0f;
            red   = [UIColor hexValueToUnsigned:hexString start:0 length:2];
            green = [UIColor hexValueToUnsigned:hexString start:2 length:2];
            blue  = [UIColor hexValueToUnsigned:hexString start:4 length:2];
            break;
        case 8: /// #AARRGGBB
            alpha = [UIColor hexValueToUnsigned: hexString start:0 length:2];
            red   = [UIColor hexValueToUnsigned: hexString start:2 length:2];
            green = [UIColor hexValueToUnsigned: hexString start:4 length:2];
            blue  = [UIColor hexValueToUnsigned: hexString start:6 length:2];
            break;
        default:
            alpha = 1;
            red   = 0;
            green = 0;
            blue  = 0;
            break;
    }
    return [UIColor colorWith8BitRed:red green:green blue:blue alpha:alpha];
}

+ (unsigned)hexValueToUnsigned:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
    unsigned result;
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [substring stringByAppendingString:substring];
    [[NSScanner scannerWithString:fullHex] scanHexInt:&result];
    return result;
}

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    return [UIColor colorWith8BitRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha
{
    UIColor *color = nil;
#if (TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE)
    color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
#else
    color = [UIColor colorWithCalibratedRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
#endif
    return color;
}
@end
