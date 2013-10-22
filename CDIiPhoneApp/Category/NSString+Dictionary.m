//
//  NSString+Dictionary.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-21.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "NSString+Dictionary.h"

@implementation NSString (Dictionary)

+ (NSString *)stringForDict:(NSDictionary *)dict key:(NSString *)key
{
  NSObject *result = [dict[key] isKindOfClass:[NSNull class]] ? @"" : dict[key];
  NSString *stringValue = (NSString *)result;
  if ([result isKindOfClass:[NSNumber class]]) {
    stringValue = ((NSNumber *)result).stringValue;
  }
  return stringValue;
}

- (NSString *)strippedHTMLString
{
  NSRange r;
  NSString *s = [self copy];
    BOOL isFirstLine = YES;
  while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
  {
      if(isFirstLine) {
          isFirstLine = NO;
          s = [s stringByReplacingCharactersInRange:r withString:@""];
      } else {
          s = [s stringByReplacingCharactersInRange:r withString:@"\n"];
      }
  }
  return s;
}

- (NSString *)strippedIosToken
{
    NSString *s = [self copy];
    return [[[s stringByReplacingOccurrencesOfString:@" " withString:@""]
             stringByReplacingOccurrencesOfString:@"<" withString:@""]
            stringByReplacingOccurrencesOfString:@">" withString:@""];
}


@end
