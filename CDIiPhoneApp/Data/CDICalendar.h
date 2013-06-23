//
//  CDICalendar.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-23.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@import EventKit;

@interface CDICalendar : NSObject

+ (void)requestAccess:(void (^)(BOOL granted, NSError *error))success;

+ (EKEvent *)addEventWithStartDate:(NSDate*)startDate
                           endDate:(NSDate *)endDate
                         withTitle:(NSString*)title
                        inLocation:(NSString*)location;

+ (void)deleteEventWitdStoreID:(NSString *)eventStoreID;

+ (BOOL)doesEventExistInStoreWithID:(NSString *)eventStoreID;

@end
