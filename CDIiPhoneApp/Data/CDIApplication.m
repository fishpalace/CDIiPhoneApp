//
//  CDIApplication.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-31.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CDIApplication.h"
#import "NSString+Dictionary.h"

@implementation CDIApplication

@dynamic deviceID;
@dynamic applicationID;
@dynamic applicationInfo;
@dynamic deviceStatus;
@dynamic borrowDate;
@dynamic dueDate;
@dynamic returnDate;
@dynamic userID;
@dynamic projectID;
@dynamic userName;
@dynamic projectName;
@dynamic deviceName;
@dynamic userRealName;
@dynamic userAvatarURL;

+ (CDIApplication *)insertApplicationInfoWithDict:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
  if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  NSString *applicationID = [NSString stringForDict:dict key:@"id"];
  
  if (!applicationID || [applicationID isEqualToString:@""]) {
    return nil;
  }
  
  CDIApplication *application = [CDIApplication applicationWithID:applicationID inManagedObjectContext:context];
  if (!application) {
    application = [NSEntityDescription insertNewObjectForEntityForName:@"CDIApplication" inManagedObjectContext:context];
  }
  
  application.applicationID = applicationID;
  
  application.applicationInfo = [NSString stringForDict:dict key:@"description"];
  application.deviceName = [NSString stringForDict:dict key:@"deviceName"];
  application.deviceID = [NSString stringForDict:dict key:@"deviceId"];
  application.userID = [NSString stringForDict:dict key:@"userId"];
  application.userName = [NSString stringForDict:dict key:@"userName"];
  application.userRealName = [NSString stringForDict:dict key:@"userRealName"];
  application.projectID = [NSString stringForDict:dict key:@"workId"];
  application.projectName = [NSString stringForDict:dict key:@"workName"];
  application.userAvatarURL = [NSString stringForDict:dict key:@"userAvatarUrl"];
  
  NSString *status = [NSString stringForDict:dict key:@"status"];
  if ([status isEqualToString:@"APPLYING"]) {
    application.deviceStatus = @"Pending";
  } else if ([status isEqualToString:@"APPROVED"]) {
    application.deviceStatus = @"Approved";
  } else if ([status isEqualToString:@"REJECTED"]) {
    application.deviceStatus = @"Rejected";
  } else if ([status isEqualToString:@"OVERTIME"]) {
    application.deviceStatus = @"Overtime";
  } else if ([status isEqualToString:@"RETURNED"]) {
    application.deviceStatus = @"Returned";
  } else if ([status isEqualToString:@"CANCELLED"]) {
    application.deviceStatus = @"Cancelled";
  }
  
  NSNumber *borrowDate = dict[@"borrowDate"];
  application.borrowDate = [NSDate dateWithTimeIntervalSince1970:borrowDate.longLongValue / 1000];
  
  NSNumber *dueDate = dict[@"shouldReturnDate"];
  application.dueDate = [NSDate dateWithTimeIntervalSince1970:dueDate.longLongValue / 1000];
  
  NSNumber *returnDate = dict[@"returnDate"];
  if (![returnDate isKindOfClass:[NSNull class]]) {
    application.returnDate = [NSDate dateWithTimeIntervalSince1970:returnDate.longLongValue / 1000];
  }
  
  return application;
}

+ (CDIApplication *)applicationWithID:(NSString *)newsID inManagedObjectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  [request setEntity:[NSEntityDescription entityForName:@"CDIApplication" inManagedObjectContext:context]];
  [request setPredicate:[NSPredicate predicateWithFormat:@"applicationID == %@ ", newsID]];
  
  NSArray *items = [context executeFetchRequest:request error:NULL];
  CDIApplication *res = [items lastObject];
  
  return res;
}

@end
