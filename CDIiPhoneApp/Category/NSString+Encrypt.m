//
//  NSString+Encrypt.m
//  CDI_iPad_App
//
//  Created by Gabriel Yeah on 13-3-31.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "NSString+Encrypt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Encrypt)

- (NSString *)md5
{
  const char *cStr = [self UTF8String];
  unsigned char result[16];
  CC_MD5( cStr, strlen(cStr), result );
  return [NSString stringWithFormat:
          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
          result[0], result[1], result[2], result[3],
          result[4], result[5], result[6], result[7],
          result[8], result[9], result[10], result[11],
          result[12], result[13], result[14], result[15]
          ];
}

@end
