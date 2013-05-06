//
//  UIStoryboard+Addition.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-4.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "UIStoryboard+Addition.h"

@implementation UIStoryboard (Addition)

+ (UIStoryboard *)currentStoryBoard
{
  return [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
}

+ (id)instantiateViewControllerWithIdentifier:(NSString *)identifier
{
  return [[UIStoryboard currentStoryBoard] instantiateViewControllerWithIdentifier:identifier];
}

@end
