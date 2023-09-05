//
//  NSMutableAttributedString+RHMutableAttributedString.m
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import "NSMutableAttributedString+RHMutableAttributedString.h"

@implementation NSMutableAttributedString (RHMutableAttributedString)

+ (NSMutableAttributedString *)rh_attributeStringWithSubffixString:(NSString *)subffixString
                                                      subffixImage:(UIImage *)subffixImage {
    
    NSMutableAttributedString *rh_mutableAttributedString = [[NSMutableAttributedString alloc] init];
    
    NSTextAttachment *rh_backAttachment = [[NSTextAttachment alloc] init];
    
    rh_backAttachment.image = subffixImage;
    rh_backAttachment.bounds = CGRectMake(0, -2, subffixImage.size.width, subffixImage.size.height);
    
    NSAttributedString *rh_backString = [NSAttributedString attributedStringWithAttachment:rh_backAttachment];
    NSAttributedString *rh_attributedString = [[NSAttributedString alloc] initWithString:subffixString];
    
    [rh_mutableAttributedString appendAttributedString:rh_backString];
    [rh_mutableAttributedString appendAttributedString:rh_attributedString];
    
    return rh_mutableAttributedString;
}

+ (NSMutableAttributedString *)rh_attributeStringWithSubffixString:(NSString *)subffixString
                                                     subffixImages:(NSArray<UIImage *> *)subffixImages {
    
    NSMutableAttributedString *rh_mutableAttributedString = [[NSMutableAttributedString alloc] init];
    
    [subffixImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSTextAttachment *rh_backAttachment = [[NSTextAttachment alloc] init];
        
        rh_backAttachment.image = obj;
        rh_backAttachment.bounds = CGRectMake(0, -2, obj.size.width, obj.size.height);
        
        NSAttributedString *rh_backString = [NSAttributedString attributedStringWithAttachment:rh_backAttachment];
        
        [rh_mutableAttributedString appendAttributedString:rh_backString];
    }];
    
    NSAttributedString *rh_attributedString = [[NSAttributedString alloc] initWithString:subffixString];
    
    [rh_mutableAttributedString appendAttributedString:rh_attributedString];
    
    return rh_mutableAttributedString;
}

+ (NSMutableAttributedString *)rh_attributeStringWithPrefixString:(NSString *)prefixString
                                                      prefixImage:(UIImage *)prefixImage {
    
    NSMutableAttributedString *rh_mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:prefixString];
    
    NSTextAttachment *rh_backAttachment = [[NSTextAttachment alloc] init];
    
    rh_backAttachment.image = prefixImage;
    rh_backAttachment.bounds = CGRectMake(0, -2, prefixImage.size.width, prefixImage.size.height);
    
    NSAttributedString *rh_backString = [NSAttributedString attributedStringWithAttachment:rh_backAttachment];
    
    [rh_mutableAttributedString appendAttributedString:rh_backString];
    
    return rh_mutableAttributedString;
}

+ (NSMutableAttributedString *)rh_attributeStringWithPrefixString:(NSString *)prefixString
                                                     prefixImages:(NSArray<UIImage *> *)prefixImages {
    
    NSMutableAttributedString *rh_mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:prefixString];
    
    [prefixImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSTextAttachment *rh_backAttachment = [[NSTextAttachment alloc] init];
        
        rh_backAttachment.image = obj;
        rh_backAttachment.bounds = CGRectMake(0, -2, obj.size.width, obj.size.height);
        
        NSAttributedString *rh_backString = [NSAttributedString attributedStringWithAttachment:rh_backAttachment];
        
        [rh_mutableAttributedString appendAttributedString:rh_backString];
    }];
    
    return rh_mutableAttributedString;
}

+ (NSMutableAttributedString *)rh_attributedStringWithString:(NSString *)string
                                                 lineSpacing:(CGFloat)lineSpacing {
    
    NSMutableAttributedString *rh_attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [rh_attributedString addAttribute:NSParagraphStyleAttributeName
                                value:paragraphStyle
                                range:NSMakeRange(0, [string length])];
    
    return rh_attributedString;
}

+ (NSMutableAttributedString *)rh_attributedStringWithAttributedString:(NSAttributedString *)attributedString
                                                           lineSpacing:(CGFloat)lineSpacing {
    
    NSMutableAttributedString *rh_attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:lineSpacing];
    
    [rh_attributedString addAttribute:NSParagraphStyleAttributeName
                                value:paragraphStyle
                                range:NSMakeRange(0, [attributedString length])];
    
    return rh_attributedString;
}

@end
