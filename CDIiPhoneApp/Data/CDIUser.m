//
//  CDIUser.m
//  CDI_iPad_App
//
//  Created by Gabriel Yeah on 13-4-1.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CDIUser.h"

static CDIUser *currentUser;

@implementation CDIUser

+ (CDIUser *)currentUser
{
  if (!currentUser) {
    currentUser = [[CDIUser alloc] init];
  }
  return currentUser;
}

+ (void)updateCurrentUserWithDictionary:(NSDictionary *)dict
                             sessionKey:(NSString *)sessionKey
{
  CDIUser *user = [CDIUser currentUser];
  user.userName = [dict[@"name"] isKindOfClass:[NSNull class]] ? @"" : dict[@"name"];
  user.userRealName = [dict[@"realName"] isKindOfClass:[NSNull class]] ? @"" : dict[@"realName"];
  user.avatarLargeURL = [dict[@"avatarLargeUrl"] isKindOfClass:[NSNull class]] ? @"" : dict[@"avatarLargeUrl"];
  user.avatarMidURL = [dict[@"avatarMiddleUrl"] isKindOfClass:[NSNull class]] ? @"" : dict[@"avatarMiddleUrl"];
  user.avatarSmallURL = [dict[@"avatarSmallUrl"] isKindOfClass:[NSNull class]] ? @"" : dict[@"avatarSmallUrl"];
  user.sessionKey = sessionKey;
}

@end
