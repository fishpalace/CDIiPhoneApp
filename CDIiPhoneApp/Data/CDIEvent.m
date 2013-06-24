//
//  CDIEvent.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-20.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CDIEvent.h"
#import "CDIUser.h"

#import "NSDate+Addition.h"

static CDIEvent *sharedNewEvent;

@implementation CDIEvent

@dynamic abandoned;
@dynamic accessKey;
@dynamic active;
@dynamic endDate;
@dynamic endValue;
@dynamic eventID;
@dynamic eventStoreID;
@dynamic isPlaceHolder;
@dynamic name;
@dynamic passed;
@dynamic relatedInfo;
@dynamic roomID;
@dynamic startDate;
@dynamic startValue;
@dynamic occupiedByA;
@dynamic occupiedByB;
@dynamic occupiedByC;
@dynamic occupiedByD;
@dynamic updateTime;
@dynamic creator;

+ (CDIEvent *)sharedNewEvent
{
  if (!sharedNewEvent) {
    sharedNewEvent = [[CDIEvent alloc] init];
  }
  return sharedNewEvent;
}

+ (id)eventInstanceWithTitle:(NSString *)title
{
  CDIEvent *event = [[CDIEvent alloc] init];
  event.name = title;
  event.isPlaceHolder = @YES;
  event.passed = NO;
  return event;
}

+ (void)updateSharedNewEvent:(CDIEvent *)event
{
  CDIEvent *sharedEvent = [CDIEvent sharedNewEvent];
  sharedEvent.eventID = event.eventID;
  sharedEvent.name = event.name;
  sharedEvent.relatedInfo = event.relatedInfo;
  sharedEvent.startDate = event.startDate;
  sharedEvent.endDate = event.endDate;
  sharedEvent.passed = event.passed;
  sharedEvent.active = event.active;
  sharedEvent.isPlaceHolder = event.isPlaceHolder;
  sharedEvent.startValue = event.startValue;
  sharedEvent.endValue = event.endValue;
  sharedEvent.accessKey = event.accessKey;
  sharedEvent.abandoned = event.abandoned;
  sharedEvent.roomID = event.roomID;
}

- (id)eventCopy
{
  CDIEvent *eventCopy = [[CDIEvent alloc] init];
  eventCopy.eventID = self.eventID;
  eventCopy.name = self.name;
  eventCopy.relatedInfo = self.relatedInfo;
  eventCopy.startDate = self.startDate;
  eventCopy.endDate = self.endDate;
  eventCopy.passed = self.passed;
  eventCopy.active = self.active;
  eventCopy.isPlaceHolder = self.isPlaceHolder;
  eventCopy.startValue = self.startValue;
  eventCopy.endValue = self.endValue;
  eventCopy.accessKey = self.accessKey;
  eventCopy.abandoned = self.abandoned;
  eventCopy.roomID = self.roomID;
  return eventCopy;
}

+ (CDIEvent *)insertUserInfoWithDict:(NSDictionary *)dict
                          updateTime:(NSDate *)updateTime
              inManagedObjectContext:(NSManagedObjectContext *)context
{
  if (![dict isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  NSNumber *eventIDNumber = [dict[@"id"] isKindOfClass:[NSNull class]] ? @"" : dict[@"id"];
  NSString *eventID = eventIDNumber.stringValue;
  if (!eventID || [eventID isEqualToString:@""]) {
    return nil;
  }
  
  CDIEvent *event = [CDIEvent eventWithID:eventID inManagedObjectContext:context];
  if (!event) {
    event = [NSEntityDescription insertNewObjectForEntityForName:@"CDIEvent" inManagedObjectContext:context];
  }
  
  [event configureWithDictionary:dict];
  event.updateTime = updateTime;
  
  return event;
}

+ (CDIEvent *)eventWithID:(NSString *)eventID inManagedObjectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  [request setEntity:[NSEntityDescription entityForName:@"CDIEvent" inManagedObjectContext:context]];
  [request setPredicate:[NSPredicate predicateWithFormat:@"eventID == %@ ", eventID]];
  
  NSArray *items = [context executeFetchRequest:request error:NULL];
  CDIEvent *res = [items lastObject];
  
  return res;
}

+ (void)updateEventStoreID:(NSString *)eventStoreID
            forEventWithID:(NSString *)eventID
    inManagedObjectContext:(NSManagedObjectContext *)context
{
  CDIEvent *event = [CDIEvent eventWithID:eventID inManagedObjectContext:context];
  event.eventStoreID = eventStoreID;
}

+ (void)removeEventsOlderThanUpdateDate:(NSDate *)updateDate inManagedObjectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  [request setEntity:[NSEntityDescription entityForName:@"CDIEvent" inManagedObjectContext:context]];
  NSArray *items = [context executeFetchRequest:request error:NULL];
  for (CDIEvent *event in items) {
    if (![event.updateTime isEqualToDate:updateDate]) {
      [context deleteObject:event];
    }
  }
  [context processPendingChanges];
}

- (id)initWithDictionary:(NSDictionary *)dict
{
  self = [super init];
  if (self) {
    [self configureWithDictionary:dict];
  }
  return self;
}

- (void)configureWithDictionary:(NSDictionary *)dict
{
  self.eventID = [self stringForDict:dict key:@"id"];
  self.name = [self stringForDict:dict key:@"title"];
  self.relatedInfo = [self stringForDict:dict key:@"relatedInfo"];
  self.accessKey = [self stringForDict:dict key:@"accessKey"];
  NSNumber *start = dict[@"startDate"];
  NSNumber *end = dict[@"endDate"];
  self.startDate = [NSDate dateWithTimeIntervalSince1970:start.longLongValue / 1000];
  self.endDate = [NSDate dateWithTimeIntervalSince1970:end.longLongValue  / 1000];
  
  NSString *status = dict[@"status"];
  NSDate *ensureEndDate = [self.startDate dateByAddingTimeInterval:30 * 60];
  BOOL passed = [self.endDate earilierThanDate:[NSDate date]];
  BOOL active = [status isEqualToString:@"ACTIVE"];
  BOOL abandoned = !active && [ensureEndDate earilierThanDate:[NSDate date]];
  self.passed = [NSNumber numberWithBool:passed];
  self.active = [NSNumber numberWithBool:active];
  self.abandoned = [NSNumber numberWithBool:abandoned];
  self.isPlaceHolder = NO;
  
  NSArray *roomListArray = dict[@"roomIdList"];
  if ([roomListArray isKindOfClass:[NSArray class]]) {
    for (NSNumber *roomID in roomListArray) {
      self.roomID = roomID;
    }
    
    self.occupiedByA = @([roomListArray containsObject:@1]);
    self.occupiedByB = @([roomListArray containsObject:@2]);
    self.occupiedByC = @([roomListArray containsObject:@3]);
    self.occupiedByD = @([roomListArray containsObject:@4]);
  }

  NSInteger startValue = [self.startDate integerValueForTimePanel];
  NSInteger endValue = [self.endDate integerValueForTimePanel];
  self.startValue = [NSNumber numberWithInt:startValue];
  self.endValue = [NSNumber numberWithInt:endValue];
}

#pragma mark - Tool Methods
- (NSString *)stringForDict:(NSDictionary *)dict key:(NSString *)key
{
  NSObject *result = [dict[key] isKindOfClass:[NSNull class]] ? @"" : dict[key];
  NSString *stringValue = (NSString *)result;
  if ([result isKindOfClass:[NSNumber class]]) {
    stringValue = ((NSNumber *)result).stringValue;
  }
  return stringValue;
}


@end
