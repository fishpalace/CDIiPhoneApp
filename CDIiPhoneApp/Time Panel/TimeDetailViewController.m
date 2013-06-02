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

@interface TimeDetailViewController ()

@property (weak, nonatomic) IBOutlet GYPieChart *pieChart;

@property (nonatomic, assign) NSInteger totalValue;
@property (nonatomic, assign) NSInteger startingValue;
@property (nonatomic, assign) NSInteger minimalValue;
@property (nonatomic, weak)   NSMutableArray *currentTimeZones;
@property (nonatomic, assign) NSInteger selectionStartValue;
@property (nonatomic, assign) NSInteger selectionEndValue;
@property (nonatomic, assign) BOOL isToday;

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
}

#pragma mark - Data Configuration

- (void)configurePieChart
{
  [_pieChart setDataSource:self];
  [_pieChart setStartPieAngle:M_PI * 3 / 2];
  [_pieChart setAnimationSpeed:1.0];
  [_pieChart setPieRadius:233.0];
  [_pieChart setPieCenter:CGPointMake(233.0, 233.0)];
  [_pieChart setUserInteractionEnabled:NO];
  [_pieChart setMinPieAngle:M_PI * 2 * 2  / (4 * 14)];
  [_pieChart setMaxPieAngle:M_PI * 2 * 8 / (4 * 14)];
  
  _startingValue = 8;
  _totalValue = 4 * 14;
}

- (void)setUpTimeZones
{
  _currentTimeZones = [NSMutableArray array];
  NSArray *todayEvents = [CDIDataSource todayEvents];
  NSInteger todayStartValue = [[NSDate todayDateStartingFromHour:8] integerValueForTimePanel];
  NSInteger currentValue = [[NSDate date] integerValueForTimePanel];
  
  if (currentValue < 0) {
    currentValue = 0;
  }
  
  TimeZone *passedTimeZone = [[TimeZone alloc] initWithStartValue:todayStartValue
                                                         endValue:currentValue
                                                        available:NO];
  
  [self handleOccupiedTimeZones:_currentTimeZones
                     withEvents:todayEvents
                 passedTimeZone:passedTimeZone];
}

- (void)handleOccupiedTimeZones:(NSMutableArray *)occupiedTimeZones
                     withEvents:(NSArray *)events
                 passedTimeZone:(TimeZone *)passedTimeZone
{
  if (passedTimeZone.startingValue != passedTimeZone.endValue) {
    [occupiedTimeZones addObject:passedTimeZone];
  }
  TimeZone *temp = passedTimeZone;
  
  for (CDIEvent *event in events) {
    if (!event.passed) {
      if (temp.endValue >= event.endValue) {
        continue;
      } else if (temp.endValue >= event.startValue && temp.endValue < event.endValue) {
        temp.endValue = event.endValue;
      } else if (temp.endValue < event.startValue) {
        TimeZone *availableTimeZone = [[TimeZone alloc] initWithStartValue:temp.endValue
                                                                  endValue:event.startValue
                                                                 available:YES];
        [occupiedTimeZones addObject:availableTimeZone];
        temp = [[TimeZone alloc] initWithStartValue:event.startValue
                                           endValue:event.endValue
                                          available:NO];
        [occupiedTimeZones addObject:temp];
      }
    }
  }
  
  temp = [occupiedTimeZones lastObject];
  if ([temp endValue] < _totalValue) {
    TimeZone *lastAvailableTimeZone = [[TimeZone alloc] initWithStartValue:temp.endValue
                                                                  endValue:_totalValue
                                                                 available:YES];
    [occupiedTimeZones addObject:lastAvailableTimeZone];
  }
}

- (void)configureWithDate:(BOOL)isToday
{
  //TODO 
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
    fillColor = [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0];
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
    strokeColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1];
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
