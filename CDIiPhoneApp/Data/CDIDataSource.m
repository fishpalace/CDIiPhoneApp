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
#import "TImeZone.h"
#import "AppDelegate.h"
#import "CDIEventDAO.h"

@interface CDIDataSource ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
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
@property (nonatomic, assign) NSInteger totalValue;
@property (nonatomic, strong) NSMutableDictionary *roomNameDict;

@end

static CDIDataSource *sharedDataSource;

@implementation CDIDataSource

+ (CDIDataSource *)sharedDataSource
{
  if (!sharedDataSource) {
    sharedDataSource = [[CDIDataSource alloc] init];
    sharedDataSource.totalValue = 4 * 14;
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

+ (NSArray *)todayTimeZonesWithRoomID:(NSInteger)roomID
{
  return [[CDIDataSource sharedDataSource] setUpTodayTimeZonesWithRoomID:roomID];
}

+ (NSArray *)tomorrowTimeZonesWithRoomID:(NSInteger)roomID
{
  return [[CDIDataSource sharedDataSource] setUpTomorrowTimeZonesWithRoomID:roomID];
}

+ (NSInteger)availablePercentageWithRoomID:(NSInteger)roomID isToday:(BOOL)isToday
{
  return [[CDIDataSource sharedDataSource] availablePercentageWithRoomID:roomID isToday:isToday];
}

+ (NSString *)nameForRoomID:(NSInteger)roomID
{
  NSMutableDictionary *dict = [[CDIDataSource sharedDataSource] roomNameDict];
  return [dict objectForKey:[NSNumber numberWithInteger:roomID]];
}

+ (CDIEventDAO *)nextEventForRoomID:(NSInteger)roomID
{
  return [[CDIDataSource sharedDataSource] nextEventForRoomID:roomID];
}

+ (CDIRoomStatus)statusForRoom:(NSInteger)roomID isToday:(BOOL)isToday
{
  CDIRoomStatus status = CDIRoomStatusAvailable;
  NSInteger percentage = [CDIDataSource availablePercentageWithRoomID:roomID isToday:isToday];
  if (percentage == 0) {
    status = CDIRoomStatusUnavailable;
  } else if (percentage < 80) {
    status = CDIRoomStatusBusy;
  }
  return status;
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
  
  void (^handleData2)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
    if ([responseData isKindOfClass:[NSDictionary class]]) {
      NSDictionary *dict = responseData;
      if ([dict[@"data"] isKindOfClass:[NSArray class]]) {
        NSArray *array = dict[@"data"];
        [self.roomNameDict removeAllObjects];
        for (NSDictionary *dict in array) {
          NSString *roomID = dict[@"id"];
          NSString *roomName = dict[@"name"];
          [self.roomNameDict setValue:roomName forKey:roomID];
        }
      }
    } else {
      [weakSelf fetchRoomInfo:nil];
    }
  };
  
  [client getAllRoomInfoCompletion:handleData2];
}

+ (void)fetchDataWithCompletion:(void (^)(BOOL succeeded, id responseData))completion
{
  [[CDIDataSource sharedDataSource] fetchDataWithCompletion:completion];
}

- (void)fetchDataWithCompletion:(void (^)(BOOL succeeded, id responseData))completion
{
  NSString *fromDate = [NSDate stringOfDateWithIntervalFromCurrentDate:0];
  NSString *toDate = [NSDate stringOfDateWithIntervalFromCurrentDate:3600 * 24 * 2];
  CDINetClient *client = [CDINetClient client];
  void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
    if ([responseData isKindOfClass:[NSDictionary class]]) {
      NSDictionary *dict = responseData;
      NSDate *currentDate = [NSDate date];
      if ([dict[@"data"] isKindOfClass:[NSArray class]]) {
        for (NSDictionary *eventDict in dict[@"data"]) {
          [CDIEvent insertUserInfoWithDict:eventDict
                                updateTime:currentDate
                    inManagedObjectContext:self.managedObjectContext];
        }
      }
      [CDIEvent removeEventsOlderThanUpdateDate:currentDate
                         inManagedObjectContext:self.managedObjectContext];
      [self.managedObjectContext processPendingChanges];
      [self.fetchedResultsController performFetch:nil];
      [self updateLocalEventsArray];
      [NSNotificationCenter postDidFetchNewEventsNotification];
    }
  };
  
  [client getEventListfromDate:fromDate
                        toDate:toDate
                    completion:handleData];
}

- (void)updateLocalEventsArray
{
  [self.roomAtodayEvents removeAllObjects];
  [self.roomAtomorrowEvents removeAllObjects];
  [self.roomBtodayEvents removeAllObjects];
  [self.roomBtomorrowEvents removeAllObjects];
  [self.roomCtodayEvents removeAllObjects];
  [self.roomCtomorrowEvents removeAllObjects];
  [self.roomDtodayEvents removeAllObjects];
  [self.roomDtomorrowEvents removeAllObjects];
  
  NSDate *tomorrowDate = [[NSDate todayDateStartingFromHour:0] dateByAddingTimeInterval:3600 * 24];
  for (CDIEvent *event in self.fetchedResultsController.fetchedObjects) {
    CDIEventDAO *eventDAO = [CDIEventDAO eventDAOInstanceWithEvent:event];
    BOOL isToday = [[event.startDate laterDate:tomorrowDate] isEqualToDate:tomorrowDate];
    NSMutableArray *array = nil;
    switch (eventDAO.roomID.integerValue) {
      case 1:
        array = isToday ? self.roomAtodayEvents : self.roomAtomorrowEvents;
        break;
      case 2:
        array = isToday ? self.roomBtodayEvents : self.roomBtomorrowEvents;
        break;
      case 3:
        array = isToday ? self.roomCtodayEvents :  self.roomCtomorrowEvents;
        break;
      case 4:
        array = isToday ? self.roomDtodayEvents :  self.roomDtomorrowEvents;
        break;
      default:
        break;
    }
    if (isToday) {
      [array addObject:eventDAO];
    }

  }
}

- (NSArray *)setUpTodayTimeZonesWithRoomID:(NSInteger)roomID
{
  NSMutableArray *currentTimeZones = [NSMutableArray array];
  NSArray *todayEvents = [CDIDataSource todayEventsForRoomID:roomID];
  
  NSInteger todayStartValue = [[NSDate todayDateStartingFromHour:8] integerValueForTimePanel];
  NSInteger currentValue = [[NSDate date] integerValueForTimePanel];
  
  if (currentValue < 0) {
    currentValue = 0;
  }
  
  TimeZone *passedTimeZone = [[TimeZone alloc] initWithStartValue:todayStartValue
                                                         endValue:currentValue
                                                        available:NO];
  
  [self handleOccupiedTimeZones:currentTimeZones
                     withEvents:todayEvents
                 passedTimeZone:passedTimeZone];
  return currentTimeZones;
}

- (NSArray *)setUpTomorrowTimeZonesWithRoomID:(NSInteger)roomID
{
  NSMutableArray *currentTimeZones = [NSMutableArray array];
  NSArray *tomorrowEvents = [CDIDataSource tomorrowEventsForRoomID:roomID];
  
  NSInteger tomorrowStartingTimeValue = [[NSDate todayDateStartingFromHour:8] integerValueForTimePanel];
  TimeZone *passedTimeZone = [[TimeZone alloc] initWithStartValue:tomorrowStartingTimeValue
                                                         endValue:tomorrowStartingTimeValue
                                                        available:NO];
  [self handleOccupiedTimeZones:currentTimeZones
                     withEvents:tomorrowEvents
                 passedTimeZone:passedTimeZone];
  
  return currentTimeZones;
}

- (void)handleOccupiedTimeZones:(NSMutableArray *)occupiedTimeZones
                     withEvents:(NSArray *)events
                 passedTimeZone:(TimeZone *)passedTimeZone
{
  if (passedTimeZone.startingValue != passedTimeZone.endValue) {
    [occupiedTimeZones addObject:passedTimeZone];
  }
  TimeZone *temp = passedTimeZone;
  
  for (CDIEventDAO *event in events) {
    if (!event.passed.boolValue) {
      if (temp.endValue >= event.endValue.integerValue) {
        continue;
      } else if (temp.endValue >= event.startValue.integerValue && temp.endValue < event.endValue.integerValue) {
        temp.endValue = event.endValue.integerValue;
      } else if (temp.endValue < event.startValue.integerValue) {
        TimeZone *availableTimeZone = [[TimeZone alloc] initWithStartValue:temp.endValue
                                                                  endValue:event.startValue.integerValue
                                                                 available:YES];
        [occupiedTimeZones addObject:availableTimeZone];
        temp = [[TimeZone alloc] initWithStartValue:event.startValue.integerValue
                                           endValue:event.endValue.integerValue
                                          available:NO];
        [occupiedTimeZones addObject:temp];
      }
    }
  }
  
  temp = [occupiedTimeZones lastObject];
  if ([temp endValue] < self.totalValue) {
    TimeZone *lastAvailableTimeZone = [[TimeZone alloc] initWithStartValue:temp.endValue
                                                                  endValue:self.totalValue
                                                                 available:YES];
    [occupiedTimeZones addObject:lastAvailableTimeZone];
  }
}

- (NSInteger)availablePercentageWithRoomID:(NSInteger)roomID isToday:(BOOL)isToday
{
  NSMutableArray *timeZones = nil;
  if (isToday) {
    timeZones = [NSMutableArray arrayWithArray:[self setUpTodayTimeZonesWithRoomID:roomID]];
    TimeZone *timeZone = timeZones[0];
    if (timeZone.length != 0 && !timeZone.available) {
      [timeZones removeObjectAtIndex:0];
    }
  } else {
    timeZones = [NSMutableArray arrayWithArray:[self setUpTomorrowTimeZonesWithRoomID:roomID]];
  }
  CGFloat availableValue = 0;
  CGFloat unavailableValue = 0;
  
  for (TimeZone *timeZone in timeZones) {
    if (timeZone.available) {
      availableValue += timeZone.length;
    } else {
      unavailableValue += timeZone.length;
    }
  }
  
  return (NSInteger)(availableValue * 100 / (availableValue + unavailableValue));
}

- (CDIEventDAO *)nextEventForRoomID:(NSInteger)roomID
{
  NSArray *todayEvents = [CDIDataSource todayEventsForRoomID:roomID];
  CDIEventDAO *result = nil;
  for (CDIEventDAO *event in todayEvents) {
    if (!event.passed.boolValue && !event.abandoned.boolValue) {
      result = event;
      break;
    }
  }
  return result;
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

- (NSMutableDictionary *)roomNameDict
{
  if (!_roomNameDict) {
    _roomNameDict = [NSMutableDictionary dictionary];
  }
  return _roomNameDict;
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


#pragma mark - Core Data Properties

- (NSManagedObjectContext*)managedObjectContext
{
  if (_managedObjectContext == nil) {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = [delegate managedObjectContext];
  }
  return _managedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController
{
  if (_fetchedResultsController == nil) {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    fetchRequest.entity = [NSEntityDescription entityForName:@"CDIEvent"
                                      inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"operatedBy == %@ && currentUserID == %@",self.coreDataIdentifier, self.currentUser.userID];
    fetchRequest.sortDescriptors = @[sortDescriptor];
        
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    [_fetchedResultsController performFetch:nil];
  }
  return _fetchedResultsController;
}

@end
