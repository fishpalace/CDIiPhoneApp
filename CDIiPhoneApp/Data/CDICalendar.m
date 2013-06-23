//
//  CDICalendar.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-23.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CDICalendar.h"

@import EventKit;

static EKEventStore *eventStore = nil;

@implementation CDICalendar

+ (void)requestAccess:(void (^)(BOOL granted, NSError *error))callback;
{
  if (eventStore == nil) {
    eventStore = [[EKEventStore alloc] init];
  }
  // request permissions
  [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:callback];
}

+ (BOOL)addEventWithStartDate:(NSDate*)startDate
                      endDate:(NSDate *)endDate
                    withTitle:(NSString*)title
                   inLocation:(NSString*)location
                      eventID:(NSString *)eventID
{
  
  EKEvent *event = [EKEvent eventWithEventStore:eventStore];
  EKCalendar *calendar = nil;
//  NSString *calendarIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:@"my_calendar_identifier"];
  
//  // when identifier exists, my calendar probably already exists
//  // note that user can delete my calendar. In that case I have to create it again.
//  if (calendarIdentifier) {
//    calendar = [eventStore calendarWithIdentifier:calendarIdentifier];
//  }
  
  calendar = [eventStore calendarWithIdentifier:@"CDI"];
  
  if (!calendar) {
    calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventStore];
    
    [calendar setTitle:@"CDI"];
    
    for (EKSource *s in eventStore.sources) {
      if (s.sourceType == EKSourceTypeLocal) {
        calendar.source = s;
        break;
      }
    }

    NSError *error = nil;
    [eventStore saveCalendar:calendar commit:YES error:&error];
  }
  
  // assign basic information to the event; location is optional
  event.calendar = [eventStore defaultCalendarForNewEvents];
  event.location = location;
  event.title = title;
  
  // set the start date to the current date/time and the event duration to two hours
  event.startDate = startDate;
  event.endDate = endDate;
  
  NSError *error = nil;
  // save event to the callendar
  BOOL result = [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
  return result;
}

@end
