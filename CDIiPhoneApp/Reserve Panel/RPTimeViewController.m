//
//  RPTimeViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-24.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "RPTimeViewController.h"
#import "GYPieChart.h"
#import "CDIDataSource.h"
#import "TImeZone.h"
#import "NSDate+Addition.h"
#import "CDINetClient.h"
#import "CDIUser.h"
#import "UIView+Addition.h"

#define kPieChartTopMarginForiPhone4 5
#define kPieChartTopMarginForiPhone5 50

@interface RPTimeViewController ()

@property (nonatomic, assign) NSInteger totalValue;
@property (nonatomic, assign) NSInteger startingValue;
@property (nonatomic, assign) NSInteger minimalValue;
@property (nonatomic, strong) NSMutableArray *todayTimeZones;
@property (nonatomic, strong) NSMutableArray *tomorrowTimeZones;
@property (nonatomic, weak)   NSMutableArray *currentTimeZones;
@property (nonatomic, assign) NSInteger selectionStartValue;
@property (nonatomic, assign) NSInteger selectionEndValue;
@property (nonatomic, assign) BOOL isToday;
@property (nonatomic, assign) BOOL isDraggingFromPuller;

@property (weak, nonatomic) IBOutlet GYPieChart *pieChart;
@property (weak, nonatomic) IBOutlet UILabel *roomTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *todayOrTomorrowLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *switchDayButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pieChartTopMarginConstraint;
@property (weak, nonatomic) IBOutlet UILabel *timeSpanLabel;
@property (weak, nonatomic) IBOutlet UIView *timeSpanDisplayView;
@property (weak, nonatomic) IBOutlet UILabel *timeDisplayLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeFromToLabel;

@end

@implementation RPTimeViewController

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
  [_timeSpanDisplayView flashOut];
  _pieChartTopMarginConstraint.constant = kIsiPhone5 ? kPieChartTopMarginForiPhone5 : kPieChartTopMarginForiPhone4;
}

- (void)viewWillAppear:(BOOL)animated
{
  [_pieChart reloadData];
}

#pragma mark - Data Configuration

- (void)configurePieChart
{
  [_pieChart setDataSource:self];
  [_pieChart setDelegateForGY:self];
  [_pieChart setStartPieAngle:M_PI * 3 / 2];
  [_pieChart setAnimationSpeed:1.0];
  [_pieChart setPieRadius:115];
  [_pieChart setPieCenter:CGPointMake(141, 141)];
  [_pieChart setUserInteractionEnabled:YES];
  [_pieChart setStartPullerImage:[UIImage imageNamed:@"rp_time_puller_start"]
                  endPullerImage:[UIImage imageNamed:@"rp_time_puller_end"]];
  [_pieChart setMinPieAngle:M_PI * 2 * 2  / (4 * 14)];
  [_pieChart setMaxPieAngle:M_PI * 2 * 8 / (4 * 14)];
  
  _isToday = YES;
  _startingValue = 8;
  _totalValue = 4 * 14;
  [self setUpTimeZones];
  [self.pieChart setStartPullerInitialAngle:[self percentageForFirstAvailableValue]];
}

- (void)setUpTimeZones
{
  _todayTimeZones = [NSMutableArray arrayWithArray:[CDIDataSource todayTimeZonesWithRoomID:self.roomID]];
  _tomorrowTimeZones = [NSMutableArray arrayWithArray:[CDIDataSource tomorrowTimeZonesWithRoomID:self.roomID]];
  _currentTimeZones = _todayTimeZones;
}

- (void)configureWithDate:(BOOL)isToday
{
  //TODO
}

- (void)updateLabels
{
  [self updateRoomNameLabel];
  [self updateDateLabels];
  [self updateTimeSpanLabel];
}

- (void)updateRoomNameLabel
{
  [self.roomTitleLabel setText:[CDIDataSource nameForRoomID:self.roomID]];
  [self.roomTitleLabel setTextColor:kColorRPTimeRoomNameLabel];
  [self.roomTitleLabel setFont:kFontRPTimeRoomNameLabel];
  [self.roomTitleLabel setShadowColor:kColorRPTimeRoomNameLabelShadow];
  [self.roomTitleLabel setShadowOffset:CGSizeMake(0, 1)];
}

- (void)updateDateLabels
{
  NSDate *date = self.isToday ? [NSDate date] : [NSDate tomorrowDate];
  NSString *dateString = [NSDate stringOfDate:date includingYear:NO];
  NSString *weekDayString = [NSDate weekdayStringForDate:date];
  NSString *todayOrTomorrowString = self.isToday ? @"Today" : @"Tomorrow";
  NSString *dateDisplayString = [NSString stringWithFormat:@"%@ %@",dateString, weekDayString];
  [self.todayOrTomorrowLabel setText:todayOrTomorrowString];
  [self.todayOrTomorrowLabel setTextColor:kColorRPTodayOrTomorrowLabel];
  [self.todayOrTomorrowLabel setFont:kFontRPTodayOrTomorrowLabel];
  [self.todayOrTomorrowLabel setShadowColor:kColorRPTodayOrTomorrowLabelShadow];
  [self.todayOrTomorrowLabel setShadowOffset:CGSizeMake(0, 1)];
  [self.todayOrTomorrowLabel setTextAlignment:NSTextAlignmentCenter];
  
  [self.dateLabel setText:dateDisplayString];
  [self.dateLabel setTextColor:kColorRPDateLabel];
  [self.dateLabel setFont:kFontRPDateLabel];
  [self.dateLabel setShadowColor:kColorRPDateLabelShadow];
  [self.dateLabel setShadowOffset:CGSizeMake(0, 1)];
  [self.dateLabel setTextAlignment:NSTextAlignmentCenter];
}

- (void)updateTimeSpanLabel
{
  NSString *startTime = [self stringForPercentage:(CGFloat)self.selectionStartValue / (CGFloat)self.totalValue];
  NSString *endTime = [self stringForPercentage:(CGFloat)self.selectionEndValue / (CGFloat)self.totalValue];
  NSString *spanString = [NSString stringWithFormat:@"From %@ to %@", startTime, endTime];
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:spanString];
  [attributedString addAttribute:NSFontAttributeName
                           value:kFontRPTimeSpanLabel
                           range:NSMakeRange(0, attributedString.length)];
  [attributedString addAttribute:NSForegroundColorAttributeName
                           value:kColorRPTimeSpanLabelGray
                           range:NSMakeRange(0, attributedString.length)];
  [attributedString addAttribute:NSForegroundColorAttributeName
                           value:kColorRPTimeSpanLabelBlue
                           range:NSMakeRange(5, startTime.length)];
  [attributedString addAttribute:NSForegroundColorAttributeName
                           value:kColorRPTimeSpanLabelBlue
                           range:NSMakeRange(9 + startTime.length, endTime.length)];
  self.timeSpanLabel.attributedText = attributedString;
}

- (NSInteger)eventNumber
{
  NSInteger result = 0;
  NSArray *events = nil;
  if (self.isToday) {
    events = [CDIDataSource todayEventsForRoomID:self.roomID];
    for (CDIEventDAO *event in events) {
      if (!event.passed.boolValue) {
        result++;
      }
    }
  } else {
    events = [CDIDataSource tomorrowEventsForRoomID:self.roomID];
    result = events.count;
  }
  return result;
}

- (CGFloat)percentageForFirstAvailableValue
{
  NSInteger firstAvailableValue = 0;
  for (TimeZone *timeZone in self.currentTimeZones) {
    if (timeZone.available) {
      firstAvailableValue = timeZone.startingValue;
      if (timeZone.length > 1) {
        break;
      }
    }
  }
  return (CGFloat)firstAvailableValue / (CGFloat)self.totalValue;
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
    fillColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
  } else {
    fillColor = [UIColor clearColor];
  }
  return fillColor;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForShadowAtIndex:(NSUInteger)index
{
  UIColor *shadowColor = nil;
  TimeZone *timeZone = self.currentTimeZones[index];
  if (timeZone.available) {
    shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
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

#pragma mark - GYChart Delegate
- (NSString *)stringForPercentage:(CGFloat)percentage
{
  NSInteger integerValue = [self valueForPercentage:percentage];
  NSInteger hour = integerValue / 4 + self.startingValue;
  NSInteger quarter = integerValue % 4;
  NSInteger minute = quarter * 15;
  NSString *timeString = [NSString stringWithFormat:@"%d:%02d", hour, minute];
  return timeString;
}

- (CGFloat)decentPercentageForRawPercentage:(CGFloat)rawPercentage
{
  NSInteger integerValue = [self valueForPercentage:rawPercentage];
  return (CGFloat)integerValue / (CGFloat)self.totalValue;
}

- (NSInteger)valueForPercentage:(CGFloat)percentage
{
  CGFloat rawValue = (CGFloat)self.totalValue * percentage;
  NSInteger integerValue = (NSInteger)rawValue;
  CGFloat delta = rawValue - integerValue;
  if (delta > 0.5) {
    integerValue += 1;
  }
  return integerValue;
}

- (BOOL)GYPieChart:(GYPieChart *)pieChart didChangeStartPercentage:(CGFloat)startPercentage endPercentage:(CGFloat)endPercentage
{
  self.selectionStartValue = [self valueForPercentage:startPercentage];
  self.selectionEndValue = [self valueForPercentage:endPercentage];
  BOOL available = YES;
  for (TimeZone *timeZone in self.currentTimeZones) {
    if ([timeZone containsZoneWithStartValue:self.selectionStartValue
                                      length:self.selectionEndValue - self.selectionStartValue] && !timeZone.available) {
      available = NO;
      break;
    }
  }
  [self updateTimeSpanLabel];
  self.nextButton.enabled = available;
  CGFloat percentage = self.isDraggingFromPuller ? startPercentage : endPercentage;
  self.timeFromToLabel.hidden = !available;
  if (available) {
    [self.timeDisplayLabel setText:[self stringForPercentage:percentage]];
    self.timeDisplayLabel.textColor = [UIColor whiteColor];
  } else {
    [self.timeDisplayLabel setText:@"Unavailable"];
    self.timeDisplayLabel.textColor = kColorTintRed;
  }
  return available;
}

- (void)GYPieChart:(GYPieChart *)pieChart didStartDraggingWithFrom:(BOOL)isDraggingFrom
{
  [self.timeSpanDisplayView fadeIn];
  self.isDraggingFromPuller = isDraggingFrom;
  UIColor *fromToColor = isDraggingFrom ? kColorTintBlue : kColorTintRed;
  NSString *fromToString = isDraggingFrom ? @"From" : @"To";
  [self.timeFromToLabel setTextColor:fromToColor];
  [self.timeFromToLabel setText:fromToString];
}

- (void)GYPieChartdidEndDragging:(GYPieChart *)pieChart
{
  [self.timeSpanDisplayView fadeOut];
}

- (IBAction)didClickSwitchDateButton:(UIButton *)sender
{
  self.isToday = !self.isToday;
  self.currentTimeZones = self.isToday ? self.todayTimeZones : self.tomorrowTimeZones;
  [self updateDateLabels];
  [self.pieChart reloadData];
}

- (IBAction)didClickNextButton:(UIButton *)sender
{
  CDIUser *currentUser = [CDIUser currentUserInContext:self.managedObjectContext];
  CDINetClient *client = [CDINetClient client];
  
  NSDate *date = [NSDate dateFromeIntegerValue:self.selectionStartValue
                                      forToday:self.isToday];
  
  BlockARCWeakSelf weakSelf = self;
  void (^completion)(BOOL, id) = ^(BOOL succeeded, id responseData) {
    if (succeeded) {
      if ([responseData[@"data"] integerValue] != 0) {
        [weakSelf submitDate];
      } else {
        //TODO Report Error
      }
    }
  };
  [client checkEventCreationLegalWithSessionKey:currentUser.sessionKey
                                           date:[date stringExpression]
                                     completion:completion];
}

- (void)submitDate
{
  CDIEventDAO *sharedNewEvent = [CDIEventDAO sharedNewEvent];
  sharedNewEvent.startDate = [NSDate dateFromeIntegerValue:self.selectionStartValue
                                                  forToday:self.isToday];
  sharedNewEvent.endDate = [NSDate dateFromeIntegerValue:self.selectionEndValue
                                                forToday:self.isToday];
  sharedNewEvent.roomID = @(self.roomID);
  sharedNewEvent.creator = [CDIUser currentUserInContext:self.managedObjectContext];
  [self performSegueWithIdentifier:@"TimeInfoSegue" sender:self];
}

- (IBAction)didClickBackButton:(UIButton *)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

@end
