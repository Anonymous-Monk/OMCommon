//
//  ISSMonthPickerView.h
//  oumaSoftiPhone
//
//  Created by Paperman on 17/1/22.
//
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN CGFloat const ISSMonthPickerViewHeight;

@class ISSLayerMonthPickerView;
@protocol ISSMonthPickerViewDelegate <NSObject>
@optional
- (void)MonthPickerView:(ISSLayerMonthPickerView *)monthPickerView didSelectDate:(NSDate *)date;
@end

typedef void(^ISSMonthPickerViewCallback)(ISSLayerMonthPickerView *monthPickerView, NSDate *date);

@interface ISSLayerMonthPickerView : UIView

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)initWithDelegate:(nullable id<ISSMonthPickerViewDelegate>)delegate;

@property (nullable, nonatomic, weak) id<ISSMonthPickerViewDelegate> delegate;
- (void)setMonthPickerViewCallback:(ISSMonthPickerViewCallback)callback;

@property (nullable, nonatomic, copy) NSDate *currentDate;

- (void)show;

- (void)dismiss;

@end
NS_ASSUME_NONNULL_END
