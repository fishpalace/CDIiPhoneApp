//
//  UIApplication+Addition.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-7.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "UIApplication+Addition.h"

@implementation UIApplication (Addition)

+ (CGFloat)currentScreenHeight
{
  return [UIScreen mainScreen].bounds.size.height;
}

+ (CGSize)currentScreenSize
{
  return [UIScreen mainScreen].bounds.size;
}

@end
