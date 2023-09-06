//
//  ISSPickerView.m
//  oumaSoftiPhone
//
//  Created by Paperman on 17/1/21.
//
//

#import "ISSLayerPickerView.h"

CGFloat const ISSPickerViewHeight = 260;

@interface ISSPickerWindow : UIWindow
@end

@implementation ISSPickerWindow
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

static ISSPickerWindow *pickerWindow;

@interface ISSLayerPickerView()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) UIButton *outsideButton;
@property (strong, nonatomic) UIPickerView *pickerView;

@property (copy, nonatomic) ISSPickerViewCallback pickerViewCallback;

@property (assign, nonatomic) BOOL showing;

@property (strong, nonatomic) NSMutableArray *dataSource;
@end

@implementation ISSLayerPickerView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<ISSPickerViewDelegate>)delegate buttonTitles:(NSString *)menuItems, ... {
    self = [super init];
    if (self) {
        [self initView];
        self.delegate = delegate;
        if (menuItems) {
            va_list args;
            NSInteger index = 1;
            va_start(args, menuItems);
            for (NSString *menuItem = menuItems; menuItem != nil; menuItem = va_arg(args, NSString *)) {
                [self.dataSource addObject:menuItem];
                index++;
            }
            va_end(args);
        }
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initView {
    self.dataSource = [NSMutableArray array];
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.opaque = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)applicationWillResignActive:(NSNotification *)notify {
    self.showing = NO;
    [pickerWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [pickerWindow setHidden:YES];
    pickerWindow = nil;
}

- (NSInteger)addPickerItem:(__kindof NSString *)item {
    if (item != nil) {
        NSInteger index = self.dataSource.count;
        [self.dataSource addObject:item];
        return index;
    }
    return -1;
}

- (NSString *)pickerItemAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex < self.dataSource.count) {
        return self.dataSource[buttonIndex];
    }
    return nil;
}

- (void)show {
    if (self.showing || pickerWindow != nil) {
        return;
    }
    self.showing = YES;
    
    pickerWindow = [[ISSPickerWindow alloc] init];
    [pickerWindow setHidden:NO];
    
    if (pickerWindow) {
        self.outsideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.outsideButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self.outsideButton addTarget:self action:@selector(tapOutsideAction:) forControlEvents:UIControlEventTouchUpInside];
        self.outsideButton.frame = pickerWindow.bounds;
        [pickerWindow addSubview:self.outsideButton];
        self.outsideButton.alpha = 0;
        
        [self makeContentView];

        [self setupFrameInView:pickerWindow];
        [pickerWindow addSubview:self];

        CGRect selfFrame = self.frame;
        self.frame = (CGRect){0, CGRectGetHeight(pickerWindow.bounds), selfFrame.size};
        [UIView animateWithDuration:0.2 animations:^(void) {
            self.frame = selfFrame;
            self.outsideButton.alpha = 1;
        } completion:^(BOOL completed) {
        }];
    }
}

- (void)dismiss
{
    if (!self.showing || pickerWindow == nil) {
        return;
    }
    self.showing = NO;
    
    if (pickerWindow) {
        CGRect selfFrame = (CGRect){0, CGRectGetHeight(pickerWindow.bounds), self.frame.size};
        [UIView animateWithDuration:0.2 animations:^(void) {
            self.frame = selfFrame;
            self.outsideButton.alpha = 0;
        } completion:^(BOOL finished) {
            [pickerWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [pickerWindow setHidden:YES];
            pickerWindow = nil;
        }];
    }
}

- (void)tapOutsideAction:(id)sender {
    [self dismiss];
}

- (void)doneAction:(id)sender {
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    NSString *select = self.dataSource[row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView: didSelectItemAtTitle:)]) {
        [self.delegate pickerView:self didSelectItemAtTitle:select];
    }
    if (self.pickerViewCallback) {
        self.pickerViewCallback(self, select);
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
    self.pickerView = pickerView;

    id viewsDict = NSDictionaryOfVariableBindings(toolbar, pickerView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pickerView(216)]|" options:0 metrics:nil views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[toolbar(44)]" options:0 metrics:nil views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pickerView]|" options:0 metrics:nil views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolbar]|" options:0 metrics:nil views:viewsDict]];

    [pickerView selectRow:0 inComponent:0 animated:YES];
}

- (void)setupFrameInView:(UIView *)view {
    CGFloat y = CGRectGetHeight(view.bounds)-ISSPickerViewHeight;
    self.frame = CGRectMake(0, y, CGRectGetWidth(view.bounds), ISSPickerViewHeight);
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataSource[row];
}
@end
