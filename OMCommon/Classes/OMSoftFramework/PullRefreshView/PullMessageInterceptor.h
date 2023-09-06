//
//  MessageInterceptor.h
//  TableViewPull
//
//  Created by Emre Berge Ergenekon on 2011-07-30.
//  Copyright 2011 Emre Berge Ergenekon. All rights reserved.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DEFAULT_BACKGROUND_COLOR    [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0]
#define DEFAULT_TEXT_COLOR          [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]
#define DEFAULT_ACTIVITY_INDICATOR_STYLE    UIActivityIndicatorViewStyleGray

#define FLIP_ANIMATION_DURATION 0.18f

#define PULL_AREA_LOADING_HEIGTH 45.0f
#define PULL_TRIGGER_LOADING_HEIGHT 45.0f

#define PULL_AREA_PULLING_HEIGTH 45.0f
#define PULL_TRIGGER_PULLING_HEIGHT 50.0f

typedef enum{
	EGOOPullPulling = 0,
	EGOOPullNormal,
	EGOOPullLoading,
} EGOPullState;

@interface PullMessageInterceptor : NSObject {
    __unsafe_unretained id receiver;
    __unsafe_unretained id middleMan;
}
@property (nonatomic, assign) id receiver;
@property (nonatomic, assign) id middleMan;

+ (UIImage *)DEFAULT_ARROW_IMAGE;
@end
