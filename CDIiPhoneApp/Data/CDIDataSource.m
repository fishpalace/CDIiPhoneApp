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

@property (nonatomic, strong) NSMutableArray *todayEvents;
@property (nonatomic, strong) NSMutableArray *tomorrowEvents;
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

+ (NSArray *)todayEvents
{
  return [[CDIDataSource sharedDataSource] todayEvents];
}

+ (NSArray *)tomorrowEvents
{
  return [[CDIDataSource sharedDataSource] tomorrowEvents];
}

+ (NSInteger)futureEventCount
{
  NSInteger futureEventCount = 0;
  NSArray *events = [CDIDataSource todayEvents];
  for (CDIEvent *event in events) {
    if (!event.passed) {
      futureEventCount++;
    }
  }
  return futureEventCount;
}

- (void)fetchData:(NSTimer *)timer
{
  [CDIDataSource fetchDataWithCompletion:nil];
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
  NSString *toDate = [NSDate stringOfDateWithIntervalFromCurrentDate:0];
  NSString *fromDate = [NSDate stringOfDateWithIntervalFromCurrentDate:3600 * 24];
  CDINetClient *client = [CDINetClient client];
  void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
    if ([responseData isKindOfClass:[NSDictionary class]]) {
      NSDictionary *dict = responseData;
      if ([dict[@"data"] isKindOfClass:[NSArray class]]) {
        [sharedDataSource setUpEventsForToday:dict[@"data"]];
      }
    }
    if (completion) {
      completion(succeeded, responseData);
    }
  };
  
  [client getEventListByRoomId:[CDIDataSource currentRoomID]
                      fromDate:fromDate
                        toDate:toDate
                    completion:handleData];
  
  NSString *toDateForTomorrow = [NSDate stringOfDateWithIntervalFromCurrentDate:3600 * 24];
  NSString *fromDateForTomorrow = [NSDate stringOfDateWithIntervalFromCurrentDate:7200 * 24];
  void (^handleData2)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
    if ([responseData isKindOfClass:[NSDictionary class]]) {
      NSDictionary *dict = responseData;
      if ([dict[@"data"] isKindOfClass:[NSArray class]]) {
        [sharedDataSource setUpEventsForTomorrow:dict[@"data"]];
      }
    }
  };
  
  [client getEventListByRoomId:[CDIDataSource currentRoomID]
                      fromDate:fromDateForTomorrow
                        toDate:toDateForTomorrow
                    completion:handleData2];
}

- (void)setUpEventsForToday:(NSArray *)array
{
  [self.todayEvents removeAllObjects];
  for (NSDictionary *dict in array) {
    CDIEvent *event = [[CDIEvent alloc] initWithDictionary:dict];
    if (!event.abandoned) {
      [self.todayEvents addObject:event];
    }
  }
//  [NSNotificationCenter postDidFetchNewEventsNotification];
  //TODO Send fetch new events notification

}

- (void)setUpEventsForTomorrow:(NSArray *)array
{
  [self.tomorrowEvents removeAllObjects];
  for (NSDictionary *dict in array) {
    CDIEvent *event = [[CDIEvent alloc] initWithDictionary:dict];
    if (!event.abandoned) {
      [self.tomorrowEvents addObject:event];
    }
  }
}

#pragma mark - Properties
+ (NSInteger)currentRoomID
{
  return 1;
}

- (NSMutableArray *)todayEvents
{
  if (!_todayEvents) {
    _todayEvents = [NSMutableArray array];
  }
  return _todayEvents;
}

- (NSMutableArray *)tomorrowEvents
{
  if (!_tomorrowEvents) {
    _tomorrowEvents = [NSMutableArray array];
  }
  return _tomorrowEvents;
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
