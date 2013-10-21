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
    @dynamic workTypeOrigin;

+ (void)removeAllWorksInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"CDIWork" inManagedObjectContext:context]];
    NSArray *items = [context executeFetchRequest:request error:NULL];
    for (CDIWork *works in items) {
        [context deleteObject:works];
    }
    [context processPendingChanges];
}

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
        NSNumber *endDate;
        NSNumber *startDate;
        if ((NSNull *)dict[@"startDate"] == [NSNull null]) {
            startDate = [NSNumber numberWithLong:0];
        }
        else
        {
            startDate = dict[@"startDate"];
        }
        
        if ((NSNull *)dict[@"endDate"] == [NSNull null]) {
            endDate = [NSNumber numberWithLong:0];
        }
        else
        {
            endDate = dict[@"endDate"];
        }
        
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
        NSString *info = [NSString stringForDict:dict key:@"description"];
        work.workInfo = [info strippedHTMLString];
        work.workInfoEn = [NSString stringForDict:dict key:@"description_en"];
        work.workStatus = [NSString stringForDict:dict key:@"status"];
        if ([work.workStatus isEqualToString:@"IN_PLAN"]) {
            if (kIsChinese) {
                work.workStatus = @"计划中";
            } else {
                work.workStatus = @"In plan";
            }
        } else if ([work.workStatus isEqualToString:@"IN_PROGRESS"]) {
            if (kIsChinese) {
                work.workStatus = @"进行中";
            } else {
                work.workStatus = @"In progress";
            }
        } else if ([work.workStatus isEqualToString:@"ON_SHOW"]) {
            if (kIsChinese) {
                work.workStatus = @"展出中";
            } else {
                work.workStatus = @"On show";
            }
        } else if ([work.workStatus isEqualToString:@"COMPLETED"]) {
            if (kIsChinese) {
                work.workStatus = @"已完成";
            } else {
                work.workStatus = @"Completed";
            }
        }
        work.workTypeOrigin = [NSString stringForDict:dict key:@"type"];
        if ([work.workTypeOrigin isEqualToString:@"TANGIBLE_INTERACTIVE_OBJECTS"]) {
            if (kIsChinese) {
                work.workType = @"交互装置";
            } else {
                work.workType = @"Tangible Interactive Objects";
            }
        } else if ([work.workTypeOrigin isEqualToString:@"APPLICATION_SYSTEM"]) {
            if (kIsChinese) {
                work.workType = @"应用";
            } else {
                work.workType = @"Application System";
            }
        } else if ([work.workTypeOrigin isEqualToString:@"RESEARCH"]) {
            if (kIsChinese) {
                work.workType = @"学术研究";
            } else {
                work.workType = @"Research";
            }
            
        }
        
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
