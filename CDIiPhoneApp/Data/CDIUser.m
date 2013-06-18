//
//  CDIUser.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-17.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CDIUser.h"
#import "CDIEvent.h"
#import "CDINews.h"
#import "CDIWork.h"

static CDIUser *currentUser;

@implementation CDIUser

@dynamic avatarLargeURL;
@dynamic avatarMidURL;
@dynamic avatarSmallURL;
@dynamic dribbleURL;
@dynamic homePageURL;
@dynamic linkedInURL;
@dynamic name;
@dynamic position;
@dynamic realName;
@dynamic title;
@dynamic twitterURL;
@dynamic weiboURL;
@dynamic sessionKey;
@dynamic events;
@dynamic news;
@dynamic relatedWork;
@dynamic work;

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
  user.name = [dict[@"name"] isKindOfClass:[NSNull class]] ? @"" : dict[@"name"];
  user.realName = [dict[@"realName"] isKindOfClass:[NSNull class]] ? @"" : dict[@"realName"];
  user.avatarLargeURL = [dict[@"avatarLargeUrl"] isKindOfClass:[NSNull class]] ? @"" : dict[@"avatarLargeUrl"];
  user.avatarMidURL = [dict[@"avatarMiddleUrl"] isKindOfClass:[NSNull class]] ? @"" : dict[@"avatarMiddleUrl"];
  user.avatarSmallURL = [dict[@"avatarSmallUrl"] isKindOfClass:[NSNull class]] ? @"" : dict[@"avatarSmallUrl"];
  user.sessionKey = sessionKey;
}

- (id)initWithName:(NSString *)name title:(NSString *)title position:(NSString *)position
{
  self = [super init];
  if (self) {
    self.name = name;
    self.title = title;
    self.position = position;
  }
  return self;
}

+ (CDIUser *)insertUserInfoWithDict:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
  NSString *userName = [dict[@"name"] isKindOfClass:[NSNull class]] ? @"" : dict[@"name"];
  
  if (!userName || [userName isEqualToString:@""]) {
    return nil;
  }
  
  CDIUser *user = [CDIUser userWithName:userName inManagedObjectContext:context];
  if (!user) {
    user = [NSEntityDescription insertNewObjectForEntityForName:@"CDIUser" inManagedObjectContext:context];
  }

  user.name = [dict[@"name"] isKindOfClass:[NSNull class]] ? @"" : dict[@"name"];
  user.realName = [dict[@"realName"] isKindOfClass:[NSNull class]] ? @"" : dict[@"realName"];
  user.avatarLargeURL = [dict[@"avatarLargeUrl"] isKindOfClass:[NSNull class]] ? @"" : dict[@"avatarLargeUrl"];
  user.avatarMidURL = [dict[@"avatarMiddleUrl"] isKindOfClass:[NSNull class]] ? @"" : dict[@"avatarMiddleUrl"];
  user.avatarSmallURL = [dict[@"avatarSmallUrl"] isKindOfClass:[NSNull class]] ? @"" : dict[@"avatarSmallUrl"];
  
  return user;
}

+ (CDIUser *)userWithName:(NSString *)userName inManagedObjectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:context]];
  [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@ ", userName]];
  
  NSArray *items = [context executeFetchRequest:request error:NULL];
  CDIUser *res = [items lastObject];
  
  return res;
}

@end
