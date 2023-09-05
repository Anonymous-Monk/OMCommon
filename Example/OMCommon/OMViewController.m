//
//  OMViewController.m
//  OMCommon
//
//  Created by Anonymous-Monk on 09/05/2023.
//  Copyright (c) 2023 Anonymous-Monk. All rights reserved.
//

#import "OMViewController.h"
#import <OMCommon/RHMacros.h>
#import <OMCommon/RHUIKit.h>
#import <OMCommon/RHFoundation.h>

@interface OMViewController ()

@end

@implementation OMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    RHLog(@"%@",[NSBundle rh_getBundleDisplayName]);
    CGFloat width = rhAdaptedWidth(300);
    RHLog(@"%f",width);

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
