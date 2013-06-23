//
//  CDICalendar.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-23.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDICalendar : NSObject

+ (void)requestAccess:(void (^)(BOOL granted, NSError *error))success;
+ (BOOL)addEventWithStartDate:(NSDate*)startDate
                      endDate:(NSDate *)endDate
                    withTitle:(NSString*)title
                   inLocation:(NSString*)location
                      eventID:(NSString *)eventID;

@end
