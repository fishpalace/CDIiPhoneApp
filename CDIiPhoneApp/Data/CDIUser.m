//
//  CDIUser.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-21.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CDIUser.h"
#import "CDIEvent.h"
#import "CDINews.h"
#import "CDIWork.h"

#import "NSString+Dictionary.h"

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
@dynamic realNameEn;
@dynamic sessionKey;
@dynamic title;
@dynamic twitterURL;
@dynamic weiboURL;
@dynamic userID;
@dynamic events;
@dynamic news;
@dynamic relatedWork;
@dynamic work;
@dynamic mobile;
@dynamic email;

+ (CDIUser *)currentUserInContext:(NSManagedObjectContext *)context
{
  NSString *currentUserID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCurrentUserID];
  CDIUser *currentUser = [CDIUser userWithUserID:currentUserID inManagedObjectContext:context];
  return currentUser;
}

+ (void)updateCurrentUserID:(NSString *)userID
{
  [[NSUserDefaults standardUserDefaults] setObject:userID forKey:kUserDefaultsCurrentUserID];
  [[NSUserDefaults standardUserDefaults] synchronize];
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
  if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  NSString *userName = [dict[@"name"] isKindOfClass:[NSNull class]] ? @"" : dict[@"name"];
  
  if (!userName || [userName isEqualToString:@""]) {
    return nil;
  }
  
  CDIUser *user = [CDIUser userWithName:userName inManagedObjectContext:context];
  if (!user) {
    user = [NSEntityDescription insertNewObjectForEntityForName:@"CDIUser" inManagedObjectContext:context];
  }
  
  user.userID = [NSString stringForDict:dict key:@"id"];
  user.name = [NSString stringForDict:dict key:@"name"];
  user.realName = [NSString stringForDict:dict key:@"realName"];
  user.realNameEn = [NSString stringForDict:dict key:@"realName_en"];
  user.avatarLargeURL = [NSString stringForDict:dict key:@"avatarLargeUrl"];
  user.avatarMidURL = [NSString stringForDict:dict key:@"avatarMiddleUrl"];
  user.avatarSmallURL = [NSString stringForDict:dict key:@"avatarSmallUrl"];
  user.dribbleURL = [NSString stringForDict:dict key:@"dribbbleId"];
  user.homePageURL = [NSString stringForDict:dict key:@"personalSite"];
  user.linkedInURL = [NSString stringForDict:dict key:@"linkedInId"];
  user.position = [NSString stringForDict:dict key:@"title_en"];
  user.title = [NSString stringForDict:dict key:@"category"];
  user.twitterURL = [NSString stringForDict:dict key:@"twitterId"];
  user.weiboURL = [NSString stringForDict:dict key:@"weiboId"];
  user.mobile = [NSString stringForDict:dict key:@"mobilePhoneNumber"];
  user.email = [NSString stringForDict:dict key:@"emailAddress"];
  
  return user;
}

+ (CDIUser *)userWithName:(NSString *)userName inManagedObjectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  [request setEntity:[NSEntityDescription entityForName:@"CDIUser" inManagedObjectContext:context]];
  [request setPredicate:[NSPredicate predicateWithFormat:@"name == %@ ", userName]];
  
  NSArray *items = [context executeFetchRequest:request error:NULL];
  CDIUser *res = [items lastObject];
  
  return res;
}

+ (CDIUser *)userWithUserID:(NSString *)userID inManagedObjectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  [request setEntity:[NSEntityDescription entityForName:@"CDIUser" inManagedObjectContext:context]];
  [request setPredicate:[NSPredicate predicateWithFormat:@"userID == %@ ", userID]];
  
  NSArray *items = [context executeFetchRequest:request error:NULL];
  CDIUser *res = [items lastObject];
  
  return res;
}

@end
