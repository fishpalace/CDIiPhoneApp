//
//  ScheduleListViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-3.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "ScheduleListViewController.h"
#import "UIView+Resize.h"
#import "SLDetailTableViewCell.h"
#import "CDIEventDAO.h"
#import "CDIEvent.h"
#import "NSDate+Addition.h"
#import "CDIDataSource.h"
#import "NSDate+Addition.h"
#import "LoginViewController.h"
#import "NSNotificationCenter+Addition.h"

@interface ScheduleListViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *scheduleButton;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) NSMutableArray  *todayArray;
@property (nonatomic, strong) NSMutableArray  *tomorrowArray;
@property (nonatomic, strong) NSTimer         *timer;

@property (nonatomic, strong) ScheduleListTableViewController *tableViewController;

@end

@implementation ScheduleListViewController

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

- (void)slTableViewController:(ScheduleListTableViewController *)vc configureRequest:(NSFetchRequest *)request
{
  [self configureRequest:request];
}

- (void)configureRequest:(NSFetchRequest *)request
{
  request.entity = [NSEntityDescription entityForName:@"CDIEvent"
                               inManagedObjectContext:self.managedObjectContext];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];

  request.sortDescriptors = @[sortDescriptor];
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

#pragma mark - IBActions

- (IBAction)didClickBackButton:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickReserveButton:(UIButton *)sender
{
  if ([CDIUser currentUserInContext:self.managedObjectContext]) {
    [self performSegueWithIdentifier:@"EventListRoomListSegue" sender:self];
  } else {
    [LoginViewController displayLoginPanelWithCallBack:^{
      [self performSegueWithIdentifier:@"EventListRoomListSegue" sender:self];
      [NSNotificationCenter postShouldChangeLocalDatasourceNotification];
    }];
  }
}

#pragma mark - Properties

- (ScheduleListTableViewController *)tableViewController
{
  if (!_tableViewController) {
    _tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScheduleListTableViewController"];
    
    [self addChildViewController:_tableViewController];
    [_tableViewController.view resetSize:CGSizeMake(320, kCurrentScreenHeight - kTopBarHeight)];
    [_tableViewController.view resetOrigin:CGPointMake(0, kTopBarHeight)];
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

@end
