//
//  ISSDatePickerView.m
//  oumaSoftiPhone
//
//  Created by Paperman on 17/1/21.
//
//

#import "ISSLayerDatePickerView.h"

CGFloat const ISSDatePickerViewHeight = 260;

@interface ISSDatePickerWindow : UIWindow
@end

@implementation ISSDatePickerWindow
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

static ISSDatePickerWindow *datePickerWindow;

@interface ISSLayerDatePickerView()
@property (strong, nonatomic) UIButton *outsideButton;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (copy, nonatomic) ISSDatePickerViewCallback datePickerViewCallback;

@property (assign, nonatomic) BOOL showing;
@end

@implementation ISSLayerDatePickerView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<ISSDatePickerViewDelegate>)delegate {
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

    self.datePickerMode = UIDatePickerModeDate;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)applicationWillResignActive:(NSNotification *)notify {
    self.showing = NO;
    [datePickerWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [datePickerWindow setHidden:YES];
    datePickerWindow = nil;
}

- (void)show {
    if (self.showing || datePickerWindow != nil) {
        return;
    }
    self.showing = YES;
    
    datePickerWindow = [[ISSDatePickerWindow alloc] init];
    [datePickerWindow setHidden:NO];
    
    if (datePickerWindow) {
        self.outsideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.outsideButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self.outsideButton addTarget:self action:@selector(tapOutsideAction:) forControlEvents:UIControlEventTouchUpInside];
        self.outsideButton.frame = datePickerWindow.bounds;
        [datePickerWindow addSubview:self.outsideButton];
        self.outsideButton.alpha = 0;
        
        [self makeContentView];
        
        [self setupFrameInView:datePickerWindow];
        [datePickerWindow addSubview:self];
        
        CGRect selfFrame = self.frame;
        self.frame = (CGRect){0, CGRectGetHeight(datePickerWindow.bounds), selfFrame.size};
        [UIView animateWithDuration:0.2 animations:^(void) {
            self.frame = selfFrame;
            self.outsideButton.alpha = 1;
        } completion:^(BOOL completed) {
        }];
    }
}

- (void)dismiss
{
    if (!self.showing || datePickerWindow == nil) {
        return;
    }
    self.showing = NO;
    
    if (datePickerWindow) {
        CGRect selfFrame = (CGRect){0, CGRectGetHeight(datePickerWindow.bounds), self.frame.size};
        [UIView animateWithDuration:0.2 animations:^(void) {
            self.frame = selfFrame;
            self.outsideButton.alpha = 0;
        } completion:^(BOOL finished) {
            [datePickerWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [datePickerWindow setHidden:YES];
            datePickerWindow = nil;
        }];
    }
}

- (void)tapOutsideAction:(id)sender {
    [self dismiss];
}

- (void)doneAction:(id)sender {
    NSDate *select = [self.datePicker date];

    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerView:didSelectDate:)]) {
        [self.delegate datePickerView:self didSelectDate:select];
    }
    if (self.datePickerViewCallback) {
        self.datePickerViewCallback(self, select);
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
    
    UIDatePicker *pickerView = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:pickerView];
    
    pickerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    pickerView.datePickerMode = self.datePickerMode;

    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];

    if (self.currentDate == nil) {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        if (self.datePickerMode == UIDatePickerModeDateAndTime) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:00"];
        } else {
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        NSString *str = [dateFormatter stringFromDate:currentDate];
        self.currentDate = [dateFormatter dateFromString:str];
    }

    [pickerView setTimeZone:timeZone];
    [pickerView setDate:self.currentDate animated:YES];
    self.datePicker = pickerView;
    
    id viewsDict = NSDictionaryOfVariableBindings(toolbar, pickerView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pickerView(216)]|" options:0 metrics:nil views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[toolbar(44)]" options:0 metrics:nil views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pickerView]|" options:0 metrics:nil views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbar]|" options:0 metrics:nil views:viewsDict]];
}

- (void)setupFrameInView:(UIView *)view {
    CGFloat y = CGRectGetHeight(view.bounds)-ISSDatePickerViewHeight;
    self.frame = CGRectMake(0, y, CGRectGetWidth(view.bounds), ISSDatePickerViewHeight);
}
@end
