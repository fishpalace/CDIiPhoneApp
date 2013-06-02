//
//  CDIEventDataSource.h
//  CDI_iPad_App
//
//  Created by Gabriel Yeah on 13-3-31.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  CDIRoomStatusAvailable,
  CDIRoomStatusBusy,
  CDIRoomStatusUnavailable,
} CDIRoomStatus;

@interface CDIDataSource : NSObject

+ (void)fetchDataWithCompletion:(void (^)(BOOL succeeded, id responseData))completion;

+ (NSArray *)todayEventsForRoomID:(NSInteger)roomID;

+ (NSArray *)tomorrowEventsForRoomID:(NSInteger)roomID;

+ (NSInteger)futureEventCount;

+ (NSString *)currentRoomName;

+ (NSArray *)todayTimeZonesWithRoomID:(NSInteger)roomID;

+ (NSArray *)tomorrowTimeZonesWithRoomID:(NSInteger)roomID;

+ (NSInteger)availablePercentageWithRoomID:(NSInteger)roomID isToday:(BOOL)isToday;

+ (CDIRoomStatus)statusForRoom:(NSInteger)roomID isToday:(BOOL)isToday;

@end
