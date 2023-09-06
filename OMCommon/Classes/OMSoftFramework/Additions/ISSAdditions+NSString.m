#import "ISSAdditions+NSString.h"
#import <CommonCrypto/CommonDigest.h>

inline NSString * FileMD5(NSString *filePath) {
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;

    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,(CFStringRef)filePath,kCFURLPOSIXPathStyle,(Boolean)false);

    if (!fileURL) goto done;

    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,(CFURLRef)fileURL);

    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;

    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);

    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[4096];
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }

    // Check if the read operation succeeded
    didSucceed = !hasMoreData;

    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);

    // Abort if the read operation failed
    if (!didSucceed) goto done;

    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);

done:

    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }

    return (__bridge NSString *)result;
}

inline NSString * MD5(NSString *inStr) {
    const char* str = [inStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (uint32_t)strlen(str), result);
    NSMutableString *md5 = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5 appendFormat:@"%02X",result[i]];
    }
    return md5;
}

@implementation NSString (ISSCategory)

+ (NSString *)stringWithColor:(UIColor *)color
{
    const CGFloat *colors = CGColorGetComponents(color.CGColor);
    NSString *alpha, *red, *blue, *green;
    switch (CGColorGetNumberOfComponents(color.CGColor)) {
        case 2:
            red   = [NSString stringWithFormat:@"%@", [NSString intValueToHex:colors[0]]];
            green = [NSString stringWithFormat:@"%@", [NSString intValueToHex:colors[0]]];
            blue  = [NSString stringWithFormat:@"%@", [NSString intValueToHex:colors[0]]];
            alpha = [NSString stringWithFormat:@"%@", [NSString intValueToHex:colors[1]]];
            break;
        case 4:
            red   = [NSString stringWithFormat:@"%@", [NSString intValueToHex:colors[0]]];
            green = [NSString stringWithFormat:@"%@", [NSString intValueToHex:colors[1]]];
            blue  = [NSString stringWithFormat:@"%@", [NSString intValueToHex:colors[2]]];
            alpha = [NSString stringWithFormat:@"%@", [NSString intValueToHex:colors[3]]];
            break;
    }
    return [NSString stringWithFormat:@"#%@%@%@%@", alpha, red, green, blue];
}

+ (NSString *)intValueToHex:(int)intValue
{
    intValue = intValue * 255;
    NSString *result = [[NSString alloc] init];
    for (NSNumber *value in @[@(intValue/16), @(intValue%16)])
    {
        switch ([value intValue])
        {
            case 10:
                result = [result stringByAppendingString:@"A"];
                break;
            case 11:
                result = [result stringByAppendingString:@"B"];
                break;
            case 12:
                result = [result stringByAppendingString:@"C"];
                break;
            case 13:
                result = [result stringByAppendingString:@"D"];
                break;
            case 14:
                result = [result stringByAppendingString:@"E"];
                break;
            case 15:
                result = [result stringByAppendingString:@"F"];
                break;
            default:
                result = [result stringByAppendingFormat:@"%i", intValue];
                break;
        }
    }
    return result;
}

- (BOOL)isMobileNumber
{
    NSString *pattern = @"^1\\d{10}$";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange range = [regex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    return !NSEqualRanges(range, NSMakeRange(NSNotFound, 0));
}

- (NSUInteger)byteLength
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self lengthOfBytesUsingEncoding:encoding];
}
@end
