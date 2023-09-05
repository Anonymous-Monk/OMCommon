//
//  NSData+RHData.m
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import "NSData+RHData.h"
#import "NSString+RHString.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (RHData)

+ (NSData *)rh_compressOriginalImage:(UIImage *)image
                  compressionQuality:(CGFloat)compressionQuality {
    
    NSData *rh_data = UIImageJPEGRepresentation(image, compressionQuality);
    
    CGFloat rh_dataKBytes = rh_data.length / 1000.0;
    CGFloat rh_maxQuality = 0.9f;
    CGFloat rh_lastData   = rh_dataKBytes;
    
    while (rh_dataKBytes > compressionQuality && rh_maxQuality > 0.01f) {
        
        rh_maxQuality = rh_maxQuality - 0.01f;
        
        rh_data = UIImageJPEGRepresentation(image, rh_maxQuality);
        
        rh_dataKBytes = rh_data.length / 1000.0;
        
        if (rh_lastData == rh_dataKBytes) {
            
            break;
            
        } else {
            
            rh_lastData = rh_dataKBytes;
        }
    }
    
    return rh_data;
}

+ (NSString *)rh_replacingAPNsTokenWithData:(NSData *)data {
    
    NSString *rh_replacingStringOne   = [[data description] stringByReplacingOccurrencesOfString:@"<" withString: @""];
    NSString *rh_replacingStringTwo   = [rh_replacingStringOne stringByReplacingOccurrencesOfString: @">" withString: @""];
    NSString *rh_replacingStringThree = [rh_replacingStringTwo stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    return rh_replacingStringThree;
}

#pragma mark - Base 64
+ (NSData *)rh_transformDataWithBase64EncodedString:(NSString *)string {
    
    if ([NSString rh_checkEmptyWithString:string]) {
        
        return nil;
    }
    
    NSData *rh_decodedData = [[NSData alloc] initWithBase64EncodedString:string
                                                                 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [rh_decodedData length] ? rh_decodedData: nil;
}

+ (NSString *)rh_transformBase64EncodedStringWithData:(NSData *)data
                                            wrapWidth:(RHDataBaseType)wrapWidth {
    
    if (![data length]) {
        
        return nil;
    }
    
    NSString *rh_dataEncodedString = nil;
    
    switch (wrapWidth) {
        case CLDataBaseType64: {
            
            return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        } case CLDataBaseType76: {
            
            return [data base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
            
        } default: {
            
            rh_dataEncodedString = [data base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
        }
    }
    
    if (!wrapWidth || wrapWidth >= [rh_dataEncodedString length]) {
        
        return rh_dataEncodedString;
    }
    
    wrapWidth = (wrapWidth / 4) * 4;
    
    NSMutableString *rh_resultString = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [rh_dataEncodedString length]; i+= wrapWidth) {
        
        if (i + wrapWidth >= [rh_dataEncodedString length]) {
            
            [rh_resultString appendString:[rh_dataEncodedString substringFromIndex:i]];
            
            break;
        }
        
        [rh_resultString appendString:[rh_dataEncodedString
                                       substringWithRange:NSMakeRange(i, wrapWidth)]];
        
        [rh_resultString appendString:@"\r\n"];
    }
    
    return rh_resultString;
}

#pragma mark - AES
- (NSData *)rh_encryptedDataWithAESKey:(NSString *)key
                           encryptData:(NSData *)encryptData {
    
    NSData *rh_keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t rh_dataMoved;
    NSMutableData *rh_encryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSizeAES128];
    
    CCCryptorStatus rh_cryptorStatus = CCCrypt(kCCEncrypt,
                                               kCCAlgorithmAES128,
                                               kCCOptionPKCS7Padding,
                                               rh_keyData.bytes,
                                               rh_keyData.length,
                                               encryptData.bytes,
                                               self.bytes,
                                               self.length,
                                               rh_encryptedData.mutableBytes,
                                               rh_encryptedData.length,
                                               &rh_dataMoved);
    
    if (rh_cryptorStatus == kCCSuccess) {
        
        rh_encryptedData.length = rh_dataMoved;
        
        return rh_encryptedData;
    }
    
    return nil;
}

- (NSData *)rh_decryptedDataWithAESKey:(NSString *)key
                           decryptData:(NSData *)decryptData {
    
    NSData *rh_keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t rh_dataMoved;
    
    NSMutableData *rh_decryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSizeAES128];
    
    CCCryptorStatus rh_cryptorStatus = CCCrypt(kCCDecrypt,
                                               kCCAlgorithmAES128,
                                               kCCOptionPKCS7Padding,
                                               rh_keyData.bytes,
                                               rh_keyData.length,
                                               decryptData.bytes,
                                               self.bytes,
                                               self.length,
                                               rh_decryptedData.mutableBytes,
                                               rh_decryptedData.length,
                                               &rh_dataMoved);
    
    if (rh_cryptorStatus == kCCSuccess) {
        
        rh_decryptedData.length = rh_dataMoved;
        
        return rh_decryptedData;
    }
    
    return nil;
}

#pragma mark - 3DES
- (NSData *)rh_encryptedDataWith3DESKey:(NSString *)key
                            encryptData:(NSData *)encryptData {
    
    NSData *rh_keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t rh_dataMoved;
    NSMutableData *rh_encryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSize3DES];
    
    CCCryptorStatus rh_cryptorStatus = CCCrypt(kCCEncrypt,
                                               kCCAlgorithm3DES,
                                               kCCOptionPKCS7Padding,
                                               rh_keyData.bytes,
                                               rh_keyData.length,
                                               encryptData.bytes,
                                               self.bytes,
                                               self.length,
                                               rh_encryptedData.mutableBytes,
                                               rh_encryptedData.length,
                                               &rh_dataMoved);
    
    if (rh_cryptorStatus == kCCSuccess) {
        
        rh_encryptedData.length = rh_dataMoved;
        
        return rh_encryptedData;
    }
    
    return nil;
}

- (NSData *)rh_decryptedDataWith3DEKey:(NSString *)key
                           decryptData:(NSData *)decryptData {
    
    NSData *rh_keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t rh_dataMoved;
    
    NSMutableData *rh_decryptedData = [NSMutableData dataWithLength:self.length + kCCBlockSize3DES];
    
    CCCryptorStatus rh_cryptorStatus = CCCrypt(kCCDecrypt,
                                               kCCAlgorithm3DES,
                                               kCCOptionPKCS7Padding,
                                               rh_keyData.bytes,
                                               rh_keyData.length,
                                               decryptData.bytes,
                                               self.bytes,
                                               self.length,
                                               rh_decryptedData.mutableBytes,
                                               rh_decryptedData.length,
                                               &rh_dataMoved);
    
    if (rh_cryptorStatus == kCCSuccess) {
        
        rh_decryptedData.length = rh_dataMoved;
        
        return rh_decryptedData;
    }
    
    return nil;
}

@end
