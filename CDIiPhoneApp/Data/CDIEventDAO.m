//
//  CDIEventDAO.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-20.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CDIEventDAO.h"
#import "CDIUser.h"
#import "CDIEvent.h"

#import "NSDate+Addition.h"

static CDIEventDAO *sharedNewEvent;

@implementation CDIEventDAO

+ (CDIEventDAO *)sharedNewEvent
{
    if (!sharedNewEvent) {
        sharedNewEvent = [[CDIEventDAO alloc] init];
    }
    return sharedNewEvent;
}

+ (id)eventInstanceWithTitle:(NSString *)title
{
    CDIEventDAO *event = [[CDIEventDAO alloc] init];
    event.name = title;
    event.isPlaceHolder = @YES;
    event.passed = NO;
    return event;
}

+ (id)eventDAOInstanceWithEvent:(CDIEvent *)event
{
    CDIEventDAO *eventCopy = [[CDIEventDAO alloc] init];
    eventCopy.eventID = event.eventID;
    eventCopy.eventStoreID = event.eventStoreID;
    eventCopy.name = event.name;
    eventCopy.relatedInfo = event.relatedInfo;
    eventCopy.relatedDescription = event.relatedDescription;
    eventCopy.startDate = event.startDate;
    eventCopy.endDate = event.endDate;
    eventCopy.passed = event.passed;
    eventCopy.active = event.active;
    eventCopy.isPlaceHolder = event.isPlaceHolder;
    eventCopy.startValue = event.startValue;
    eventCopy.endValue = event.endValue;
    eventCopy.accessKey = event.accessKey;
    eventCopy.abandoned = event.abandoned;
    eventCopy.roomID = event.roomID;
    eventCopy.updateTime = event.updateTime;
    eventCopy.imageURL = event.imageURL;
    eventCopy.previewImageURL = event.previewImageURL;
    eventCopy.type = event.type;
    eventCopy.eventType = event.eventType;
    eventCopy.typeOrigin = event.typeOrigin;
    return eventCopy;
}

+ (void)updateSharedNewEvent:(CDIEventDAO *)event
{
    CDIEventDAO *sharedEvent = [CDIEventDAO sharedNewEvent];
    sharedEvent.eventID = event.eventID;
    sharedEvent.name = event.name;
    sharedEvent.relatedInfo = event.relatedInfo;
    sharedEvent.relatedDescription = event.relatedDescription;
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
    sharedEvent.updateTime = event.updateTime;
    sharedEvent.imageURL = event.imageURL;
    sharedEvent.previewImageURL = event.previewImageURL;
    sharedEvent.type = event.type;
    sharedEvent.eventType = event.eventType;
    sharedEvent.typeOrigin = event.typeOrigin;
    
    sharedNewEvent.eventJustCreated = NO;
}

- (id)eventCopy
{
    CDIEventDAO *eventCopy = [[CDIEventDAO alloc] init];
    eventCopy.eventID = self.eventID;
    eventCopy.eventStoreID = self.eventStoreID;
    eventCopy.name = self.name;
    eventCopy.relatedInfo = self.relatedInfo;
    eventCopy.relatedDescription = self.relatedDescription;
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
    eventCopy.updateTime = self.updateTime;
    eventCopy.imageURL = self.imageURL;
    eventCopy.previewImageURL = self.previewImageURL;
    eventCopy.type = self.type;
    eventCopy.eventType = self.eventType;
    eventCopy.typeOrigin = self.typeOrigin;
    return eventCopy;
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
    self.relatedInfo = [self stringForDict:dict key:@"description"];
    self.relatedDescription = [self stringForDict:dict key:@"relatedInfo"];
    self.accessKey = [self stringForDict:dict key:@"accessKey"];
    NSNumber *start = dict[@"startDate"];
    NSNumber *end = dict[@"endDate"];
    self.startDate = [NSDate dateWithTimeIntervalSince1970:start.longValue / 1000];
    self.endDate = [NSDate dateWithTimeIntervalSince1970:end.longValue  / 1000];
    
    NSString *status = dict[@"status"];
    NSDate *ensureEndDate = [self.startDate dateByAddingTimeInterval:30 * 60];
    BOOL passed = [self.endDate earilierThanDate:[NSDate date]];
    BOOL active = [status isEqualToString:@"ACTIVE"];
    BOOL abandoned = !active && [ensureEndDate earilierThanDate:[NSDate date]];
    self.passed = [NSNumber numberWithBool:passed];
    self.active = [NSNumber numberWithBool:active];
    self.abandoned = [NSNumber numberWithBool:abandoned];
    self.isPlaceHolder = NO;
    
    NSInteger startValue = [self.startDate integerValueForTimePanel];
    NSInteger endValue = [self.endDate integerValueForTimePanel];
    self.startValue = [NSNumber numberWithInt:startValue];
    self.endValue = [NSNumber numberWithInt:endValue];
}

#pragma mark - Tool Methods
- (NSString *)stringForDict:(NSDictionary *)dict key:(NSString *)key
{
    return [dict[key] isKindOfClass:[NSNull class]] ? @"" : dict[key];
}

@end