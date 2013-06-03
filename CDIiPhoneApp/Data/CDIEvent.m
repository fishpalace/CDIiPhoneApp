//
//  Event.m
//  CDI_iPad_App
//
//  Created by Gabriel Yeah on 13-3-30.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CDIEvent.h"
#import "NSDate+Addition.h"

static CDIEvent *sharedNewEvent;

@implementation CDIEvent

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
  event.title = title;
  event.isPlaceHolder = YES;
  event.passed = NO;
  return event;
}

+ (void)updateSharedNewEvent:(CDIEvent *)event
{
  CDIEvent *sharedEvent = [CDIEvent sharedNewEvent];
  sharedEvent.eventID = event.eventID;
  sharedEvent.title = event.title;
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
  eventCopy.title = self.title;
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

- (id)initWithDictionary:(NSDictionary *)dict
{
  self = [super init];
  if (self) {
    self.eventID = [self stringForDict:dict key:@"id"];
    self.title = [self stringForDict:dict key:@"title"];
    self.relatedInfo = [self stringForDict:dict key:@"relatedInfo"];
    self.accessKey = [self stringForDict:dict key:@"accessKey"];
    NSNumber *start = dict[@"startDate"];
    NSNumber *end = dict[@"endDate"];
    self.startDate = [NSDate dateWithTimeIntervalSince1970:start.longLongValue / 1000];
    self.endDate = [NSDate dateWithTimeIntervalSince1970:end.longLongValue  / 1000];
    
    NSString *status = dict[@"status"];
    self.passed = [self.endDate earilierThanDate:[NSDate date]];
    self.active = [status isEqualToString:@"ACTIVE"];
    NSDate *ensureEndDate = [self.startDate dateByAddingTimeInterval:30 * 60];
    self.abandoned = !self.active && [ensureEndDate earilierThanDate:[NSDate date]];
    self.isPlaceHolder = NO;
    self.startValue = [self.startDate integerValueForTimePanel];
    self.endValue = [self.endDate integerValueForTimePanel];
  }
  return self;
}

- (NSString *)stringForDict:(NSDictionary *)dict key:(NSString *)key
{
  return [dict[key] isKindOfClass:[NSNull class]] ? @"" : dict[key];
}

@end
