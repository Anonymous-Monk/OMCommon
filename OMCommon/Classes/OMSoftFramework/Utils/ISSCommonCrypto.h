//
//  ISSCommonCryptor.h
//  oumaSoftFramework
//
//  Created by Paperman on 17/5/8.
//  Copyright © 2017年 Paperman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISSCommonCrypto : NSObject

+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;

+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;

+ (NSData *)DESEncryptUsingBase64FromString:(NSString *)string;

+ (NSString *)DESDecryptUsingBase64FromData:(NSData *)data;

@end
