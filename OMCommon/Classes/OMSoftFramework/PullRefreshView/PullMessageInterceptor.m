//
//  MessageInterceptor.m
//  TableViewPull
//
//  Created by Emre Berge Ergenekon on 2011-07-30.
//  Copyright 2012 Emre Berge Ergenekon. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

//  From http://stackoverflow.com/questions/3498158/intercept-obj-c-delegate-messages-within-a-subclass

#import "PullMessageInterceptor.h"

@implementation PullMessageInterceptor
@synthesize receiver;
@synthesize middleMan;

+ (UIImage *)DEFAULT_ARROW_IMAGE
{
    CGSize size = CGSizeMake(25, 50);
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);

    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Resize to Target Frame
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, 0);
    CGContextScaleCTM(context, size.width / 25, size.height / 50);
    
    
    //// Color Declarations
    [[UIColor colorWithRed: 0.2 green: 0.2 blue: 0.2 alpha: 1] setStroke];
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(7, 29)];
    [bezierPath addLineToPoint: CGPointMake(4.5, 29)];
    [bezierPath addLineToPoint: CGPointMake(12.5, 40.5)];
    [bezierPath addLineToPoint: CGPointMake(20.5, 29)];
    [bezierPath addLineToPoint: CGPointMake(12.5, 29)];
    [bezierPath addLineToPoint: CGPointMake(12.5, 22)];
    bezierPath.lineWidth = 2;
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    [bezierPath stroke];
    
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
    [bezier2Path moveToPoint: CGPointMake(12.5, 18.5)];
    [bezier2Path addLineToPoint: CGPointMake(12.5, 16)];
    bezier2Path.lineWidth = 2;
    bezier2Path.lineCapStyle = kCGLineCapRound;
    bezier2Path.lineJoinStyle = kCGLineJoinRound;
    [bezier2Path stroke];
    
    
    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(12.5, 12.5)];
    [bezier3Path addLineToPoint: CGPointMake(12.5, 10)];
    bezier3Path.lineWidth = 2;
    bezier3Path.lineCapStyle = kCGLineCapRound;
    bezier3Path.lineJoinStyle = kCGLineJoinRound;
    [bezier3Path stroke];
    
    CGContextRestoreGState(context);

    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([middleMan respondsToSelector:aSelector]) { return middleMan; }
    if ([receiver respondsToSelector:aSelector]) { return receiver; }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([middleMan respondsToSelector:aSelector]) { return YES; }
    if ([receiver respondsToSelector:aSelector]) { return YES; }
    return [super respondsToSelector:aSelector];
}

@end
