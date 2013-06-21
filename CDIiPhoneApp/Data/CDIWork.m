//
//  CDIWork.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-21.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CDIWork.h"
#import "CDIUser.h"

#import "NSString+Dictionary.h"

@implementation CDIWork

@dynamic endDate;
@dynamic estimatedEndDate;
@dynamic imgURL;
@dynamic linkURL;
@dynamic name;
@dynamic nameEn;
@dynamic previewImageURL;
@dynamic startDate;
@dynamic videoURL;
@dynamic workInfo;
@dynamic workInfoEn;
@dynamic workStatus;
@dynamic workType;
@dynamic workID;
@dynamic creator;
@dynamic involvedUser;

+ (CDIWork *)insertWorkInfoWithDict:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
  NSString *workID = [NSString stringForDict:dict key:@"id"];
  
  if (!workID || [workID isEqualToString:@""]) {
    return nil;
  }
  
  CDIWork *work = [CDIWork workWithWorkID:workID inManagedObjectContext:context];
  if (!work) {
    work = [NSEntityDescription insertNewObjectForEntityForName:@"CDIWork" inManagedObjectContext:context];
  }
  
  work.workID = workID;
  NSNumber *endDate = dict[@"endDate"];
  NSNumber *startDate = dict[@"startDate"];
  NSNumber *estimatedEndDate = dict[@"estimatedEndDate"];
  
  if (![endDate isKindOfClass:[NSNull class]]) {
    work.endDate = [NSDate dateWithTimeIntervalSince1970:endDate.longLongValue / 1000];
  }
  if (![estimatedEndDate isKindOfClass:[NSNull class]]) {
    work.estimatedEndDate = [NSDate dateWithTimeIntervalSince1970:estimatedEndDate.longLongValue / 1000];
  }
  if (![startDate isKindOfClass:[NSNull class]]) {
    work.startDate = [NSDate dateWithTimeIntervalSince1970:startDate.longLongValue / 1000];
  }
  work.imgURL = [NSString stringForDict:dict key:@"imageUrl"];
  work.linkURL = [NSString stringForDict:dict key:@"linkUrl"];
  work.name = [NSString stringForDict:dict key:@"name"];
  work.nameEn = [NSString stringForDict:dict key:@"name_en"];
  work.previewImageURL = [NSString stringForDict:dict key:@"previewImageUrl"];
  work.videoURL = [NSString stringForDict:dict key:@"videoUrl"];
  work.workInfo = [NSString stringForDict:dict key:@"description"];
  work.workInfoEn = [NSString stringForDict:dict key:@"description_en"];
  work.workStatus = [NSString stringForDict:dict key:@"status"];
  work.workType = [NSString stringForDict:dict key:@"type"];
  
  return work;
}

+ (CDIWork *)workWithWorkID:(NSString *)workID inManagedObjectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  [request setEntity:[NSEntityDescription entityForName:@"CDIWork" inManagedObjectContext:context]];
  [request setPredicate:[NSPredicate predicateWithFormat:@"workID == %@ ", workID]];
  
  NSArray *items = [context executeFetchRequest:request error:NULL];
  CDIWork *res = [items lastObject];
  
  return res;
}

@end
