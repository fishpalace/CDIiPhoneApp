//
//  NSDate+Addition.m
//  CDI_iPad_App
//
//  Created by Gabriel Yeah on 13-3-30.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (Addition)

+ (NSString *)stringOfDateWithIntervalFromCurrentDate:(NSInteger)interval
{
  NSDate *today = [[NSDate todayDateStartingFromHour:0] dateByAddingTimeInterval:interval];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd%20HH:mm:ss"];
  return [dateFormatter stringFromDate:today];
}

+ (NSString *)stringOfCurrentDate
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd%20HH:mm:ss"];
  return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)stringOfDate:(NSDate *)date
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringOfTime:(NSDate *)date
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"HH:mm"];
  return [dateFormatter stringFromDate:date];
}

- (NSString *)stringExpression
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd%20HH:mm:ss"];
  return [dateFormatter stringFromDate:self];
}

+ (NSString *)stringFromDate:(NSDate *)fromDate
                      toDate:(NSDate *)toDate
                   inChinese:(BOOL)inChinese
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"HH:mm"];
  NSString *fromDateString = [dateFormatter stringFromDate:fromDate];
  NSString *toDateString = [dateFormatter stringFromDate:toDate];
  NSString *connectionString = inChinese ? @"到" : @"-";
  return [NSString stringWithFormat:@"%@ %@ %@", fromDateString, connectionString, toDateString];
}

- (NSDate *)dateWithoutTime
{
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit)
                                                   fromDate:self];
  NSInteger theDay = [todayComponents day];
  NSInteger theMonth = [todayComponents month];
  NSInteger theYear = [todayComponents year];
  
  NSDateComponents *components = [[NSDateComponents alloc] init];
  [components setDay:theDay];
  [components setMonth:theMonth];
  [components setYear:theYear];
  [components setHour:0];
  [components setMinute:0];
  [components setSecond:0];
  
  return [gregorian dateFromComponents:components];
}

+ (NSDate *)todayDateStartingFromHour:(NSInteger)hour
{
  NSDate *now = [NSDate date];
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit)
                                                   fromDate:now];
  NSInteger theDay = [todayComponents day];
  NSInteger theMonth = [todayComponents month];
  NSInteger theYear = [todayComponents year];
  
  NSDateComponents *components = [[NSDateComponents alloc] init];
  [components setDay:theDay];
  [components setMonth:theMonth];
  [components setYear:theYear];
  [components setHour:hour];
  [components setMinute:0];
  [components setSecond:0];
  
  return [gregorian dateFromComponents:components];
}

+ (NSString *)stringOfDate:(NSDate *)date displayingWeekday:(BOOL)displayingWeekday
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.timeZone = [NSTimeZone localTimeZone];
  
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit)
                                              fromDate:date];
  
  
  NSString *timeString = [NSString stringWithFormat:@"%d月%d日", [components month], [components day]];
  if (displayingWeekday) {
    NSString *weekDayString = @"周";
    switch ([components weekday]) {
      case 1: weekDayString = @" 周日"; break;
      case 2: weekDayString = @" 周一"; break;
      case 3: weekDayString = @" 周二"; break;
      case 4: weekDayString = @" 周三"; break;
      case 5: weekDayString = @" 周四"; break;
      case 6: weekDayString = @" 周五"; break;
      case 7: weekDayString = @" 周六"; break;
      default:
        break;
    }
    timeString = [timeString stringByAppendingString:weekDayString];
  }
  return timeString;
}

- (NSInteger)integerValueForTimePanel
{
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *todayComponents = [gregorian components:(NSMinuteCalendarUnit | NSHourCalendarUnit) fromDate:self];
  NSInteger hour = [todayComponents hour];
  NSInteger minutes = [todayComponents minute];
  NSInteger delta = minutes % 15 == 0 ? 0 : 1;
  NSInteger value = (hour - 8) * 4 + minutes / 15 + delta;
  
  return value;
}

+ (NSDate *)dateFromeIntegerValue:(NSInteger)value forToday:(BOOL)forToday
{
  NSDate *standardDate = nil;
  if (forToday) {
    standardDate = [NSDate todayDateStartingFromHour:0];
  } else {
    standardDate = [[NSDate todayDateStartingFromHour:0] dateByAddingTimeInterval:3600 * 24];
  }
  return [standardDate dateByAddingTimeInterval:value * 15 * 60 + 8 * 3600];
}

+ (NSDate *)tomorrowDate
{
  return [[NSDate todayDateStartingFromHour:0] dateByAddingTimeInterval:3600 * 24];
}

- (NSString *)todayOrTomorrowString
{
  NSString *todayOrTomorrowString = nil;
  NSDate *todayDate = [[NSDate date] dateWithoutTime];
  if ([todayDate isEqualToDate:[self dateWithoutTime]]) {
    todayOrTomorrowString = @"Today";
  } else {
    todayOrTomorrowString = @"Tomorrow";
  }
  return todayOrTomorrowString;
}

- (NSString *)intervalToNowString
{
  NSString *intervalString = nil;
  NSInteger minutes = [self timeIntervalSinceNow] / 60;
  if (minutes < 60) {
    intervalString = [NSString stringWithFormat:@"%d分钟", minutes + 1];
  } else {
    intervalString = [NSString stringWithFormat:@"%d小时", minutes / 60];
  }

  return intervalString;
}

+ (NSString *)weekdayStringForDate:(NSDate *)date
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.timeZone = [NSTimeZone localTimeZone];
  
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit)
                                              fromDate:date];
  
  
  NSString *weekdayString = nil;
  switch ([components weekday]) {
    case 1: weekdayString = @"Sunday"; break;
    case 2: weekdayString = @"Monday"; break;
    case 3: weekdayString = @"Tuesday"; break;
    case 4: weekdayString = @"Wednesday"; break;
    case 5: weekdayString = @"Thursday"; break;
    case 6: weekdayString = @"Friday"; break;
    case 7: weekdayString = @"Saturday"; break;
    default:
      break;
  }
  return weekdayString;
}

- (BOOL)earilierThanDate:(NSDate *)date
{
  return [[self earlierDate:date] isEqualToDate:self];
}

@end
