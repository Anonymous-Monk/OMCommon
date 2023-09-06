#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * FileMD5(NSString *filePath);
extern NSString * MD5(NSString *inStr);

@interface NSString (ISSCategory)

+ (NSString *)stringWithColor:(UIColor *)color;

- (BOOL)isMobileNumber;

- (NSUInteger)byteLength;

@end
