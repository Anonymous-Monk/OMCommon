//
//  ISSMenuPopoverView.m
//  oumaSoftFramework
//
//  Created by Paperman on 16/7/7.
//
//

#import "ISSLayerMenuPopoverView.h"
#import "ISSAdditions+UIColor.h"

@implementation ISSMenuItem
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image {
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
    }
    return self;
}
@end

@interface ISSMenuPopoverWindow : UIWindow
@end

@implementation ISSMenuPopoverWindow
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

static NSString * const kCellIdentifier = @"ISSMenuPopoverTableCell";
#define ISSMenuPopoverTitleFont [UIFont systemFontOfSize:16]

@interface ISSMenuPopoverTableCell : UITableViewCell
@end

@implementation ISSMenuPopoverTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = [[UIView alloc] init];
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
        self.textLabel.font = ISSMenuPopoverTitleFont;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imgSize = 20;
    CGFloat selfH = CGRectGetHeight(self.bounds);

    CGFloat textX = 0;
    if (self.imageView.image) {
        self.imageView.frame = CGRectMake(15, (selfH - imgSize)/2.f, imgSize, imgSize);
        textX = 25 + imgSize;
    } else {
        textX = 15;
    }

    CGFloat selfW = CGRectGetWidth(self.bounds);
    self.textLabel.frame = CGRectMake(textX, 0, selfW-textX-15, selfH);
}

@end

typedef enum {
    ISSMenuViewArrowDirectionNone,
    ISSMenuViewArrowDirectionUp,
    ISSMenuViewArrowDirectionDown,
    ISSMenuViewArrowDirectionLeft,
    ISSMenuViewArrowDirectionRight,
} ISSMenuViewArrowDirection;

static ISSMenuPopoverWindow *menuPopoverWindow;
static CGFloat const kArrowSize    = 12.f;
static CGFloat const kCornerRadius = 0.f;

@interface ISSLayerMenuPopoverView()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UIButton *outsideButton;
@property (strong, nonatomic) UIView *contentView;

@property (copy, nonatomic) ISSMenuPopoverViewCallback menuPopoverViewCallback;

@property (assign, nonatomic) ISSMenuViewArrowDirection arrowDirection;
@property (assign, nonatomic) CGFloat arrowPosition;

@property (assign, nonatomic) BOOL showing;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *cellHeights;
@end

@implementation ISSLayerMenuPopoverView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithDelegate:(id <ISSMenuPopoverViewDelegate>)delegate buttonTitles:(ISSMenuItem *)menuItems, ... NS_REQUIRES_NIL_TERMINATION {
    self = [super init];
    if (self) {
        [self initView];
        self.delegate = delegate;
        if (menuItems) {
            va_list args;
            NSInteger index = 1;
            va_start(args, menuItems);
            for (ISSMenuItem *menuItem = menuItems; menuItem != nil; menuItem = va_arg(args, ISSMenuItem *)) {
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
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    self.opaque = YES;
    self.alpha = 0;
    self.popoverTintColor = [UIColor whiteColor];
    self.titleColor = [UIColor colorWithHexString:@"333333"];
    self.selectedBackgroundColor = [UIColor colorWithHexString:@"ececec"];
    self.separatorColor = [UIColor colorWithHexString:@"eeeeee"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)applicationWillResignActive:(NSNotification *)notify {
    self.showing = NO;
    [menuPopoverWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [menuPopoverWindow setHidden:YES];
    menuPopoverWindow = nil;
}

- (NSInteger)addMenuItem:(ISSMenuItem *)item {
    if (item != nil) {
        NSInteger index = self.dataSource.count;
        [self.dataSource addObject:item];
        return index;
    }
    return -1;
}

- (ISSMenuItem *)menuItemAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex < self.dataSource.count) {
        return self.dataSource[buttonIndex];
    }
    return nil;
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item {
    UIView *view = [item valueForKey:@"view"];
    [self showFromView:view];
}

- (void)showFromView:(UIView *)view {
    CGRect rect = [view convertRect:view.bounds toView:nil];
    [self showFromRect:rect];
}

- (void)showFromRect:(CGRect)rect
{
    if (self.showing || menuPopoverWindow != nil) {
        return;
    }
    self.showing = YES;

    menuPopoverWindow = [[ISSMenuPopoverWindow alloc] init];
    [menuPopoverWindow setHidden:NO];

    if (menuPopoverWindow) {
        self.outsideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.outsideButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self.outsideButton addTarget:self action:@selector(tapOutsideAction:) forControlEvents:UIControlEventTouchUpInside];
        self.outsideButton.frame = menuPopoverWindow.bounds;
        [menuPopoverWindow addSubview:self.outsideButton];
        self.outsideButton.alpha = 0;
        
        self.contentView = [self makeContentView];
        [self addSubview:self.contentView];
        
        [self setupFrameInView:menuPopoverWindow fromRect:rect];
        [menuPopoverWindow addSubview:self];
        
        self.outsideButton.alpha = 0;
        self.contentView.hidden = YES;
        const CGRect toFrame = self.frame;
        self.frame = (CGRect){[self arrowPoint], 1, 1};
        [UIView animateWithDuration:0.2 animations:^(void) {
            self.alpha = 1;
            self.frame = toFrame;
            self.outsideButton.alpha = 1;
        } completion:^(BOOL completed) {
            self.contentView.hidden = NO;
        }];
    }
}

- (void)dismiss
{
    if (!self.showing || menuPopoverWindow == nil) {
        return;
    }
    self.showing = NO;

    if (menuPopoverWindow) {
        self.outsideButton.alpha = 1;
        self.contentView.hidden = YES;
        const CGRect toFrame = (CGRect){self.arrowPoint, 1, 1};
        [UIView animateWithDuration:0.2 animations:^(void) {
            self.alpha = 0;
            self.frame = toFrame;
            self.outsideButton.alpha = 0;
        } completion:^(BOOL finished) {
            [menuPopoverWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [menuPopoverWindow setHidden:YES];
            menuPopoverWindow = nil;
        }];
    }
}

- (void)tapOutsideAction:(UIWindow *)sender {
    [self dismiss];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellHeights.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellHeights[indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ISSMenuPopoverTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    ISSMenuItem *menuItem = self.dataSource[indexPath.row];
    cell.textLabel.textColor = self.titleColor;
    cell.textLabel.text = menuItem.title;
    cell.imageView.image = menuItem.image;
    cell.selectedBackgroundView.backgroundColor = self.selectedBackgroundColor;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuPopoverView:clickedButtonAtIndex:)]) {
        [self.delegate menuPopoverView:self clickedButtonAtIndex:indexPath.row];
    }
    if (self.menuPopoverViewCallback) {
        self.menuPopoverViewCallback(self, indexPath.row);
    }
    [self dismiss];
}

- (UIView *)makeContentView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableView registerClass:[ISSMenuPopoverTableCell class] forCellReuseIdentifier:kCellIdentifier];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.layer.cornerRadius = kCornerRadius;
    tableView.dataSource = self;
    tableView.delegate = self;
    if (self.separatorColor) {
        tableView.separatorColor = self.separatorColor;
    }

    const CGFloat kMinMenuItemHeight = 32.f;
    const CGFloat kMinMenuItemWidth = 32.f;
    const CGFloat kMarginX = 15.f;
    const CGFloat kMarginY = 15.f;
    CGFloat countItemHeight = 0;
    CGFloat maxItemWidth = 0;

    CGFloat maxImageWidth = 0;

    CGFloat pSCREEN_WIDTH = [UIScreen mainScreen].bounds.size.width;
    CGFloat pSCREEN_HEIGHT = [UIScreen mainScreen].bounds.size.height;
    
    self.cellHeights = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    for (ISSMenuItem *menuItem in self.dataSource) {
        
        CGFloat width = pSCREEN_WIDTH - kMarginX * 4 - kMarginX * 2;
        if (menuItem.image != nil) {
            maxImageWidth = 20 + 10;
            width -= maxImageWidth + 10;
        }
        const CGSize titleSize = [menuItem.title boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:ISSMenuPopoverTitleFont}
                                                        context:nil].size;
        
        const CGFloat itemHeight = titleSize.height + kMarginY * 2;
        const CGFloat itemWidth = titleSize.width + maxImageWidth + kMarginX * 2 + 1;
        
        countItemHeight += itemHeight;
        [self.cellHeights addObject:@(itemHeight)];
        
        if (itemWidth > maxItemWidth)
            maxItemWidth = itemWidth;
    }
    
    maxItemWidth  = MAX(maxItemWidth, kMinMenuItemWidth);
    countItemHeight = MAX(countItemHeight, kMinMenuItemHeight);
    CGFloat height = pSCREEN_HEIGHT- kMarginY * 2;
    if (countItemHeight > height) {
        tableView.scrollEnabled = YES;
        countItemHeight = height;
    } else {
        tableView.scrollEnabled = NO;
    }
    
    tableView.frame = CGRectMake(0, 0, maxItemWidth, countItemHeight);
    return tableView;
}

- (void)setupFrameInView:(UIView *)view fromRect:(CGRect)fromRect
{
    const CGSize contentSize = self.contentView.frame.size;
    
    const CGFloat outerWidth = view.bounds.size.width;
    const CGFloat outerHeight = view.bounds.size.height;
    
    const CGFloat rectX0 = fromRect.origin.x;
    const CGFloat rectX1 = fromRect.origin.x + fromRect.size.width;
    const CGFloat rectXM = fromRect.origin.x + fromRect.size.width * 0.5f;
    const CGFloat rectY0 = fromRect.origin.y;
    const CGFloat rectY1 = fromRect.origin.y + fromRect.size.height;
    const CGFloat rectYM = fromRect.origin.y + fromRect.size.height * 0.5f;
    
    const CGFloat widthPlusArrow = contentSize.width + kArrowSize;
    const CGFloat heightPlusArrow = contentSize.height + kArrowSize;
    const CGFloat widthHalf = contentSize.width * 0.5f;
    const CGFloat heightHalf = contentSize.height * 0.5f;
    
    const CGFloat kMargin = 5.f;
    
    if (heightPlusArrow < (outerHeight - rectY1)) {
        self.arrowDirection = ISSMenuViewArrowDirectionUp;
        
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY1
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        self.arrowPosition = rectXM - point.x;
        self.contentView.frame = (CGRect){0, kArrowSize, contentSize};
        
        self.frame = (CGRect) {
            point,
            contentSize.width,
            contentSize.height + kArrowSize
        };
    } else if (heightPlusArrow < rectY0) {
        self.arrowDirection = ISSMenuViewArrowDirectionDown;
        
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY0 - heightPlusArrow
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        self.arrowPosition = rectXM - point.x;
        self.contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            point,
            contentSize.width,
            contentSize.height + kArrowSize
        };
    } else if (widthPlusArrow < (outerWidth - rectX1)) {
        self.arrowDirection = ISSMenuViewArrowDirectionLeft;
        
        CGPoint point = (CGPoint){
            rectX1,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + kMargin) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        self.arrowPosition = rectYM - point.y;
        self.contentView.frame = (CGRect){kArrowSize, 0, contentSize};
        
        self.frame = (CGRect) {
            point,
            contentSize.width + kArrowSize,
            contentSize.height
        };
    } else if (widthPlusArrow < rectX0) {
        self.arrowDirection = ISSMenuViewArrowDirectionRight;
        
        CGPoint point = (CGPoint){
            rectX0 - widthPlusArrow,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + 5) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        self.arrowPosition = rectYM - point.y;
        self.contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            point,
            contentSize.width  + kArrowSize,
            contentSize.height
        };
    } else {
        self.arrowDirection = ISSMenuViewArrowDirectionNone;
        
        self.frame = (CGRect) {
            (outerWidth - contentSize.width)   * 0.5f,
            (outerHeight - contentSize.height) * 0.5f,
            contentSize,
        };
    }
}

- (CGPoint)arrowPoint
{
    CGPoint point;
    switch (self.arrowDirection) {
        case ISSMenuViewArrowDirectionUp:
            point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMinY(self.frame) };
            break;
        case ISSMenuViewArrowDirectionDown:
            point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMaxY(self.frame) };
            break;
        case ISSMenuViewArrowDirectionLeft:
            point = (CGPoint){ CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition };
            break;
        case ISSMenuViewArrowDirectionRight:
            point = (CGPoint){ CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition };
            break;
        case ISSMenuViewArrowDirectionNone:
            point = self.center;
            break;
    }
    return point;
}

- (void) drawRect:(CGRect)rect
{
    CGFloat X0 = self.bounds.origin.x;
    CGFloat X1 = self.bounds.origin.x + self.bounds.size.width;
    CGFloat Y0 = self.bounds.origin.y;
    CGFloat Y1 = self.bounds.origin.y + self.bounds.size.height;
    
    if (self.arrowDirection != ISSMenuViewArrowDirectionNone) { // render arrow
        UIBezierPath *arrowPath = [UIBezierPath bezierPath];
        const CGFloat kEmbedFix = 3.f;

        if (self.popoverTintColor) {
            [self.popoverTintColor set];
        } else {
            [[UIColor whiteColor] set];
        }

        // fix the issue with gap of arrow's base if on the edge
        if (self.arrowDirection == ISSMenuViewArrowDirectionUp) {
            
            const CGFloat arrowXM = _arrowPosition;
            const CGFloat arrowX0 = arrowXM - kArrowSize;
            const CGFloat arrowX1 = arrowXM + kArrowSize;
            const CGFloat arrowY0 = Y0;
            const CGFloat arrowY1 = Y0 + kArrowSize + kEmbedFix;
            
            [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY0}];
            [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
            [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY1}];
            [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
            
            Y0 += kArrowSize;
        } else if (_arrowDirection == ISSMenuViewArrowDirectionDown) {
            
            const CGFloat arrowXM = _arrowPosition;
            const CGFloat arrowX0 = arrowXM - kArrowSize;
            const CGFloat arrowX1 = arrowXM + kArrowSize;
            const CGFloat arrowY0 = Y1 - kArrowSize - kEmbedFix;
            const CGFloat arrowY1 = Y1;
            
            [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY1}];
            [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
            [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY0}];
            [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY1}];
            
            Y1 -= kArrowSize;
        } else if (_arrowDirection == ISSMenuViewArrowDirectionLeft) {
            
            const CGFloat arrowYM = _arrowPosition;
            const CGFloat arrowX0 = X0;
            const CGFloat arrowX1 = X0 + kArrowSize + kEmbedFix;
            const CGFloat arrowY0 = arrowYM - kArrowSize;;
            const CGFloat arrowY1 = arrowYM + kArrowSize;
            
            [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
            [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
            [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
            [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
            
            X0 += kArrowSize;
        } else if (_arrowDirection == ISSMenuViewArrowDirectionRight) {
            
            const CGFloat arrowYM = _arrowPosition;
            const CGFloat arrowX0 = X1;
            const CGFloat arrowX1 = X1 - kArrowSize - kEmbedFix;
            const CGFloat arrowY0 = arrowYM - kArrowSize;;
            const CGFloat arrowY1 = arrowYM + kArrowSize;
            
            [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
            [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
            [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
            [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
            
            X1 -= kArrowSize;
        }
        [arrowPath fill];
    }
    
    // render body
    const CGRect bodyFrame = {X0, Y0, X1 - X0, Y1 - Y0};
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:bodyFrame cornerRadius:kCornerRadius];
    [borderPath fill];
}
@end
