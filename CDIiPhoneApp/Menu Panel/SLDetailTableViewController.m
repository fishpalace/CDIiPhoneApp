//
//  SLDetailTableViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-3.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "SLDetailTableViewController.h"
#import "UIApplication+Addition.h"
#import "UIView+Resize.h"
#import "NSDate+Addition.h"
#import "SLDetailTableViewCell.h"
#import "CDIDataSource.h"
#import "CDIEvent.h"
#import <QuartzCore/QuartzCore.h>

#define kSLDetailTableViewHeight  468
#define kSLDetailTableViewWidth   302
#define kSLDetailTableViewCellStandardHeight 80
#define kSingleLineHeight         21

@interface SLDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *topBGImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBGImageView;
@property (weak, nonatomic) IBOutlet UILabel *todayIndicatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *eventArray;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation SLDetailTableViewController

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
  [self updateEventArray];
  [self updateLabels];
  _tableView.delegate = self;
  _tableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated
{
  self.topBGImageView.image = [[UIImage imageNamed:@"tableview_bg_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 20, 10) resizingMode:UIImageResizingModeTile];
  
  self.bottomBGImageView.image = [[UIImage imageNamed:@"tableview_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 20, 10) resizingMode:UIImageResizingModeTile];
}

- (void)configureSubviews
{
  [self.view resetSize:CGSizeMake(kSLDetailTableViewWidth, [self tableViewHeight])];
}

- (void)updateLabels
{
  NSDate *date = [NSDate date];
  if (!self.isToday) {
    date = [date dateByAddingTimeInterval:3600 * 24];
    self.timeLabel.hidden = YES;
    [self.dateLabel resetOriginYByOffset:10];
  }
  self.todayIndicatorLabel.text = _isToday ? @"Today" : @"Tomorrow";
  self.weekdayLabel.text = [NSDate weekdayStringForDate:date];
  self.dateLabel.text = [NSDate stringOfDate:date];
  [self.timer fire];
}

- (void)updateEventArray
{
  for (int i = 1; i <= 4; i++) {
    NSArray *eventArray = nil;
    if (self.isToday) {
      eventArray = [CDIDataSource todayEventsForRoomID:i];
    } else {
      eventArray = [CDIDataSource tomorrowEventsForRoomID:i];
    }
    for (CDIEvent *event in eventArray) {
      CDIEvent *eventCopy = [event eventCopy];
      [self.eventArray addObject:eventCopy];
    }
  }
}

- (void)updateTime:(NSTimer *)timer
{
	NSDate *now = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"HH:mm"];
	NSString *timeString = [dateFormatter stringFromDate:now];
  [self.timeLabel setText:timeString];
}

- (CGFloat)tableViewHeight
{
  CGFloat offset = kIsiPhone5 ? 0 : -88;
  return kSLDetailTableViewHeight + offset;
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.eventArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CDIEvent *event = [self.eventArray objectAtIndex:indexPath.row];
  NSString *reuseIdentifier = @"SLDetailTableViewCell";
  SLDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  cell.eventName.text = event.title;
  cell.roomName.text = [CDIDataSource nameForRoomID:event.roomID];
  cell.eventRelatedInfo.text = event.relatedInfo;
  cell.startingTime.text = [NSDate stringOfTime:event.startDate];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CDIEvent *event = [self.eventArray objectAtIndex:indexPath.row];
  CGSize size = [event.title sizeWithFont:[UIFont boldSystemFontOfSize:17]
                        constrainedToSize:CGSizeMake(169, 1000)
                            lineBreakMode:NSLineBreakByCharWrapping];
  return kSLDetailTableViewCellStandardHeight + size.height - kSingleLineHeight;
}

#pragma mark - Properties
- (NSMutableArray *)eventArray
{
  if (!_eventArray) {
    _eventArray = [NSMutableArray array];
  }
  return _eventArray;
}

- (NSTimer *)timer
{
  if (!_timer) {
    _timer = [NSTimer scheduledTimerWithTimeInterval:60.0
                                              target:self
                                            selector:@selector(updateTime:)
                                            userInfo:nil
                                             repeats:YES];
  }
  return _timer;
}

@end
