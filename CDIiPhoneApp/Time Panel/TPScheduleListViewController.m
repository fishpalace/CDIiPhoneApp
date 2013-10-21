//
//  TPScheduleListViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-21.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "TPScheduleListViewController.h"
#import "SLDetailTableViewCell.h"
#import "NSDate+Addition.h"
#import "CDIEventDAO.h"
#import "CDIEvent.h"
#import "CDIDataSource.h"
#import "CDINetClient.h"
#import "UIView+Resize.h"

#define kHeightForTableViewiPhone5 322
#define kHeightForTableViewiPhone4 272

@interface TPScheduleListViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *showGraphButton;

@property (nonatomic, strong) ScheduleListTableViewController *tableViewController;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TPScheduleListViewController

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
  [self.timer fire];
  self.tableViewController.delegate = self;
}

- (void)viewDidLayoutSubviews
{
  [self.tableViewController.view resetHeight:[self tableViewHeight]];
}

- (void)slTableViewController:(ScheduleListTableViewController *)vc configureRequest:(NSFetchRequest *)request
{
  [self configureRequest:request];
}

- (void)configureRequest:(NSFetchRequest *)request
{
  request.entity = [NSEntityDescription entityForName:@"CDIEvent"
                               inManagedObjectContext:self.managedObjectContext];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];

  switch (self.roomID) {
    case 1:
      request.predicate = [NSPredicate predicateWithFormat:@"occupiedByA == 1"];
      break;
    case 2:
      request.predicate = [NSPredicate predicateWithFormat:@"occupiedByB == 1"];
      break;
    case 3:
      request.predicate = [NSPredicate predicateWithFormat:@"occupiedByC == 1"];
      break;
    case 4:
      request.predicate = [NSPredicate predicateWithFormat:@"occupiedByD == 1"];
      break;      
    default:
      break;
  }
  request.sortDescriptors = @[sortDescriptor];
}

+ (CGSize)sizeAccordingToDevice
{
  CGFloat width = 320;
  CGFloat height = kIsiPhone5 ? 380 : 330;
  return CGSizeMake(width, height);
}

#pragma mark - UI Configurations

- (void)updateTimeLabel:(NSTimer *)timer
{
  NSDate *currentDate = [NSDate date];
  NSString *weekDayString = [NSDate weekdayStringForDate:currentDate];
  NSString *dateString = [NSDate stringOfDate:currentDate includingYear:YES];
  [self.dateLabel setText:[NSString stringWithFormat:@"%@ %@", weekDayString, dateString]];
  [self.timeLabel setText:[NSDate stringOfTime:currentDate]];
  [self.dateLabel setTextColor:kRSLDateLabelColor];
  [self.dateLabel setFont:kRSLDateLabelFont];
  [self.timeLabel setTextColor:kRSLTimeLabelColor];
  [self.timeLabel setFont:kRSLTimeLabelFont];
}

#pragma mark - Properties

- (CGFloat)tableViewHeight
{
  return kIsiPhone5 ? kHeightForTableViewiPhone5 : kHeightForTableViewiPhone4;
}

- (ScheduleListTableViewController *)tableViewController
{
  if (!_tableViewController) {
    _tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScheduleListTableViewController"];
    
    [self addChildViewController:_tableViewController];
    [_tableViewController.view resetOrigin:CGPointMake(0, 0)];
    [_tableViewController.view resetSize:CGSizeMake(320, [self tableViewHeight])];
    [self.view addSubview:_tableViewController.view];
    [_tableViewController didMoveToParentViewController:self];
  }
  return _tableViewController;
}

- (NSTimer *)timer
{
  if (!_timer) {
    _timer = [NSTimer scheduledTimerWithTimeInterval:60.0
                                              target:self
                                            selector:@selector(updateTimeLabel:)
                                            userInfo:nil
                                             repeats:YES];
  }
  return _timer;
}

# pragma - mark IBAction
- (IBAction)didClickPanelButton:(UIButton *)sender
{
    [self.delegate didClickPanelButton];
}

@end
