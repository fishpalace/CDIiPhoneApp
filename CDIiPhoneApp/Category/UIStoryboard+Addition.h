//
//  UIStoryboard+Addition.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-4.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (Addition)

+ (UIStoryboard *)currentStoryBoard;

+ (id)instantiateViewControllerWithIdentifier:(NSString *)identifier;

@end
