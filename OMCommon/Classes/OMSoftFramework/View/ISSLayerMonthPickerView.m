//
//  ISSMonthPickerView.m
//  oumaSoftiPhone
//
//  Created by Paperman on 17/1/22.
//
//

#import "ISSLayerMonthPickerView.h"

typedef NS_ENUM(NSInteger, PickerType) {
    PickerTypeYear = 0,
    PickerTypeMonth,
};

CGFloat const ISSMonthPickerViewHeight = 260;

@interface ISSMonthPickerWindow : UIWindow
@end

@implementation ISSMonthPickerWindow
- (instancetype)init
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:screenBounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelAlert;
    }
    return self;
}
@end

static ISSMonthPickerWindow *monthPickerWindow;

@interface ISSLayerMonthPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) UIButton *outsideButton;
@property (strong, nonatomic) UIPickerView *monthPicker;

@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *years;

@property (copy, nonatomic) ISSMonthPickerViewCallback monthPickerViewCallback;

@property (assign, nonatomic) BOOL showing;
@end

@implementation ISSLayerMonthPickerView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<ISSMonthPickerViewDelegate>)delegate {
    self = [super init];
    if (self) {
        [self initView];
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.opaque = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)applicationWillResignActive:(NSNotification *)notify {
    self.showing = NO;
    [monthPickerWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [monthPickerWindow setHidden:YES];
    monthPickerWindow = nil;
}

- (void)show {
    if (self.showing || monthPickerWindow != nil) {
        return;
    }
    self.showing = YES;
    
    monthPickerWindow = [[ISSMonthPickerWindow alloc] init];
    [monthPickerWindow setHidden:NO];
    
    if (monthPickerWindow) {
        self.outsideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.outsideButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self.outsideButton addTarget:self action:@selector(tapOutsideAction:) forControlEvents:UIControlEventTouchUpInside];
        self.outsideButton.frame = monthPickerWindow.bounds;
        [monthPickerWindow addSubview:self.outsideButton];
        self.outsideButton.alpha = 0;
        
        [self makeContentView];
        
        [self setupFrameInView:monthPickerWindow];
        [monthPickerWindow addSubview:self];
        
        CGRect selfFrame = self.frame;
        self.frame = (CGRect){0, CGRectGetHeight(monthPickerWindow.bounds), selfFrame.size};
        [UIView animateWithDuration:0.2 animations:^(void) {
            self.frame = selfFrame;
            self.outsideButton.alpha = 1;
        } completion:^(BOOL completed) {
        }];
    }
}

- (void)dismiss
{
    if (!self.showing || monthPickerWindow == nil) {
        return;
    }
    self.showing = NO;
    
    if (monthPickerWindow) {
        CGRect selfFrame = (CGRect){0, CGRectGetHeight(monthPickerWindow.bounds), self.frame.size};
        [UIView animateWithDuration:0.2 animations:^(void) {
            self.frame = selfFrame;
            self.outsideButton.alpha = 0;
        } completion:^(BOOL finished) {
            [monthPickerWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [monthPickerWindow setHidden:YES];
            monthPickerWindow = nil;
        }];
    }
}

- (void)tapOutsideAction:(id)sender {
    [self dismiss];
}

- (void)doneAction:(id)sender {
    int month = (int)[self.monthPicker selectedRowInComponent:PickerTypeMonth] + 1;
    NSString *year = self.years[[self.monthPicker selectedRowInComponent:PickerTypeYear]];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy:MM"];
    
    NSString *dateString = [NSString stringWithFormat:@"%@:%02d", year, month];
    NSDate *select = [dateFormatter dateFromString:dateString];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSInteger selectInterval = [timeZone secondsFromGMTForDate:select];
    select = [select dateByAddingTimeInterval:selectInterval];

    if (self.delegate && [self.delegate respondsToSelector:@selector(MonthPickerView:didSelectDate:)]) {
        [self.delegate MonthPickerView:self didSelectDate:select];
    }
    if (self.monthPickerViewCallback) {
        self.monthPickerViewCallback(self, select);
    }
    [self dismiss];
}

- (void)makeContentView {
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectZero];
    toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:toolbar];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [toolbar addSubview:doneButton];
    
    toolbar.backgroundColor = [UIColor whiteColor];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    
    id viewDict = NSDictionaryOfVariableBindings(doneButton);
    [toolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[doneButton(50)]|" options:0 metrics:nil views:viewDict]];
    [toolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[doneButton]|" options:0 metrics:nil views:viewDict]];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:pickerView];
    
    pickerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    self.monthPicker = pickerView;
    
    NSDate *date = [NSDate date];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSInteger nowInterval = [timeZone secondsFromGMTForDate:date];
    NSDate *nowDate = [date dateByAddingTimeInterval:nowInterval];

    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    self.months = [dateFormatter standaloneMonthSymbols];

    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSInteger nowYear = [calendar components:NSCalendarUnitYear fromDate:nowDate].year;
    NSInteger minYear = 1980;
    NSInteger maxYear = nowYear;
    NSMutableArray *years = [NSMutableArray array];
    for (NSInteger year = minYear; year <= maxYear; year++) {
        NSString *yearStr = [NSString stringWithFormat:@"%li", (long)year];
        [years addObject:yearStr];
    }
    self.years = [years copy];

    if (self.currentDate == nil) {
        self.currentDate = [NSDate date];
        
        NSInteger currentInterval = [timeZone secondsFromGMTForDate:self.currentDate];
        self.currentDate = [self.currentDate dateByAddingTimeInterval:currentInterval];
    }

    NSInteger dateYear = [calendar components:NSYearCalendarUnit fromDate:self.currentDate].year;
    NSInteger rowIndex = dateYear - minYear;
    if (rowIndex < 0) {
        rowIndex = 0;
    }
    [pickerView selectRow:rowIndex inComponent:PickerTypeYear animated:NO];

    NSInteger dateMonth = [calendar components:NSMonthCalendarUnit fromDate:self.currentDate].month;
    [pickerView selectRow:dateMonth-1 inComponent:PickerTypeMonth animated:NO];

    id viewsDict = NSDictionaryOfVariableBindings(toolbar, pickerView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pickerView(216)]|" options:0 metrics:nil views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[toolbar(44)]" options:0 metrics:nil views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pickerView]|" options:0 metrics:nil views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbar]|" options:0 metrics:nil views:viewsDict]];
}

- (void)setupFrameInView:(UIView *)view {
    CGFloat y = CGRectGetHeight(view.bounds)-ISSMonthPickerViewHeight;
    self.frame = CGRectMake(0, y, CGRectGetWidth(view.bounds), ISSMonthPickerViewHeight);
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case PickerTypeYear:
            return self.years.count;
        case PickerTypeMonth:
            return self.months.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case PickerTypeYear:
            return self.years[row];
        case PickerTypeMonth:
            return self.months[row];
    }
    return nil;
}
@end
