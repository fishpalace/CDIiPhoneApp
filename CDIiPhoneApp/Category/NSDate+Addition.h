//
//  NSDate+Addition.h
//  CDI_iPad_App
//
//  Created by Gabriel Yeah on 13-3-30.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addition)

+ (NSString *)stringOfDateWithIntervalFromCurrentDate:(NSInteger)interval;

+ (NSString *)stringOfCurrentDate;

- (NSString *)stringExpression;

+ (NSString *)stringFromDate:(NSDate *)fromDate
                      toDate:(NSDate *)toDate
                   inChinese:(BOOL)inChinese;

+ (NSString *)stringOfDate:(NSDate *)date displayingWeekday:(BOOL)displayingWeekday;

+ (NSDate *)todayDateStartingFromHour:(NSInteger)hour;

- (NSInteger)integerValueForTimePanel;

+ (NSDate *)dateFromeIntegerValue:(NSInteger)value forToday:(BOOL)forToday;

+ (NSDate *)tomorrowDate;

- (NSDate *)dateWithoutTime;

- (NSString *)todayOrTomorrowString;

- (NSString *)intervalToNowString;

- (BOOL)earilierThanDate:(NSDate *)date;

+ (NSString *)weekdayStringForDate:(NSDate *)date;

+ (NSString *)stringOfDate:(NSDate *)date includingYear:(BOOL)includingYear;

+ (NSString *)stringOfTime:(NSDate *)date;

@end
