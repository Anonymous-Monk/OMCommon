//
//  UILabel+RHAdd.m
//  MXSKit
//
//  Created by zero on 2022/3/5.
//

#import "UILabel+RHAdd.h"

@implementation UILabel (RHAdd)

+ (void)rh_changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

+ (void)rh_changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

+ (void)rh_changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}

+ (void)rh_setAttributedString:(UILabel *)attLabel withRangeOfString:(NSString *)rangOfString withValue:(UIColor *)color value:(UIFont *)font {
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:attLabel.text];
    [attribute addAttributes:@{NSForegroundColorAttributeName: attLabel.textColor} range:NSMakeRange(0, attLabel.text.length)];
    [attribute addAttribute:NSForegroundColorAttributeName value:color range:[attLabel.text rangeOfString:rangOfString]];
    [attribute addAttribute:NSFontAttributeName value:font range:[attLabel.text rangeOfString:rangOfString]];
    attLabel.attributedText = attribute;
}

+ (void)rh_setAttributedString:(UILabel *)attLabel withRangeOfString:(NSString *)rangOfString withValue:(UIColor *)color {
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:attLabel.text];
    [attribute addAttributes:@{NSForegroundColorAttributeName: attLabel.textColor} range:NSMakeRange(0, attLabel.text.length)];
    [attribute addAttribute:NSForegroundColorAttributeName value:color range:[attLabel.text rangeOfString:rangOfString]];
    attLabel.attributedText = attribute;
}

+ (void)rh_setAttributedLabel:(UILabel *)attLabel withRangeOfString:(NSString *)rangeString value:(UIFont *)font {
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:attLabel.text];
    [attribute addAttribute:NSFontAttributeName value:font range:[attLabel.text rangeOfString:rangeString]];
    attLabel.attributedText = attribute;
}

+ (void)rh_setAttributedCenterLineLabel:(UILabel *)attLabel {
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:attLabel.text attributes:attribtDic];
    // 赋值
    attLabel.attributedText = attribtStr;
}

+ (void)rh_setAttributedCenterLineLabel:(UILabel *)attLabel text:(NSString *)text {
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:attLabel.text];
    [attribtStr addAttributes:attribtDic range:[attLabel.text rangeOfString:text]];
    // 赋值
    attLabel.attributedText = attribtStr;
}

@end
