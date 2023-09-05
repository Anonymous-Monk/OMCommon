//
//  NSString+RHString.m
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import "NSString+RHString.h"
#import <CommonCrypto/CommonDigest.h>

static char rh_base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation NSString (RHString)

+ (NSString *)rh_getNumberWithString:(NSString *)string {
    
    NSMutableString *rh_string = [[NSMutableString alloc] init];
    
    for (NSInteger i = 0; i < string.length; i++) {
        
        NSString *rh_numberString = [string substringWithRange:NSMakeRange(i, 1)];
        
        if ([rh_numberString rh_isNumber]) {
            
            [rh_string appendString:rh_numberString];
        }
    }
    
    return rh_string;
}

- (NSString *)decimals:(int)decimals {
    if (self != nil && !self.isEmpty) {
        CGFloat number = self.floatValue;
        NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
        [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
        [nFormat setMaximumFractionDigits:decimals];
        [nFormat setMinimumFractionDigits:decimals];
        NSString *string = [nFormat stringFromNumber:@(number)];
        return string;
    }
    return @"0";
}


- (BOOL)isEmpty {
    if (self != nil && ![@"" equals:self.trim]) {
        return NO;
    }
    return YES;
}

//对比两个字符串内容是否一致
- (BOOL)equals:(NSString *)string {
    return [self isEqualToString:string];
}

//截取字符串前后空格
- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


+ (NSString *)rh_getSecrectStringWithPhoneNumber:(NSString *)phoneNumber {
    
    if (![phoneNumber rh_checkPhoneNumber]) {
        
        return nil;
    }
    
    NSMutableString *rh_phoneNumberString = [NSMutableString stringWithString:phoneNumber];
    
    NSRange rh_phoneNumberRange = NSMakeRange(3, 4);
    
    [rh_phoneNumberString replaceCharactersInRange:rh_phoneNumberRange
                                        withString:@"****"];
    
    return rh_phoneNumberString;
}

+ (NSString *)rh_getSecrectStringWithCardNumber:(NSString *)cardNumber {
    
    if (cardNumber.length < 8) {
        
        return nil;
    }
    
    NSMutableString *rh_cardNumber = [NSMutableString stringWithString:cardNumber];
    
    NSRange rh_cardRange = NSMakeRange(4, 8);
    
    [rh_cardNumber replaceCharactersInRange:rh_cardRange
                                 withString:@" **** **** "];
    
    return rh_cardNumber;
}

- (CGFloat)rh_heightWithFontSize:(CGFloat)fontSize
                           width:(CGFloat)width {
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    
    return  [self boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                            attributes:attributes
                               context:nil].size.height;
}

- (NSString *)rh_removeUnwantedZero {
    
    if ([[self substringWithRange:NSMakeRange(self.length - 3, 3)] isEqualToString:@"000"]) {
        
        return [self substringWithRange:NSMakeRange(0, self.length - 4)]; // 多一个小数点
        
    } else if ([[self substringWithRange:NSMakeRange(self.length - 2, 2)] isEqualToString:@"00"]) {
        
        return [self substringWithRange:NSMakeRange(0, self.length - 2)];
        
    } else if ([[self substringWithRange:NSMakeRange(self.length - 1, 1)] isEqualToString:@"0"]) {
        
        return [self substringWithRange:NSMakeRange(0, self.length - 1)];
    } else {
        return self;
    }
}

- (NSString *)rh_trimmedString {
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)rh_removeStringCharacterWithCharacter:(NSString *)character {
    
    return [self stringByReplacingOccurrencesOfString:character
                                           withString:@""];
}

+ (NSString *)rh_stringMobileFormat:(NSString *)phoneNumber {
    
    return [self rh_stringMobileFormat:phoneNumber
                             separator:@" "];
}

+ (NSString *)rh_stringMobileFormat:(NSString *)phoneNumber
                          separator:(NSString *)separator {
    
    if ([phoneNumber rh_checkPhoneNumber]) {
        
        NSMutableString *value = [[NSMutableString alloc] initWithString:phoneNumber];
        
        [value insertString:separator
                    atIndex:3];
        [value insertString:separator
                    atIndex:8];
        
        return value;
    }
    
    return nil;
}

+ (NSString *)rh_stringUnitFormat:(CGFloat)value
                       unitString:(NSString *)unitString {
    
    if (value / 100000000 >= 1) {
        
        return [NSString stringWithFormat:@"%.0f%@", value / 100000000, unitString];
        
    } else if (value / 10000 >= 1 && value / 100000000 < 1) {
        
        return [NSString stringWithFormat:@"%.0f%@", value / 10000, unitString];
        
    } else {
        
        return [NSString stringWithFormat:@"%.0f", value];
    }
}

+ (NSString *)rh_getDealNumwithstring:(NSString *)string withNumCount:(NSInteger)integer{
    if ([string integerValue]>0) {
        NSDictionary *unitDic = @{
            @"4":@"万",
            @"6":@"百万",
            @"7":@"千万",
            @"8":@"亿",
            @"12":@"万亿"
        };
        if (integer > 0) {
            NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:string];
            NSDecimalNumber *numberB ;
            NSMutableArray *joinArr = [[NSMutableArray alloc]init];
            [joinArr addObject:@"1"];
            NSString *joinStr = nil;
            NSString *unitStr = @"";
            unitStr = unitDic[[NSString stringWithFormat:@"%ld",integer]];
            for (int i = 0; i < integer; i ++) {
                [joinArr addObject:@"0"];
            }
            joinStr = [joinArr componentsJoinedByString:@""];
            numberB =  [NSDecimalNumber decimalNumberWithString:joinStr];
            
            //NSDecimalNumberBehaviors对象的创建  参数 1.RoundingMode 一个取舍枚举值 2.scale 处理范围 3.raiseOnExactness  精确出现异常是否抛出原因 4.raiseOnOverflow  上溢出是否抛出原因  4.raiseOnUnderflow  下溢出是否抛出原因  5.raiseOnDivideByZero  除以0是否抛出原因。
            NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
            
            /// 这里不仅包含Multiply还有加 减 乘。
            NSDecimalNumber *numResult = [numberA decimalNumberByDividingBy:numberB withBehavior:roundingBehavior];
            NSString *strResult = [NSString stringWithFormat:@"%@%@",[numResult stringValue],unitStr];
            return strResult;
        }else {
            NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:string];
            NSDecimalNumber *numberB ;
            NSInteger dealPlacesInteger = string.length - 1;
            
            //        NSString *unitStr = dealPlacesInteger >= 4 ? unitDic[[NSString stringWithFormat:@"%ld",dealPlacesInteger]] : @"";
            NSString *unitStr = nil;
            
            
            if (dealPlacesInteger < 4) {
                numberB =  [NSDecimalNumber decimalNumberWithString:@"1"];
                unitStr = @"";
            }else if (dealPlacesInteger >=4 && dealPlacesInteger < 8) {
                numberB =  [NSDecimalNumber decimalNumberWithString:@"10000"];
                unitStr = @"万";
            }else if (dealPlacesInteger >=8) {
                numberB =  [NSDecimalNumber decimalNumberWithString:@"100000000"];
                unitStr = @"亿";
            }
            NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
            
            NSDecimalNumber *numResult = [numberA decimalNumberByDividingBy:numberB withBehavior:roundingBehavior];
            NSString *strResult = [NSString stringWithFormat:@"%@%@",[numResult stringValue],unitStr];
            return strResult;
        }
    }else{
        return @"0";
    }
    
}


+ (NSString *)rh_transformedFileSizeValue:(id)value {
    return [self rh_transformedFileSizeValue:value unit:1024];
}

+ (NSString *)rh_transformedFileSizeValue:(id)value unit:(int)unit {
    if (unit < 1) {
        unit = 1024;
    }
    double convertedValue = [value doubleValue] / unit;
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"K",@"M",@"G",@"T",@"P", @"E", @"Z", @"Y",nil];
    
    while (convertedValue > unit) {
        convertedValue /= unit;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];
}

+ (NSString *)rh_dealWithString:(NSString *)number {
    NSString *doneTitle = @"";
    int count = 0;
    for (int i = 0; i < number.length; i++) {
        
        count++;
        doneTitle = [doneTitle stringByAppendingString:[number substringWithRange:NSMakeRange(i, 1)]];
        if (count == 4) {
            doneTitle = [NSString stringWithFormat:@"%@ ", doneTitle];
            count = 0;
        }
    }
    NSLog(@"%@", doneTitle);
    return doneTitle;
}



+ (CGSize)rh_measureStringSizeWithString:(NSString *)string
                                    font:(UIFont *)font {
    
    if ([self rh_checkEmptyWithString:string]) {
        
        return CGSizeZero;
    }
    
    CGSize measureSize = [string boundingRectWithSize:CGSizeMake(0, 0)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]
                                              context:nil].size;
    
    return measureSize;
}

+ (CGFloat)rh_measureSingleLineStringWidthWithString:(NSString *)string
                                                font:(UIFont *)font {
    
    if ([self rh_checkEmptyWithString:string]) {
        
        return 0;
    }
    
    CGSize measureSize = [string boundingRectWithSize:CGSizeMake(0, 0)
                                              options:NSStringDrawingUsesFontLeading
                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]
                                              context:nil].size;
    
    return ceil(measureSize.width);
}

+ (CGFloat)rh_measureHeightWithMutilineString:(NSString *)string
                                         font:(UIFont *)font
                                        width:(CGFloat)width {
    
    if ([self rh_checkEmptyWithString:string] || width <= 0) {
        
        return 0;
    }
    
    CGSize measureSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]
                                              context:nil].size;
    
    return ceil(measureSize.height);
}

+ (NSString *)rh_urlQueryStringWithDictionary:(NSDictionary *)dictionary {
    
    NSMutableString *string = [NSMutableString string];
    
    for (NSString *key in [dictionary allKeys]) {
        
        if ([string length]) {
            
            [string appendString:@"&"];
        }
        CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[[dictionary objectForKey:key] description],
                                                                      NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                      kCFStringEncodingUTF8);
        [string appendFormat:@"%@=%@", key, escaped];
        CFRelease(escaped);
    }
    return string;
}

+ (NSString *)rh_jsonStringWithObject:(NSObject *)object {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (jsonData == nil) {
#ifdef DEBUG
        NSLog(@"fail to get JSON from dictionary: %@, error: %@", self, error);
#endif
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (BOOL)rh_checkEmptyWithString:(NSString *)string {
    
    if (string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [string length] == 0 || [string isEqualToString: @"(null)"]) {
        
        return YES;
    }
    return NO;
}

#pragma mark - 加密字符串方法
+ (NSString *)rh_base64StringFromData:(NSData *)data
                               length:(NSUInteger)length {
    
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    
    NSMutableString *result;
    
    lentext = [data length];
    
    if (lentext < 1) {
        return @"";
    }
    result = [NSMutableString stringWithCapacity: lentext];
    
    raw = [data bytes];
    
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0) {
            break;
        }
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext) {
                input[i] = raw[ix];
            }
            else {
                input[i] = 0;
            }
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++) {
            
            [result appendString: [NSString stringWithFormat: @"%c", rh_base64EncodingTable[output[i]]]];
        }
        
        for (i = ctcopy; i < 4; i++) {
            
            [result appendString: @"="];
        }
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length)) {
            
            charsonline = 0;
        }
    }
    return result;
}

+ (NSString *)rh_encodingBase64WithString:(NSString *)string {
    
    NSData *rh_stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *rh_encodedString = [rh_stringData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return rh_encodedString;
}

+ (NSString *)rh_decodedBase64WithString:(NSString *)string {
    
    NSData *rh_stringData = [[NSData alloc] initWithBase64EncodedString:string
                                                                options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSString *rh_decodedString = [[NSString alloc] initWithData:rh_stringData
                                                       encoding:NSUTF8StringEncoding];
    return rh_decodedString;
}

#pragma mark - MD5
+ (NSString *)rh_encodingMD5WithString:(NSString *)string {
    
    if([self rh_checkEmptyWithString:string]) {
        return nil;
    }
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [NSString stringWithString:outputString];
}

#pragma mark - 获取字符串首字母
+ (NSString *)rh_transformPinYinWithString:(NSString *)string {
    
    NSMutableString *rh_string = [string mutableCopy];
    
    CFStringTransform((CFMutableStringRef)rh_string,
                      NULL,
                      kCFStringTransformMandarinLatin,
                      NO);
    
    CFStringTransform((CFMutableStringRef)rh_string,
                      NULL,
                      kCFStringTransformStripDiacritics,
                      NO);
    
    return rh_string;
}

#pragma mark - NSString获取首字母
+ (NSString *)rh_getFirstCharactorWithString:(NSString *)string {
    
    NSString *rh_pinYin = [[self rh_transformPinYinWithString:string] uppercaseString];
    
    if (!rh_pinYin || [self rh_checkEmptyWithString:string]) {
        
        return @"#";
    }
    
    return [rh_pinYin substringToIndex:1];
}

+ (NSString *)rh_getFirstPinYinWithString:(NSString *)string {
    
    NSString *rh_pinYin = [[self rh_transformPinYinWithString:string] uppercaseString];
    
    if (!rh_pinYin || [self rh_checkEmptyWithString:string]) {
        
        return @"#";
    }
    
    rh_pinYin = [rh_pinYin substringToIndex:1];
    
    if ([rh_pinYin compare:@"A"] == NSOrderedAscending || [rh_pinYin compare:@"Z"] == NSOrderedDescending) {
        
        rh_pinYin = @"#";
    }
    
    return rh_pinYin;
}

#pragma mark - 正则表达式

- (BOOL)rh_realContainDecimal {
    
    NSString *rules = @"^(\\-|\\+)?\\d+(\\.\\d+)?$";
    
    return [self rh_regularWithRule:rules];
}

#pragma mark - 整数相关
- (BOOL)rh_isNumber {
    
    NSString *rules = @"^[0-9]*$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkMostNumber:(NSInteger)quantity {
    
    NSString *rules = [NSString stringWithFormat:@"^\\d{%ld}$", (long)quantity];
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkAtLeastNumber:(NSInteger)quantity {
    
    NSString *rules = [NSString stringWithFormat:@"^\\d{%ld,}$", (long)quantity];
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkLeastNumber:(NSInteger)leastNumber
                 mostNumber:(NSInteger)mostNumber {
    
    NSString *rules = [NSString stringWithFormat:@"^\\d{%ld,%ld}$", (long)leastNumber, (long)mostNumber];
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isNotZeroStartNumber {
    
    NSString *rules = @"^(0|[1-9][0-9]*)$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isNotZeroPositiveInteger {
    
    NSString *rules = @"^[1-9]\\d*$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isNotZeroNegativeInteger {
    
    NSString *rules = @"^-[1-9]\\d*$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isPositiveInteger {
    
    NSString *rules = @"^\\d+$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isNegativeInteger {
    
    NSString *rules = @"^-[1-9]\\d*";
    
    return [self rh_regularWithRule:rules];
}

#pragma mark - 浮点数相关
- (BOOL)rh_isFloat {
    
    NSString *rules = @"^(-?\\d+)(\\.\\d+)?$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isPositiveFloat {
    
    NSString *rules = @"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isNagativeFloat {
    
    NSString *rules = @"^-([1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*)$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isNotZeroStartNumberHaveOneOrTwoDecimal {
    
    NSString *rules = @"^([1-9][0-9]*)+(.[0-9]{1,2})?$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isHaveOneOrTwoDecimalPositiveOrNegative {
    
    NSString *rules = @"^(\\-)?\\d+(\\.\\d{1,2})?$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isPositiveRealHaveTwoDecimal {
    
    NSString *rules = @"^[0-9]+(.[0-9]{2})?$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isHaveOneOrThreeDecimalPositiveOrNegative {
    
    NSString *rules = @"^[0-9]+(.[0-9]{1,3})?$";
    
    return [self rh_regularWithRule:rules];
}

#pragma mark - 字符串相关
- (BOOL)rh_isChineseCharacter {
    
    NSString *rules = @"^[\u4e00-\u9fa5]{0,}$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isEnglishOrNumbers {
    
    NSString *rules = @"^[A-Za-z0-9]+$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_limitinglength:(NSInteger)fistRange
                lastRange:(NSInteger)lastRange {
    
    NSString *rules = [NSString stringWithFormat:@"^.{%ld,%ld}$", (long)fistRange, (long)lastRange];
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkString:(NSInteger)length {
    
    NSString *rules = @"^[A-Za-z0-9]+$";
    
    if (self.length == length) {
        
        return [self rh_regularWithRule:rules];
    }
    
    return NO;
}

- (BOOL)rh_isLettersString {
    
    NSString *rules = @"^[A-Za-z]+$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isCapitalLetters {
    
    NSString *rules = @"^[A-Z]+$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isLowercaseLetters {
    
    NSString *rules = @"^[a-z]+$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isNumbersOrLettersOrLineString {
    
    NSString *rules = @"^[A-Za-z0-9_]+$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isChineseCharacterOrEnglishOrNumbersOrLineString {
    
    NSString *rules = @"^[\u4E00-\u9FA5A-Za-z0-9_]+$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isDoesSpecialCharactersString {
    
    NSString *rules = @"^[\u4E00-\u9FA5A-Za-z0-9]+$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isContainSpecialCharacterString {
    
    NSString *rules = @"[^%&',;=?$\x22]+";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isContainCharacter:(NSString *)charater{
    
    NSString *rules = [NSString stringWithFormat:@"[^%@\x22]+", charater];
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_isLetterStar {
    
    NSString *rules = @"^[a-zA-Z][a-zA-Z0-9_]*$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkStringIsStrong {
    
    NSString *rules = @"^\\w*(?=\\w*\\d)(?=\\w*[a-zA-Z])\\w*$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkChineseCharacter {
    
    NSString *rules = @"[\u4e00-\u9fa5]";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkDoubleByteCharacters {
    
    NSString *rules = @"[^\\x00-\\xff]";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkBlankLines {
    
    NSString *rules = @"\\n\\s*\\r";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkFirstAndLastSpaceCharacters {
    
    NSString *rules = @"(^\\s*)|(\\s*$)";//@"^\\s*|\\s*$";
    
    return [self rh_regularWithRule:rules];
}

#pragma mark - 号码相关
- (BOOL)rh_checkPhoneNumber {
    
    /**
     * 手机号码:
     * 13[0-9], 14[0-1,4-9], 15[0, 1, 2, 3, 5, 6, 7, 8, 9],16[2567], 17[0,1,2,,3,5,6, 7, 8], 18[0-9], 19[0-35-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[0-1,4-9]|5[0-3,5-9]|6[2567]|17[0-3,5-8]|18[0-9]|19[0-3,5-9])\\d{8}$";
    
    return [self rh_regularWithRule:MOBILE] ||
    [self rh_checkChinaMobelPhoneNumber] ||
    [self rh_checkChinaUnicomPhoneNumber] ||
    [self rh_checkChinaTelecomPhoneNumber];
}

- (BOOL)rh_checkChinaMobelPhoneNumber {
    
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *rules = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkChinaUnicomPhoneNumber {
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *rules = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkChinaTelecomPhoneNumber {
    
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *rules = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkTelePhoneNumber {
    
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    NSString *rules = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkFormatTelePhoneNumber {
    
    NSString *rules = @"^\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{7}|\\d{4}-\\d{8}";
    
    return [self rh_regularWithRule:rules];
}

#pragma mark - 身份证相关
- (BOOL)rh_checkIdentityCard {
    
    NSString *rules = @"^\\d{15}|\\d{18}$|^([0-9]){7,18}(x|X)?$";
    
    return [self rh_regularWithRule:rules];
}

#pragma mark - 账号相关
- (BOOL)rh_checkAccount {
    
    NSString *rules = @"^[a-zA-Z][a-zA-Z0-9_]{4,15}$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkPassword {
    
    NSString *rules = @"^[a-zA-Z]\\w{5,17}$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkStrongPassword:(NSInteger)briefest
                       longest:(NSInteger)longest {
    
    NSString *rules = [NSString stringWithFormat:@"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{%ld,%ld}$", (long)briefest, (long)longest];
    
    return [self rh_regularWithRule:rules];
}

+ (BOOL)rh_checkStrong4Password:(NSString *)password briefest:(NSInteger)briefest
                    longest:(NSInteger)longest {
    if (password.length < briefest || password.length > longest) {
        return NO;
    }
    //大写字母
    NSString *capitalLetterRegex = @"^(?=.*[A-Z]).*$";
    NSPredicate * capPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", capitalLetterRegex];
    //匹配小写字母
    NSString *lowerLetterRegex = @"^(?=.*[a-z]).*$";
    NSPredicate * lowPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", lowerLetterRegex];
    //匹配数字
    NSString *numberRegex = @"^(?=.*\\d).*$";
    NSPredicate * numRred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    //匹配特殊字符
    NSString *functuationRegex = @"^(?=.*[`~!@#$%^&*()\\-_=+\\|[{}];:'\",<.>/? ]).*$";
    NSPredicate * funcPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", functuationRegex];
    
    int passwordComplex = 0;
    passwordComplex += [capPred evaluateWithObject:password] ? 1 : 0;
    passwordComplex += [lowPred evaluateWithObject:password] ? 1 : 0;
    passwordComplex += [numRred evaluateWithObject:password] ? 1 : 0;
    passwordComplex += [funcPred evaluateWithObject:password] ? 1 : 0;
    
    if (passwordComplex < 3) {
        return NO;
    }
    
    return YES;
}

- (BOOL)rh_checkForcePassword:(NSInteger)briefest
                      longest:(NSInteger)longest {
    NSString *rules = [NSString stringWithFormat:@"^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[\\W_!@#$%^&*`~()-+=]).{%ld,%ld}$", (long)briefest, (long)longest];
    
    return [self rh_regularWithRule:rules];
}

#pragma mark - 日期相关
- (BOOL)rh_checkChinaDateFormat {
    
    NSString *rules = @"^\\d{4}-\\d{1,2}-\\d{1,2}";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkAbroadDateFormat {
    
    NSString *rules = @"^\\d{1,2}-\\d{1,2}-\\d{4}";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkMonth {
    
    NSString *rules = @"^(0?[1-9]|1[0-2])$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkDay {
    
    NSString *rules = @"^((0?[1-9])|((1|2)[0-9])|30|31)$";
    
    return [self rh_regularWithRule:rules];
}

#pragma mark - 特殊正则
- (BOOL)rh_checkEmailAddress {
    
    NSString *rules = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkDomainName {
    
    NSString *rules = @"[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(/.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+/.?";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkURL {
    
    NSString *rules = @"[a-zA-z]+://[^\\s]*";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkXMLFile {
    
    NSString *rules = @"^([a-zA-Z]+-?)+[a-zA-Z0-9]+\\.[x|X][m|M][l|L]$";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkHTMLSign {
    
    NSString *rules = @"<(\\S*?)[^>]*>.*?</\\1>|<.*? />";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkQQNumber {
    
    NSString *rules = @"[1-9][0-9]{4}";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkPostalCode {
    
    NSString *rules = @"[1-9]\\d{5}(?!\\d)";
    
    return [self rh_regularWithRule:rules];
}

- (BOOL)rh_checkIPv4InternetProtocol {
    
    NSString *rules = @"((?:(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d))";
    
    return [self rh_regularWithRule:rules];
}

#pragma mark - Rule Method
- (BOOL)rh_regularWithRule:(NSString *)rule {
    
    NSPredicate *stringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule];
    
    return [stringPredicate evaluateWithObject:self];
}

@end
