//
//  UIApplication+Addition.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-7.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCurrentScreenHeight  [UIApplication currentScreenHeight]
#define kCurrentScreenSize    [UIApplication currentScreenSize]

@interface UIApplication (Addition)

+ (CGFloat)currentScreenHeight;
+ (CGSize)currentScreenSize;

@end
