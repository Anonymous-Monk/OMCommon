//
//  ISSPickerView.h
//  oumaSoftiPhone
//
//  Created by Paperman on 17/1/21.
//
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN CGFloat const ISSPickerViewHeight;

@class ISSLayerPickerView;
@protocol ISSPickerViewDelegate <NSObject>
@optional
- (void)pickerView:(ISSLayerPickerView *)pickerView didSelectItemAtTitle:(NSString *)title;
@end

typedef void(^ISSPickerViewCallback)(ISSLayerPickerView *pickerView, NSString *title);

@interface ISSLayerPickerView : UIView

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)initWithDelegate:(nullable id<ISSPickerViewDelegate>)delegate buttonTitles:(NSString *)menuItems, ... NS_REQUIRES_NIL_TERMINATION;

@property (nullable, nonatomic, weak) id<ISSPickerViewDelegate> delegate;
- (void)setPickerViewCallback:(ISSPickerViewCallback)callback;

- (NSInteger)addPickerItem:(__kindof NSString *)item;
- (NSString *)pickerItemAtIndex:(NSInteger)buttonIndex;

- (void)show;

- (void)dismiss;

@end
NS_ASSUME_NONNULL_END
