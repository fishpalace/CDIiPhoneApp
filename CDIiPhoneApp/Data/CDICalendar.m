//
//  CDICalendar.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-23.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CDICalendar.h"
#import "NSDate+Addition.h"

static EKEventStore *eventStore = nil;
static NSMutableArray *eventsArray = nil;

@implementation CDICalendar

+ (EKEventStore *)sharedEventStore
{
  if (eventStore == nil) {
    eventStore = [[EKEventStore alloc] init];
  }
  return eventStore;
}

+ (void)requestAccess:(void (^)(BOOL granted, NSError *error))callback;
{
  // request permissions
  [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:callback];
}

+ (EKEvent *)addEventWithStartDate:(NSDate*)startDate
                      endDate:(NSDate *)endDate
                    withTitle:(NSString*)title
                        inLocation:(NSString*)location;
{
  
  EKEvent *event = [EKEvent eventWithEventStore:eventStore];
//  EKCalendar *calendar = nil;
//  
//  calendar = [eventStore calendarWithIdentifier:@"CDI"];
//  
//  if (!calendar) {
//    calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventStore];
//    
//    [calendar setTitle:@"CDI"];
//    
//    for (EKSource *s in eventStore.sources) {
//      if (s.sourceType == EKSourceTypeCalDAV && [s.title isEqualToString:@"iCloud"] ) {
//        calendar.source = s;
//        break;
//      }
//    }
//
//    NSError *error = nil;
//    [eventStore saveCalendar:calendar commit:YES error:&error];
//  }
  
  event.calendar = [eventStore defaultCalendarForNewEvents];
  event.location = location;
  event.title = title;
  event.startDate = startDate;
  event.endDate = endDate;
  
  NSError *error = nil;
  BOOL result = [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
  if (result) {
    [eventsArray removeAllObjects];
    eventsArray = nil;
    [CDICalendar eventsArray];
  } else {
    event = nil;
  }
  return event;
}

+ (void)deleteEventWitdStoreID:(NSString *)eventStoreID
{
  EKEvent *event = [[CDICalendar sharedEventStore] eventWithIdentifier:eventStoreID];
  NSError *error = nil;
  if (event) {
    [[CDICalendar sharedEventStore] removeEvent:event span:EKSpanThisEvent error:&error];
  }
}

+ (BOOL)doesEventExistInStoreWithID:(NSString *)eventStoreID
{
//  NSLog(@"toCheck: %@", eventStoreID);
//  BOOL result = NO;
//  for (EKEvent *event in [CDICalendar eventsArray]) {
//    if ([event.eventIdentifier isEqualToString:eventStoreID]) {
//      NSLog(@"array: %@", event.eventIdentifier);
//      result = YES;
//      break;
//    }
//  }
  EKEvent *event = [[CDICalendar sharedEventStore] eventWithIdentifier:eventStoreID];
  return event != nil;
}

+ (NSMutableArray *)eventsArray
{
  if (!eventsArray) {
    EKEventStore *eventStore = [CDICalendar sharedEventStore];
    
    NSDate *startDate = [NSDate todayDateStartingFromHour:0];
    NSDate *endDate   = [startDate dateByAddingTimeInterval:3600 * 24 * 2];
    
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:startDate
                                                                 endDate:endDate
                                                               calendars:@[[eventStore defaultCalendarForNewEvents]]];
    eventsArray = [NSMutableArray arrayWithArray:[eventStore eventsMatchingPredicate:predicate]];
  }
  return eventsArray;
}

@end
