//
//  CDINews.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-17.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CDINews.h"
#import "CDIUser.h"
#import "NSString+Dictionary.h"

@implementation CDINews

@dynamic newsID;
@dynamic imageURL;
@dynamic content;
@dynamic date;
@dynamic title;
@dynamic creator;

+ (CDINews *)insertNewsInfoWithDict:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
  if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  NSString *newsID = [NSString stringForDict:dict key:@"id"];
  
  if (!newsID || [newsID isEqualToString:@""]) {
    return nil;
  }
  
  CDINews *news = [CDINews newsWithID:newsID inManagedObjectContext:context];
  if (!news) {
    news = [NSEntityDescription insertNewObjectForEntityForName:@"CDINews" inManagedObjectContext:context];
  }
  
  news.newsID = newsID;
  news.content = [NSString stringForDict:dict key:@"content"];
  news.imageURL = [NSString stringForDict:dict key:@"imageUrl"];
  news.title = [NSString stringForDict:dict key:@"title"];
  NSNumber *date = dict[@"postTimestamp"];
  news.date = [NSDate dateWithTimeIntervalSince1970:date.longLongValue / 1000];
  
  return news;
}

+ (CDINews *)newsWithID:(NSString *)newsID inManagedObjectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  [request setEntity:[NSEntityDescription entityForName:@"CDINews" inManagedObjectContext:context]];
  [request setPredicate:[NSPredicate predicateWithFormat:@"newsID == %@ ", newsID]];
  
  NSArray *items = [context executeFetchRequest:request error:NULL];
  CDINews *res = [items lastObject];
  
  return res;
}

@end
