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
#import <QuartzCore/QuartzCore.h>

#define kSLDetailTableViewHeight  468
#define kSLDetailTableViewWidth   302

@interface SLDetailTableViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *topBGImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBGImageView;
@property (weak, nonatomic) IBOutlet UILabel *todayIndicatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
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
  [self updateLabels];
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
