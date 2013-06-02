//
//  TimeDetailViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-2.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "TimeDetailViewController.h"
#import "GYPieChart.h"
#import "CDIDataSource.h"
#import "NSDate+Addition.h"
#import "TImeZone.h"
#import "CDIEvent.h"
#import <QuartzCore/QuartzCore.h>

@interface TimeDetailViewController ()

@property (weak, nonatomic) IBOutlet GYPieChart *pieChart;

@property (nonatomic, strong) NSMutableArray *currentTimeZones;
@property (nonatomic, assign) NSInteger totalValue;
@property (nonatomic, assign) NSInteger startingValue;
@property (nonatomic, assign) NSInteger minimalValue;
@property (nonatomic, assign) NSInteger selectionStartValue;
@property (nonatomic, assign) NSInteger selectionEndValue;
@property (nonatomic, strong) NSArray *events;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventNumberLabel;

@end

@implementation TimeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self configurePieChart];
  [self setUpTimeZones];
  [self updateLabels];
}

- (void)viewWillAppear:(BOOL)animated
{
  [_pieChart reloadData];
}

#pragma mark - Data Configuration

- (void)configurePieChart
{
  [_pieChart setDataSource:self];
  [_pieChart setStartPieAngle:M_PI * 3 / 2];
  [_pieChart setAnimationSpeed:1.0];
  [_pieChart setPieRadius:113];
  [_pieChart setPieCenter:CGPointMake(116, 116)];
  [_pieChart setUserInteractionEnabled:NO];
  [_pieChart setMinPieAngle:M_PI * 2 * 2  / (4 * 14)];
  [_pieChart setMaxPieAngle:M_PI * 2 * 8 / (4 * 14)];
  _startingValue = 8;
  _totalValue = 4 * 14;
}

- (void)setUpTimeZones
{
  if (self.isToday) {
    _currentTimeZones = [NSMutableArray arrayWithArray:[CDIDataSource todayTimeZonesWithRoomID:self.roomID]];
  } else {
    _currentTimeZones = [NSMutableArray arrayWithArray:[CDIDataSource tomorrowTimeZonesWithRoomID:self.roomID]];
  }
}

//- (void)setUpTodayTimeZones
//{
//  _currentTimeZones = [NSMutableArray array];
//  NSArray *todayEvents = [CDIDataSource todayEventsForRoomID:self.roomID];
//  self.events = [NSArray arrayWithArray:todayEvents];
//  
//  NSInteger todayStartValue = [[NSDate todayDateStartingFromHour:8] integerValueForTimePanel];
//  NSInteger currentValue = [[NSDate date] integerValueForTimePanel];
//  
//  if (currentValue < 0) {
//    currentValue = 0;
//  }
//  
//  TimeZone *passedTimeZone = [[TimeZone alloc] initWithStartValue:todayStartValue
//                                                         endValue:currentValue
//                                                        available:NO];
//  
//  [self handleOccupiedTimeZones:_currentTimeZones
//                     withEvents:todayEvents
//                 passedTimeZone:passedTimeZone];
//}
//
//- (void)setUpTomorrowTimeZones
//{
//  _currentTimeZones = [NSMutableArray array];
//  NSArray *tomorrowEvents = [CDIDataSource tomorrowEventsForRoomID:self.roomID];
//  self.events = [NSArray arrayWithArray:tomorrowEvents];
//  
//  NSInteger tomorrowStartingTimeValue = [[NSDate todayDateStartingFromHour:8] integerValueForTimePanel];
//  TimeZone *passedTimeZone = [[TimeZone alloc] initWithStartValue:tomorrowStartingTimeValue
//                                                         endValue:tomorrowStartingTimeValue
//                                                        available:NO];
//  [self handleOccupiedTimeZones:_currentTimeZones
//                     withEvents:tomorrowEvents
//                 passedTimeZone:passedTimeZone];
//}
//
//- (void)handleOccupiedTimeZones:(NSMutableArray *)occupiedTimeZones
//                     withEvents:(NSArray *)events
//                 passedTimeZone:(TimeZone *)passedTimeZone
//{
//  if (passedTimeZone.startingValue != passedTimeZone.endValue) {
//    [occupiedTimeZones addObject:passedTimeZone];
//  }
//  TimeZone *temp = passedTimeZone;
//  
//  for (CDIEvent *event in events) {
//    if (!event.passed) {
//      if (temp.endValue >= event.endValue) {
//        continue;
//      } else if (temp.endValue >= event.startValue && temp.endValue < event.endValue) {
//        temp.endValue = event.endValue;
//      } else if (temp.endValue < event.startValue) {
//        TimeZone *availableTimeZone = [[TimeZone alloc] initWithStartValue:temp.endValue
//                                                                  endValue:event.startValue
//                                                                 available:YES];
//        [occupiedTimeZones addObject:availableTimeZone];
//        temp = [[TimeZone alloc] initWithStartValue:event.startValue
//                                           endValue:event.endValue
//                                          available:NO];
//        [occupiedTimeZones addObject:temp];
//      }
//    }
//  }
//  
//  temp = [occupiedTimeZones lastObject];
//  if ([temp endValue] < _totalValue) {
//    TimeZone *lastAvailableTimeZone = [[TimeZone alloc] initWithStartValue:temp.endValue
//                                                                  endValue:_totalValue
//                                                                 available:YES];
//    [occupiedTimeZones addObject:lastAvailableTimeZone];
//  }
//}

- (void)configureWithDate:(BOOL)isToday
{
  //TODO 
}

- (void)updateLabels
{
  NSInteger eventNumber = [self eventNumber];
  NSString *eventNumberString = [NSString stringWithFormat:@"%d Event", [self eventNumber]];
  if (eventNumber > 1) {
    eventNumberString = [eventNumberString stringByAppendingString:@"s"];
  }
  self.eventNumberLabel.text = eventNumberString;
  
  NSInteger percentageNumber = [self availablePercentage];
  NSString *percentageString = [NSString stringWithFormat:@"%d%%", percentageNumber];
  self.percentageLabel.text = percentageString;
}

- (NSInteger)eventNumber
{
  NSInteger result = 0;
  if (self.isToday) {
    for (CDIEvent *event in self.events) {
      if (!event.passed) {
        result++;
      }
    }
  } else {
    result = self.events.count;
  }
  return result;
}

- (NSInteger)availablePercentage
{
  NSMutableArray *timeZones = [NSMutableArray arrayWithArray:self.currentTimeZones];
  if (self.isToday) {
    TimeZone *timeZone = timeZones[0];
    if (timeZone.length != 0) {
      [timeZones removeObjectAtIndex:0];
    }
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

#pragma mark - Pie Chart Delegate Methods

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
  return self.currentTimeZones.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
  TimeZone *timeZone = self.currentTimeZones[index];
  return timeZone.length;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
  UIColor *fillColor = nil;
  TimeZone *timeZone = self.currentTimeZones[index];
  if (timeZone.available) {
    fillColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0];
  } else {
    fillColor = [UIColor clearColor];
  }
  return fillColor;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForStrokeAtIndex:(NSUInteger)index
{
  UIColor *strokeColor = nil;
  TimeZone *timeZone = self.currentTimeZones[index];
  if (timeZone.available) {
    strokeColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
  } else {
    strokeColor = [UIColor clearColor];
  }
  return strokeColor;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForShadowAtIndex:(NSUInteger)index
{
  UIColor *shadowColor = nil;
  TimeZone *timeZone = self.currentTimeZones[index];
  if (timeZone.available) {
    shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
  } else {
    shadowColor = [UIColor clearColor];
  }
  return shadowColor;
}

- (BOOL)pieChart:(XYPieChart *)pieChart shouldHaveShadowAtIndex:(NSUInteger)index
{
  TimeZone *timeZone = self.currentTimeZones[index];
  return timeZone.available;
}

@end
