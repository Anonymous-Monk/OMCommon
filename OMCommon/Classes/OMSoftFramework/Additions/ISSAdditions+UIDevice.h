#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, iPhoneDeviceType) {
    iPhoneDeviceTypeIPhone4,
    iPhoneDeviceTypeIPhone4S,
    iPhoneDeviceTypeIPhone5,
    iPhoneDeviceTypeIPhone5C,
    iPhoneDeviceTypeIPhone5S,
    iPhoneDeviceTypeIPhone6,
    iPhoneDeviceTypeIPhone6P,
    iPhoneDeviceTypeIPhone6S,
    iPhoneDeviceTypeIPhone6SP,
    iPhoneDeviceTypeIPhoneSE,
    iPhoneDeviceTypeIPhone7,
    iPhoneDeviceTypeIPhone7P,
    iPhoneDeviceTypeUnknown
};

@interface UIDevice (ISSCategory)

- (iPhoneDeviceType)iPhoneDeviceType;

@end
