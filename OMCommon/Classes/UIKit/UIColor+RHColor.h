//
//  UIColor+RHColor.h
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger,RHGradietColorType) {
    RHGradietColorTypeTopToBottom = 0, /// 从上到下
    RHGradietColorTypeLeftToRight = 1, /// 从左到右
    RHGradietColorTypeUpLeftToLowRight = 2, /// 从左上到右下
    RHGradietColorTypeUpRightToLowLeft = 3, /// 从右上到左下
};

extern void RH_RGB2HSL(CGFloat r, CGFloat g, CGFloat b,
                       CGFloat *h, CGFloat *s, CGFloat *l);

extern void RH_HSL2RGB(CGFloat h, CGFloat s, CGFloat l,
                       CGFloat *r, CGFloat *g, CGFloat *b);

extern void RH_RGB2HSB(CGFloat r, CGFloat g, CGFloat b,
                       CGFloat *h, CGFloat *s, CGFloat *v);

extern void RH_HSB2RGB(CGFloat h, CGFloat s, CGFloat v,
                       CGFloat *r, CGFloat *g, CGFloat *b);

extern void RH_RGB2CMYK(CGFloat r, CGFloat g, CGFloat b,
                        CGFloat *c, CGFloat *m, CGFloat *y, CGFloat *k);

extern void RH_CMYK2RGB(CGFloat c, CGFloat m, CGFloat y, CGFloat k,
                        CGFloat *r, CGFloat *g, CGFloat *b);

extern void RH_HSB2HSL(CGFloat h, CGFloat s, CGFloat b,
                       CGFloat *hh, CGFloat *ss, CGFloat *ll);

extern void RH_HSL2HSB(CGFloat h, CGFloat s, CGFloat l,
                       CGFloat *hh, CGFloat *ss, CGFloat *bb);


/*
 Create UIColor with a hex string.
 Example: UIColorHex(0xF0F), UIColorHex(66ccff), UIColorHex(#66CCFF88)
 
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 */
#ifndef UIColorHex
#define UIColorHex(_hex_)   [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif

/**
 Provide some method for `UIColor` to convert color between
 RGB,HSB,HSL,CMYK and Hex.
 
 | Color space | Meaning                                |
 |-------------|----------------------------------------|
 | RGB *       | Red, Green, Blue                       |
 | HSB(HSV) *  | Hue, Saturation, Brightness (Value)    |
 | HSL         | Hue, Saturation, Lightness             |
 | CMYK        | Cyan, Magenta, Yellow, Black           |
 
 Apple use RGB & HSB default.
 
 All the value in this category is float number in the range `0.0` to `1.0`.
 Values below `0.0` are interpreted as `0.0`,
 and values above `1.0` are interpreted as `1.0`.
 
 */

@interface UIColor (RHColor)

#pragma mark - Create a UIColor Object
///=============================================================================
/// @name Creating a UIColor Object
///=============================================================================

/**
 Creates and returns a color object using the specified opacity
 and HSL color space component values.
 
 @param hue        The hue component of the color object in the HSL color space,
 specified as a value from 0.0 to 1.0.
 
 @param saturation The saturation component of the color object in the HSL color space,
 specified as a value from 0.0 to 1.0.
 
 @param lightness  The lightness component of the color object in the HSL color space,
 specified as a value from 0.0 to 1.0.
 
 @param alpha      The opacity value of the color object,
 specified as a value from 0.0 to 1.0.
 
 @return           The color object. The color information represented by this
 object is in the device RGB colorspace.
 */
+ (UIColor *)rh_colorWithHue:(CGFloat)hue
                  saturation:(CGFloat)saturation
                   lightness:(CGFloat)lightness
                       alpha:(CGFloat)alpha;

/**
 Creates and returns a color object using the specified opacity
 and CMYK color space component values.
 
 @param cyan    The cyan component of the color object in the CMYK color space,
 specified as a value from 0.0 to 1.0.
 
 @param magenta The magenta component of the color object in the CMYK color space,
 specified as a value from 0.0 to 1.0.
 
 @param yellow  The yellow component of the color object in the CMYK color space,
 specified as a value from 0.0 to 1.0.
 
 @param black   The black component of the color object in the CMYK color space,
 specified as a value from 0.0 to 1.0.
 
 @param alpha   The opacity value of the color object,
 specified as a value from 0.0 to 1.0.
 
 @return        The color object. The color information represented by this
 object is in the device RGB colorspace.
 */
+ (UIColor *)rh_colorWithCyan:(CGFloat)cyan
                      magenta:(CGFloat)magenta
                       yellow:(CGFloat)yellow
                        black:(CGFloat)black
                        alpha:(CGFloat)alpha;

/**
 Creates and returns a color object using the hex RGB color values.
 
 @param rgbValue  The rgb value such as 0x66ccff.
 
 @return          The color object. The color information represented by this
 object is in the device RGB colorspace.
 */
+ (UIColor *)rh_colorWithRGB:(uint32_t)rgbValue;

/**
 Creates and returns a color object using the hex RGBA color values.
 
 @param rgbaValue  The rgb value such as 0x66ccffff.
 
 @return           The color object. The color information represented by this
 object is in the device RGB colorspace.
 */
+ (UIColor *)rh_colorWithRGBA:(uint32_t)rgbaValue;

/**
 Creates and returns a color object using the specified opacity and RGB hex value.
 
 @param rgbValue  The rgb value such as 0x66CCFF.
 
 @param alpha     The opacity value of the color object,
 specified as a value from 0.0 to 1.0.
 
 @return          The color object. The color information represented by this
 object is in the device RGB colorspace.
 */
+ (UIColor *)rh_colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;

+ (UIColor *)rh_colorWithHex:(UInt32)hex;

+ (UIColor *)rh_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;

/**
 Creates and returns a color object from hex string.
 
 @discussion:
 Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
 The `#` or "0x" sign is not required.
 The alpha will be set to 1.0 if there is no alpha component.
 It will return nil when an error occurs in parsing.
 
 Example: @"0xF0F", @"66ccff", @"#66CCFF88"
 
 @param hexStr  The hex string value for the new color.
 
 @return        An UIColor object from string, or nil if an error occurs.
 */
+ (nullable UIColor *)rh_colorWithHexString:(NSString *)hexStr;

/** 
 Creates and returns a color object by add new color.
 
 @param add        the color added
 
 @param blendMode  add color blend mode
 */
- (UIColor *)rh_colorByAddColor:(UIColor *)add blendMode:(CGBlendMode)blendMode;

/**
 Creates and returns a color object by change components.
 
 @param hueDelta         the hue change delta specified as a value
 from -1.0 to 1.0. 0 means no change.
 
 @param saturationDelta  the saturation change delta specified as a value
 from -1.0 to 1.0. 0 means no change.
 
 @param brightnessDelta  the brightness change delta specified as a value
 from -1.0 to 1.0. 0 means no change.
 
 @param alphaDelta       the alpha change delta specified as a value
 from -1.0 to 1.0. 0 means no change.
 */
- (UIColor *)rh_colorByChangeHue:(CGFloat)hueDelta
                      saturation:(CGFloat)saturationDelta
                      brightness:(CGFloat)brightnessDelta
                           alpha:(CGFloat)alphaDelta;

///值不需要除以255.0
+ (UIColor *)rh_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue
                            alpha:(CGFloat)alpha;
///值不需要除以255.0
+ (UIColor *)rh_colorWithWholeRed:(CGFloat)red
                            green:(CGFloat)green
                             blue:(CGFloat)blue;

/**
 *  @brief  随机颜色
 *
 *  @return UIColor
 */
+ (UIColor *)rh_randomColor;

/**
 *  @brief  渐变颜色
 *
 *  @param colors    颜色集
 *  @param type     渐变类型
 *  @param size  尺寸
 *
 *  @return 渐变颜色
 */
+ (UIColor*)rh_gradientColorWithColors:(NSArray*)colors gradientType:(RHGradietColorType)type Size:(CGSize)size;

/**
 *  @brief  竖向渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param height 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor*)rh_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;

/**
 *  @brief  横向渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param width 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor*)rh_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withWidth:(int)width;

/**
 * 反转颜色
 */
- (UIColor *)rh_invertedColor;
/**
 * 半透明颜色
 */
- (UIColor *)rh_colorForTranslucency;
/**
 * 浅色
 */
- (UIColor *)rh_lightenColor:(CGFloat)lighten;
/**
 * 深色
 */
- (UIColor *)rh_darkenColor:(CGFloat)darken;


#pragma mark - Get color's description
///=============================================================================
/// @name Get color's description
///=============================================================================

/**
 Returns the rgb value in hex.
 @return hex value of RGB,such as 0x66ccff.
 */
- (uint32_t)rh_rgbValue;

/**
 Returns the rgba value in hex.
 
 @return hex value of RGBA,such as 0x66ccffff.
 */
- (uint32_t)rh_rgbaValue;

/**
 Returns the color's RGB value as a hex string (lowercase).
 Such as @"0066cc".
 
 It will return nil when the color space is not RGB
 
 @return The color's value as a hex string.
 */
- (nullable NSString *)rh_hexString;

/**
 Returns the color's RGBA value as a hex string (lowercase).
 Such as @"0066ccff".
 
 It will return nil when the color space is not RGBA
 
 @return The color's value as a hex string.
 */
- (nullable NSString *)rh_hexStringWithAlpha;


#pragma mark - Retrieving Color Information
///=============================================================================
/// @name Retrieving Color Information
///=============================================================================

/**
 Returns the components that make up the color in the HSL color space.
 
 @param hue         On return, the hue component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @param saturation  On return, the saturation component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @param lightness   On return, the lightness component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @param alpha       On return, the alpha component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @return            YES if the color could be converted, NO otherwise.
 */
- (BOOL)rh_getHue:(CGFloat *)hue
       saturation:(CGFloat *)saturation
        lightness:(CGFloat *)lightness
            alpha:(CGFloat *)alpha;

/**
 Returns the components that make up the color in the CMYK color space.
 
 @param cyan     On return, the cyan component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @param magenta  On return, the magenta component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @param yellow   On return, the yellow component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @param black    On return, the black component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @param alpha    On return, the alpha component of the color object,
 specified as a value between 0.0 and 1.0.
 
 @return         YES if the color could be converted, NO otherwise.
 */
- (BOOL)rh_getCyan:(CGFloat *)cyan
           magenta:(CGFloat *)magenta
            yellow:(CGFloat *)yellow
             black:(CGFloat *)black
             alpha:(CGFloat *)alpha;

/**
 The color's red component value in RGB color space.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat rh_red;

/**
 The color's green component value in RGB color space.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat rh_green;

/**
 The color's blue component value in RGB color space.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat rh_blue;

/**
 The color's hue component value in HSB color space.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat rh_hue;

/**
 The color's saturation component value in HSB color space.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat rh_saturation;

/**
 The color's brightness component value in HSB color space.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat rh_brightness;

/**
 The color's alpha component value.
 The value of this property is a float in the range `0.0` to `1.0`.
 */
@property (nonatomic, readonly) CGFloat rh_alpha;

/**
 The color's colorspace model.
 */
@property (nonatomic, readonly) CGColorSpaceModel rh_colorSpaceModel;

/**
 Readable colorspace string.
 */
@property (nullable, nonatomic, readonly) NSString *rh_colorSpaceString;


@end

NS_ASSUME_NONNULL_END
