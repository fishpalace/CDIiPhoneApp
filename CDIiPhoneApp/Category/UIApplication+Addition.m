//
//  UIApplication+Addition.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-7.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "UIApplication+Addition.h"
#import "AppDelegate.h"

@implementation UIApplication (Addition)

+ (void)showCover
{
  UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 12)];
  UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kCurrentScreenHeight - 12, 320, 12)];
  topImageView.image = [UIImage imageNamed:@"top_cover"];
  bottomImageView.image = [UIImage imageNamed:@"bottom_cover"];
  
  AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
  [appDelegate.window makeKeyAndVisible];
  [appDelegate.window addSubview:topImageView];
  [appDelegate.window addSubview:bottomImageView];
}

@end
