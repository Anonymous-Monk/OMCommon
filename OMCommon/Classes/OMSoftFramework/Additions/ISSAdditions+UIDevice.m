#import "ISSAdditions+UIDevice.h"
#import <sys/sysctl.h>

@implementation UIDevice (ISSCategory)

- (NSString *)systemInfoByName:(char *)typeSpecifier {
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
    free(answer);
    return results;
}

/// 设备列表：http://support.hockeyapp.net/kb/client-integration-ios-mac-os-x/ios-device-types
- (iPhoneDeviceType)iPhoneDeviceType {
    NSString *machine = [self systemInfoByName:"hw.machine"];
    if ([machine hasPrefix:@"iPhone3"]) {
        return iPhoneDeviceTypeIPhone4;
    } else if ([machine hasPrefix:@"iPhone4"]) {
        return iPhoneDeviceTypeIPhone4S;
    } else if ([machine isEqualToString:@"iPhone5,1"] || [machine isEqualToString:@"iPhone5,2"]) {
        return iPhoneDeviceTypeIPhone5;
    } else if ([machine isEqualToString:@"iPhone5,3"] || [machine isEqualToString:@"iPhone5,4"]) {
        return iPhoneDeviceTypeIPhone5C;
    } else if ([machine hasPrefix:@"iPhone6"]) {
        return iPhoneDeviceTypeIPhone5S;
    } else if ([machine isEqualToString:@"iPhone7,2"]) {
        return iPhoneDeviceTypeIPhone6;
    } else if ([machine isEqualToString:@"iPhone7,1"]) {
        return iPhoneDeviceTypeIPhone6P;
    } else if ([machine isEqualToString:@"iPhone8,1"]) {
        return iPhoneDeviceTypeIPhone6S;
    } else if ([machine isEqualToString:@"iPhone8,2"]) {
        return iPhoneDeviceTypeIPhone6SP;
    } else if ([machine isEqualToString:@"iPhone8,4"]) {
        return iPhoneDeviceTypeIPhoneSE;
    } else if ([machine isEqualToString:@"iPhone9,1"] || [machine isEqualToString:@"iPhone9,3"]) {
        return iPhoneDeviceTypeIPhone7;
    } else if ([machine isEqualToString:@"iPhone9,2"] || [machine isEqualToString:@"iPhone9,4"]) {
        return iPhoneDeviceTypeIPhone7P;
    }
    return iPhoneDeviceTypeUnknown;
}
@end
