//
//  NSString+RHString.h
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (RHString)

#pragma mark - 字符串处理
/**
 返回过滤后的数字
 
 @param string 字符串
 @return 数字
 */
+ (NSString *)rh_getNumberWithString:(NSString *)string;

/**
返回小数点后几位

 @param decimals 字符串
@return 数字
*/
- (NSString *)decimals:(int)decimals;

/**
 隐藏电话号码中间4位数字
 
 @param phoneNumber 手机号
 @return 隐藏后的手机号
 */
+ (NSString *)rh_getSecrectStringWithPhoneNumber:(NSString *)phoneNumber;

/**
 隐藏银行卡号中间8位数字
 
 @param cardNumber 银行卡号
 @return 隐藏后的银行卡号
 */
+ (NSString *)rh_getSecrectStringWithCardNumber:(NSString *)cardNumber;

/**
 根据条件计算文字的高度
 
 @param fontSize 字体大小
 @param width 宽度
 @return CGFloat
 */
- (CGFloat)rh_heightWithFontSize:(CGFloat)fontSize
                           width:(CGFloat)width;

/**
 抹除运费小数末尾的0
 
 @return NSString
 */
- (NSString *)rh_removeUnwantedZero;

/**
 去掉字符串前后的空格
 
 @return NSString
 */
- (NSString *)rh_trimmedString;

/**
 去除指定的字符
 
 @param character 指定的字符
 @return NSString
 */
- (NSString *)rh_removeStringCharacterWithCharacter:(NSString *)character;

/**
 手机号格式化, 默认: 138 0013 8000
 
 @param phoneNumber 手机号
 @return NSString
 */
+ (NSString *)rh_stringMobileFormat:(NSString *)phoneNumber;

/**
 手机号格式化
 
 @param phoneNumber 手机号
 @param separator 号码分隔符, 比如: 138-0013-8000
 @return NSString
 */
+ (NSString *)rh_stringMobileFormat:(NSString *)phoneNumber
                          separator:(NSString *)separator;

/**
 字符串单位格式化
 
 @param value 数值
 @param unitString 单位, 比如亿, 万
 @return NSString
 */
+ (NSString *)rh_stringUnitFormat:(CGFloat)value
                       unitString:(NSString *)unitString;

/**
 单位处理
 
 @param string 待处理的字符串
 @param integer 0（万、亿） intergaer（2百3千4万...8亿...）
 @return 转换后的字符串
 */
+ (NSString *)rh_getDealNumwithstring:(NSString *)string withNumCount:(NSInteger)integer;

/**
 文件大小转换
 
 @param value 数值大小
 @return 处理后的文件大小
 */
+ (NSString *)rh_transformedFileSizeValue:(id)value;

/**
 文件大小转换
 
 @param value 数值大小
 @param unit 转换单位 1024 1000
 @return 处理后的文件大小
 */
+ (NSString *)rh_transformedFileSizeValue:(id)value unit:(int)unit;

//每隔4个字符添加一个空格的字符串算法
+ (NSString *)rh_dealWithString:(NSString *)number;


/**
 获取指定字符串的尺寸
 
 @param string 字符串
 @param font 字体
 @return CGFloat
 */
+ (CGSize)rh_measureStringSizeWithString:(NSString *)string
                                    font:(UIFont *)font;

/**
 获取指定字符串的宽度
 
 @param string 字符串
 @param font 字体
 @return CGFloat
 */
+ (CGFloat)rh_measureSingleLineStringWidthWithString:(NSString *)string
                                                font:(UIFont *)font;

/**
 获取指定字符串的高度
 
 @param string 字符串
 @param font 字体
 @param width 宽度
 @return CGFloat
 */
+ (CGFloat)rh_measureHeightWithMutilineString:(NSString *)string
                                         font:(UIFont *)font
                                        width:(CGFloat)width;

/**
 将指定的NSDictionary转成URL字符串
 
 @param dictionary NSDictionary
 @return NSString
 */
+ (NSString *)rh_urlQueryStringWithDictionary:(NSDictionary *)dictionary;

/**
 将指定的NSObject转成JSON字符串
 
 @param object NSArray || NSDictionary || NSObject
 @return NSString
 */
+ (NSString *)rh_jsonStringWithObject:(NSObject *)object;

/**
 判断字符串是否为空
 
 @param string 字符串
 @return BOOL, YES为空, NO不为空
 */
+ (BOOL)rh_checkEmptyWithString:(NSString *)string;

#pragma mark - 加密字符串方法
/**
 将data数据转成Base64字符串
 
 @param data data对象
 @param length NSUInteger
 @return NSString
 */
+ (NSString *)rh_base64StringFromData:(NSData *)data
                               length:(NSUInteger)length;

/**
 将指定的字符串加密成Base64
 
 @param string NSString
 @return NSString
 */
+ (NSString *)rh_encodingBase64WithString:(NSString *)string;

/**
 将指定的加密的Base64字符串解码
 
 @param string NSString
 @return NSString
 */
+ (NSString *)rh_decodedBase64WithString:(NSString *)string;

/**
 加密成MD5字符串
 
 @return NSString
 */
+ (NSString *)rh_encodingMD5WithString:(NSString *)string;

#pragma mark - NSString获取首字母
/**
 获取字符串的首个字符
 
 @param string NSString
 @return NSString
 */
+ (NSString *)rh_getFirstCharactorWithString:(NSString *)string;

/**
 获取中文字符串首个拼音字母
 
 @param string NSString
 @return NSString
 */
+ (NSString *)rh_getFirstPinYinWithString:(NSString *)string;

#pragma mark - 正则表达式
#pragma mark - 数字字符判断
/**
 当前字符是否为数字
 
 @return BOOL
 */
- (BOOL)rh_realContainDecimal;

#pragma mark - 整数相关
/**
 当前字符是否为整数
 
 @return BOOL
 */
- (BOOL)rh_isNumber;

/**
 当前字符是否为number位的数字
 
 @param quantity 限制数字的数量
 @return BOOL
 */
- (BOOL)rh_checkMostNumber:(NSInteger)quantity;

/**
 当前字符是否为至少number位的数字
 
 @param quantity 至少数字的数量
 @return BOOL
 */
- (BOOL)rh_checkAtLeastNumber:(NSInteger)quantity;

/**
 当前字符是否为最少leastNumber个数字, 最多moreNumber个数字的
 
 @param leastNumber 最少
 @param mostNumber 最多
 @return BOOL
 */
- (BOOL)rh_checkLeastNumber:(NSInteger)leastNumber
                 mostNumber:(NSInteger)mostNumber;

/**
 当前字符是否为非零开头的数字
 
 @return BOOL
 */
- (BOOL)rh_isNotZeroStartNumber;


/**
 当前字符是否为非零的正整数
 
 @return BOOL
 */
- (BOOL)rh_isNotZeroPositiveInteger;


/**
 当前字符是否为非零的负整数
 
 @return BOOL
 */
- (BOOL)rh_isNotZeroNegativeInteger;

/**
 当前字符是否为正整数
 
 @return BOOL
 */
- (BOOL)rh_isPositiveInteger;

/**
 当前字符是否为负整数
 
 @return BOOL
 */
- (BOOL)rh_isNegativeInteger;

#pragma mark - 浮点数相关
/**
 当前字符是否为浮点数
 
 @return BOOL
 */
- (BOOL)rh_isFloat;

/**
 当前字符是否为正浮点数
 
 @return BOOL
 */
- (BOOL)rh_isPositiveFloat;

/**
 当前字符是否为负浮点数
 
 @return BOOL
 */
- (BOOL)rh_isNagativeFloat;

/**
 当前字符是否为非零开头的最多带两位小数的数字
 
 @return BOOL
 */
- (BOOL)rh_isNotZeroStartNumberHaveOneOrTwoDecimal;

/**
 当前字符是否为带1-2位小数的正数或负数
 
 @return BOOL
 */
- (BOOL)rh_isHaveOneOrTwoDecimalPositiveOrNegative;

/**
 当前字符是否为有两位小数的正实数
 
 @return BOOL
 */
- (BOOL)rh_isPositiveRealHaveTwoDecimal;

/**
 当前字符是否为有1~3位小数的正实数
 
 @return BOOL
 */
- (BOOL)rh_isHaveOneOrThreeDecimalPositiveOrNegative;

#pragma mark - 字符串相关
/**
 当前字符是否为汉字
 
 @return BOOL
 */
- (BOOL)rh_isChineseCharacter;

/**
 当前字符是否为由数字或26个英文字母组成的字符串
 
 @return BOOL
 */
- (BOOL)rh_isEnglishOrNumbers;

/**
 当前字符是否为 长度为3-20的所有字符
 
 @param fistRange 开始的范围
 @param lastRange 结束的范围
 @return BOOL
 */
- (BOOL)rh_limitinglength:(NSInteger)fistRange
                lastRange:(NSInteger)lastRange;

/**
 当前字符长度是否位 length, 并且是由字母或数字所组成
 
 @param length length 字符的长度
 @return BOOL
 */
- (BOOL)rh_checkString:(NSInteger)length;

/**
 当前字符是否为由26个英文字母组成的字符串
 
 @return BOOL
 */
- (BOOL)rh_isLettersString;

/**
 当前字符是否为由26个大写英文字母组成的字符串
 
 @return BOOL
 */
- (BOOL)rh_isCapitalLetters;

/**
 当前字符是否为由26个小写英文字母组成的字符串
 
 @return BOOL
 */
- (BOOL)rh_isLowercaseLetters;

/**
 当前字符是否为由数字、26个英文字母或者下划线组成的字符串
 
 @return BOOL
 */
- (BOOL)rh_isNumbersOrLettersOrLineString;

/**
 当前字符是否为中文、英文、数字或者下划线
 
 @return BOOL
 */
- (BOOL)rh_isChineseCharacterOrEnglishOrNumbersOrLineString;

/**
 当前字符是否为中文、英文、数字但不包括特殊符号
 
 @return BOOL
 */
- (BOOL)rh_isDoesSpecialCharactersString;

/**
 当前字符是否可以输入含有^%&',;=?$\"等字符
 
 @return BOOL
 */
- (BOOL)rh_isContainSpecialCharacterString;

/**
 当前字符是否禁止输入 含有charater的字符
 
 @param charater 输入限制的字符
 @return BOOL
 */
- (BOOL)rh_isContainCharacter:(NSString *)charater;

/**
 *  判断当前字符串是否是字母开头
 *
 *  @return BOOL
 */
- (BOOL)rh_isLetterStar;

/**
 *  判断当前字符串是否是字母, 数字及下划线的强组合
 *
 *  @return BOOL
 */
- (BOOL)rh_checkStringIsStrong;

/**
 当前字符是否为中文字符的正则表达式
 
 @return BOOL
 */
- (BOOL)rh_checkChineseCharacter;

/**
 当前字符是否为双字节字符：(包括汉字在内，可以用来计算字符串的长度(一个双字节字符长度计2，ASCII字符计1))
 
 @return BOOL
 */
- (BOOL)rh_checkDoubleByteCharacters;

/**
 当前字符是否为空白行的正则表达式：(判断是否有空白行)
 
 @return BOOL
 */
- (BOOL)rh_checkBlankLines;

/**
 当前字符是否为首尾空白字符的正则表达式：(可以用来删除行首行尾的空白字符(包括空格、制表符、换页符等等)，非常有用的表达式)
 
 @return BOOL
 */
- (BOOL)rh_checkFirstAndLastSpaceCharacters;

#pragma mark - 号码相关
/**
 当前字符是否为手机号码
 
 @return BOOL
 */
- (BOOL)rh_checkPhoneNumber;

/**
 当前字符是否为中国移动手机号
 
 @return BOOL
 */
- (BOOL)rh_checkChinaMobelPhoneNumber;

/**
 当前字符是否为中国联通手机号
 
 @return BOOL
 */
- (BOOL)rh_checkChinaUnicomPhoneNumber;

/**
 当前字符是否为中国电信手机号
 
 @return BOOL
 */
- (BOOL)rh_checkChinaTelecomPhoneNumber;

/**
 当前字符是否为 电话号码("0101234567"、"075512345678"、"01012345678")
 
 @return BOOL
 */
- (BOOL)rh_checkTelePhoneNumber;

/**
 当前字符是否为 格式化国内电话号码(0511-4405222、021-87888822)
 
 @return BOOL
 */
- (BOOL)rh_checkFormatTelePhoneNumber;

#pragma mark - 身份证相关
/**
 当前字符是否为身份证号(15位、18位数字)
 
 @return BOOL
 */
- (BOOL)rh_checkIdentityCard;

#pragma mark - 账号相关
/**
 当前字符是否为帐号是否是字母开头，最少5位最多16位，且是字母数字下划线组成
 
 @return BOOL
 */
- (BOOL)rh_checkAccount;

/**
 当前字符是否以字母开头，长度在6~18之间, 并且密码是从0开始，只能包含字母、数字和下划线的密码
 
 @return BOOL
 */
- (BOOL)rh_checkPassword;

/**
 当前字符是否为强密码(必须包含大小写字母和数字的组合，不能使用特殊字符，长度在8-10之间)：briefest指的是最短密码长度, longest指的时最长密码长度
 
 @param briefest 密码最短的长度
 @param longest 密码最长的长度
 @return BOOL
 */
- (BOOL)rh_checkStrongPassword:(NSInteger)briefest
                       longest:(NSInteger)longest;

/** 校验强密码 字母（大小写）、数字 符号 （4选3）
 *  briefest下限briefest上限
 */
+ (BOOL)rh_checkStrong4Password:(NSString *)password briefest:(NSInteger)briefest
                        longest:(NSInteger)longest;

/**
 当前字符是否为强密码(必须包含字母（区分大小写），数字和符号的组合，长度在8-10之间)：briefest指的是最短密码长度, longest指的时最长密码长度
 
 @param briefest 密码最短的长度
 @param longest 密码最长的长度
 @return BOOL
 */
- (BOOL)rh_checkForcePassword:(NSInteger)briefest
                       longest:(NSInteger)longest;

#pragma mark - 日期相关
/**
 当前字符是否为中国日期格式
 
 @return BOOL
 */
- (BOOL)rh_checkChinaDateFormat;

/**
 当前字符是否为国外日期格式
 
 @return BOOL
 */
- (BOOL)rh_checkAbroadDateFormat;

/**
 当前字符是否为一年的12个月(01～09和1～12)
 
 @return BOOL
 */
- (BOOL)rh_checkMonth;

/**
 当前字符是否为一个月的31天(01～09和1～31)
 
 @return BOOL
 */
- (BOOL)rh_checkDay;

#pragma mark - 特殊正则
/**
 当前字符是否为 Email地址
 
 @return BOOL
 */
- (BOOL)rh_checkEmailAddress;

/**
 当前字符是否为域名
 
 @return BOOL
 */
- (BOOL)rh_checkDomainName;

/**
 当前字符是否为Internet URL
 
 @return BOOL
 */
- (BOOL)rh_checkURL;

/**
 当前字符是否为xml文件
 
 @return BOOL
 */
- (BOOL)rh_checkXMLFile;

/**
 当前字符是否为HTML标记的正则表达式：(网上流传的版本太糟糕，上面这个也仅仅能部分，对于复杂的嵌套标记依旧无能为力)
 
 @return BOOL
 */
- (BOOL)rh_checkHTMLSign;

/**
 当前字符是否为腾讯QQ号：(腾讯QQ号从10000开始)
 
 @return BOOL
 */
- (BOOL)rh_checkQQNumber;

/**
 当前字符是否为中国邮政编码：(中国邮政编码为6位数字)
 
 @return BOOL
 */
- (BOOL)rh_checkPostalCode;

/**
 当前字符是否为IPv4地址
 
 @return BOOL
 */
- (BOOL)rh_checkIPv4InternetProtocol;

/**
 自定义正则
 
 @param rule 正则规则
 @return BOOL
 */
- (BOOL)rh_regularWithRule:(NSString *)rule;

@end
