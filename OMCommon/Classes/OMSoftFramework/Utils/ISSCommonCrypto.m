//
//  ISSCommonCryptor.m
//  oumaSoftFramework
//
//  Created by Paperman on 17/5/8.
//  Copyright © 2017年 Paperman. All rights reserved.
//

#import "ISSCommonCrypto.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation ISSCommonCrypto

+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);

    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);

    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

+ (NSData *)DESEncryptUsingBase64FromString:(NSString *)string;
{
    NSString *key = [[NSBundle mainBundle] bundleIdentifier];
    NSData *UTF8Encoded = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [UTF8Encoded base64EncodedStringWithOptions:kNilOptions];
    NSData *base64Encode = [[NSData alloc] initWithBase64EncodedString:base64String options:kNilOptions];;
    NSData *DESEncrypt = [[self class] DESEncrypt:base64Encode WithKey:key];
    return DESEncrypt;
}

+ (NSString *)DESDecryptUsingBase64FromData:(NSData *)data;
{
    NSString *key = [[NSBundle mainBundle] bundleIdentifier];
    NSData *DESDecrypt = [[self class] DESDecrypt:data WithKey:key];
    NSString *base64Decoded = [[NSString alloc] initWithData:DESDecrypt encoding:NSUTF8StringEncoding];
    return base64Decoded;
}

@end
