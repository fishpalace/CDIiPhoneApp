//
//  NSString+Dictionary.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-21.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Dictionary)

+ (NSString *)stringForDict:(NSDictionary *)dict key:(NSString *)key;

- (NSString *)strippedHTMLString;

- (NSString *)strippedIosToken;

@end
