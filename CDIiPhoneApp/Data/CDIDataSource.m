//
//  CDIEventDataSource.m
//  CDI_iPad_App
//
//  Created by Gabriel Yeah on 13-3-31.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CDIDataSource.h"
#import "NSDate+Addition.h"
#import "CDIEvent.h"
#import "CDINetClient.h"
#import "NSNotificationCenter+Addition.h"

@interface CDIDataSource ()

@property (nonatomic, strong) NSMutableArray *roomAtodayEvents;
@property (nonatomic, strong) NSMutableArray *roomAtomorrowEvents;
@property (nonatomic, strong) NSMutableArray *roomBtodayEvents;
@property (nonatomic, strong) NSMutableArray *roomBtomorrowEvents;
@property (nonatomic, strong) NSMutableArray *roomCtodayEvents;
@property (nonatomic, strong) NSMutableArray *roomCtomorrowEvents;
@property (nonatomic, strong) NSMutableArray *roomDtodayEvents;
@property (nonatomic, strong) NSMutableArray *roomDtomorrowEvents;
@property (nonatomic, strong) NSTimer *eventTimer;
@property (nonatomic, strong) NSTimer *roomInfoTimer;
@property (nonatomic, strong) NSString *currentRoomName;
@property (nonatomic, assign) NSInteger currentRoomID;

@end

static CDIDataSource *sharedDataSource;

@implementation CDIDataSource

+ (CDIDataSource *)sharedDataSource
{
  if (!sharedDataSource) {
    sharedDataSource = [[CDIDataSource alloc] init];
  }
  return sharedDataSource;
}

+ (NSString *)currentRoomName
{
  return [[CDIDataSource sharedDataSource] currentRoomName];
}

- (id)init
{
  self = [super init];
  if (self) {
    [self.eventTimer fire];
    [self.roomInfoTimer fire];
  }
  return self;
}

+ (NSArray *)todayEventsForRoomID:(NSInteger)roomID
{
  CDIDataSource *dataSource = [CDIDataSource sharedDataSource];
  NSArray *result = nil;
  switch (roomID) {
    case 1:
      result = dataSource.roomAtodayEvents;
      break;
    case 2:
      result = dataSource.roomBtodayEvents;
      break;
    case 3:
      result = dataSource.roomCtodayEvents;
      break;
    case 4:
      result = dataSource.roomDtodayEvents;
      break;
    default:
      result = dataSource.roomAtodayEvents;
      break;
  }
  return result;
}

+ (NSArray *)tomorrowEventsForRoomID:(NSInteger)roomID
{
  CDIDataSource *dataSource = [CDIDataSource sharedDataSource];
  NSArray *result = nil;
  switch (roomID) {
    case 1:
      result = dataSource.roomAtomorrowEvents;
      break;
    case 2:
      result = dataSource.roomBtomorrowEvents;
      break;
    case 3:
      result = dataSource.roomCtomorrowEvents;
      break;
    case 4:
      result = dataSource.roomDtomorrowEvents;
      break;
    default:
      result = dataSource.roomAtomorrowEvents;
      break;
  }
  return result;
}

+ (NSInteger)futureEventCount
{
  NSInteger futureEventCount = 0;
  NSArray *events = [CDIDataSource todayEventsForRoomID:1];
  for (CDIEvent *event in events) {
    if (!event.passed) {
      futureEventCount++;
    }
  }
  return futureEventCount;
}

- (void)fetchData:(NSTimer *)timer
{
  [self fetchDataWithCompletion:nil];
}

- (void)fetchRoomInfo:(NSTimer *)timer
{
  CDINetClient *client = [CDINetClient client];
  __weak CDIDataSource *weakSelf = self;
  void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
    if ([responseData isKindOfClass:[NSDictionary class]]) {
      NSDictionary *dict = responseData;
      if ([dict[@"data"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dataDict = dict[@"data"];
        weakSelf.currentRoomName = dataDict[@"name"];
      }
    } else {
      [weakSelf fetchRoomInfo:nil];
    }
  };
  
  [client getRoomInfoByRoomId:[CDIDataSource currentRoomID]
                   completion:handleData];
}

+ (void)fetchDataWithCompletion:(void (^)(BOOL succeeded, id responseData))completion
{
  [[CDIDataSource sharedDataSource] fetchDataWithCompletion:completion];
}

- (void)fetchDataWithCompletion:(void (^)(BOOL succeeded, id responseData))completion
{
  [self fetchDataForID:1 todayArray:self.roomAtodayEvents tomorrowArray:self.roomAtomorrowEvents];
  [self fetchDataForID:2 todayArray:self.roomBtodayEvents tomorrowArray:self.roomBtomorrowEvents];
  [self fetchDataForID:3 todayArray:self.roomCtodayEvents tomorrowArray:self.roomCtomorrowEvents];
  [self fetchDataForID:4 todayArray:self.roomDtodayEvents tomorrowArray:self.roomDtomorrowEvents];
}

- (void)fetchDataForID:(NSInteger)roomID
            todayArray:(NSMutableArray *)todayArray
         tomorrowArray:(NSMutableArray *)tomorrowArray
{
  NSString *toDate = [NSDate stringOfDateWithIntervalFromCurrentDate:0];
  NSString *fromDate = [NSDate stringOfDateWithIntervalFromCurrentDate:3600 * 24];
  CDINetClient *client = [CDINetClient client];
  void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
    if ([responseData isKindOfClass:[NSDictionary class]]) {
      NSDictionary *dict = responseData;
      if ([dict[@"data"] isKindOfClass:[NSArray class]]) {
        [self setUpEventsForToday:dict[@"data"] array:todayArray];
      }
    }
  };
  
  [client getEventListByRoomId:roomID
                      fromDate:fromDate
                        toDate:toDate
                    completion:handleData];
  
  NSString *toDateForTomorrow = [NSDate stringOfDateWithIntervalFromCurrentDate:3600 * 24];
  NSString *fromDateForTomorrow = [NSDate stringOfDateWithIntervalFromCurrentDate:7200 * 24];
  void (^handleData2)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
    if ([responseData isKindOfClass:[NSDictionary class]]) {
      NSDictionary *dict = responseData;
      if ([dict[@"data"] isKindOfClass:[NSArray class]]) {
        [self setUpEventsForTomorrow:dict[@"data"] array:tomorrowArray];
      }
    }
  };
  
  [client getEventListByRoomId:roomID
                      fromDate:fromDateForTomorrow
                        toDate:toDateForTomorrow
                    completion:handleData2];
}

- (void)setUpEventsForToday:(NSArray *)array array:(NSMutableArray *)todayArray
{
  [todayArray removeAllObjects];
  for (NSDictionary *dict in array) {
    CDIEvent *event = [[CDIEvent alloc] initWithDictionary:dict];
    if (!event.abandoned) {
      [todayArray addObject:event];
    }
  }
//  [NSNotificationCenter postDidFetchNewEventsNotification];
  //TODO Send fetch new events notification

}

- (void)setUpEventsForTomorrow:(NSArray *)array array:(NSMutableArray *)tomorrowArray
{
  [tomorrowArray removeAllObjects];
  for (NSDictionary *dict in array) {
    CDIEvent *event = [[CDIEvent alloc] initWithDictionary:dict];
    if (!event.abandoned) {
      [tomorrowArray addObject:event];
    }
  }
}

#pragma mark - Properties
+ (NSInteger)currentRoomID
{
  return 1;
}

- (NSMutableArray *)roomAtodayEvents
{
  if (!_roomAtodayEvents) {
    _roomAtodayEvents = [NSMutableArray array];
  }
  return _roomAtodayEvents;
}

- (NSMutableArray *)roomAtomorrowEvents
{
  if (!_roomAtomorrowEvents) {
    _roomAtomorrowEvents = [NSMutableArray array];
  }
  return _roomAtomorrowEvents;
}

- (NSMutableArray *)roomBtodayEvents
{
  if (!_roomBtodayEvents) {
    _roomBtodayEvents = [NSMutableArray array];
  }
  return _roomBtodayEvents;
}

- (NSMutableArray *)roomBtomorrowEvents
{
  if (!_roomBtomorrowEvents) {
    _roomBtomorrowEvents = [NSMutableArray array];
  }
  return _roomBtomorrowEvents;
}

- (NSMutableArray *)roomCtodayEvents
{
  if (!_roomCtodayEvents) {
    _roomCtodayEvents = [NSMutableArray array];
  }
  return _roomCtodayEvents;
}

- (NSMutableArray *)roomCtomorrowEvents
{
  if (!_roomCtomorrowEvents) {
    _roomCtomorrowEvents = [NSMutableArray array];
  }
  return _roomCtomorrowEvents;
}

- (NSMutableArray *)roomDtodayEvents
{
  if (!_roomDtodayEvents) {
    _roomDtodayEvents = [NSMutableArray array];
  }
  return _roomDtodayEvents;
}

- (NSMutableArray *)roomDtomorrowEvents
{
  if (!_roomDtomorrowEvents) {
    _roomDtomorrowEvents = [NSMutableArray array];
  }
  return _roomDtomorrowEvents;
}

- (NSTimer *)eventTimer
{
  if (!_eventTimer) {
    _eventTimer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                              target:self
                                            selector:@selector(fetchData:)
                                            userInfo:nil
                                             repeats:YES];
  }
  return _eventTimer;
}

- (NSTimer *)roomInfoTimer
{
  if (!_roomInfoTimer) {
    _roomInfoTimer = [NSTimer scheduledTimerWithTimeInterval:3600 * 24
                                                      target:self
                                                    selector:@selector(fetchRoomInfo:)
                                                    userInfo:nil
                                                     repeats:YES];
  }
  return _roomInfoTimer;
}

- (NSString *)currentRoomName
{
  if (!_currentRoomName) {
    _currentRoomName = [NSString string];
  }
  return _currentRoomName;
}

@end
