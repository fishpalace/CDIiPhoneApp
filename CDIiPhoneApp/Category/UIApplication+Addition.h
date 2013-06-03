//
//  UIApplication+Addition.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-7.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCurrentScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kCurrentScreenSize    [UIScreen mainScreen].bounds.size
#define kIsiPhone5            kCurrentScreenHeight == 568

@interface UIApplication (Addition)

+ (void)showCover;
+ (void)insertViewUnderCover:(UIView *)view;

@end
