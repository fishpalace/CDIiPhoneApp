//
//  CDIEventDataSource.h
//  CDI_iPad_App
//
//  Created by Gabriel Yeah on 13-3-31.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDIEventDAO.h"
@import CoreData;

typedef enum {
  CDIRoomStatusAvailable,
  CDIRoomStatusBusy,
  CDIRoomStatusUnavailable,
} CDIRoomStatus;

@interface CDIDataSource : NSObject <NSFetchedResultsControllerDelegate>

+ (void)fetchDataWithCompletion:(void (^)(BOOL succeeded, id responseData))completion;

+ (NSArray *)todayEventsForRoomID:(NSInteger)roomID;

+ (NSArray *)tomorrowEventsForRoomID:(NSInteger)roomID;

+ (NSInteger)futureEventCount;

+ (NSString *)currentRoomName;

+ (NSInteger)currentReservationCount;

+ (NSArray *)todayTimeZonesWithRoomID:(NSInteger)roomID;

+ (NSArray *)tomorrowTimeZonesWithRoomID:(NSInteger)roomID;

+ (NSString *)nameForRoomID:(NSInteger)roomID;

+ (NSInteger)availablePercentageWithRoomID:(NSInteger)roomID isToday:(BOOL)isToday;

+ (CDIRoomStatus)statusForRoom:(NSInteger)roomID isToday:(BOOL)isToday;

+ (CDIEventDAO *)nextEventForRoomID:(NSInteger)roomID;

+ (void)reFetchAllDataInMainPanel;

+ (void)reFetchRoomInfoInMainPanelwithCompletion:(void(^)(void))completion;
@end
