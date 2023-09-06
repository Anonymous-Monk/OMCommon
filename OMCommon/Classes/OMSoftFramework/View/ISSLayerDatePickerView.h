//
//  ISSDatePickerView.h
//  oumaSoftiPhone
//
//  Created by Paperman on 17/1/21.
//
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN CGFloat const ISSDatePickerViewHeight;

@class ISSLayerDatePickerView;
@protocol ISSDatePickerViewDelegate <NSObject>
@optional
- (void)datePickerView:(ISSLayerDatePickerView *)datePickerView didSelectDate:(NSDate *)date;
@end

typedef void(^ISSDatePickerViewCallback)(ISSLayerDatePickerView *datePickerView, NSDate *date);

@interface ISSLayerDatePickerView : UIView

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)initWithDelegate:(nullable id<ISSDatePickerViewDelegate>)delegate;

@property (nullable, nonatomic, weak) id<ISSDatePickerViewDelegate> delegate;
- (void)setDatePickerViewCallback:(ISSDatePickerViewCallback)callback;

@property (nullable, nonatomic, copy) NSDate *currentDate;

@property (nonatomic) UIDatePickerMode datePickerMode;

- (void)show;

- (void)dismiss;

@end
NS_ASSUME_NONNULL_END
