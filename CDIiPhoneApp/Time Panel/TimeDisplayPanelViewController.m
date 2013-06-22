//
//  TimeDisplayPanelViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-2.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "TimeDisplayPanelViewController.h"
#import "TimeDetailViewController.h"
#import "TPScheduleListViewController.h"
#import "UIView+Resize.h"
#import "CDIDataSource.h"

#define kTPScheduleListOriginY 70

@interface TimeDisplayPanelViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *scheduleButton;
@property (weak, nonatomic) IBOutlet UIImageView *nowIndicatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *nextEventTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextEventTitleLabel;

@property (nonatomic, readwrite) BOOL scheduleListDisplayed;

@property (nonatomic, strong) TPScheduleListViewController *scheduleListViewController;
@property (nonatomic, strong) TimeDetailViewController *todayViewController;
@property (nonatomic, strong) TimeDetailViewController *tomorrowViewController;

@end

@implementation TimeDisplayPanelViewController

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
  [self.todayViewController configureWithDate:YES];
  [self.tomorrowViewController configureWithDate:NO];
  _scrollView.contentSize = CGSizeMake(kTimeDetailPanelSize.width * 2, kTimeDetailPanelSize.height);
  [_scrollView setContentOffset:CGPointZero];
  _scrollView.delegate = self;
  _pageControl.numberOfPages = 2;
  _pageControl.currentPage = 0;
  _scheduleListDisplayed = NO;
}

- (void)removeFromParentViewController
{
  [self.todayViewController willMoveToParentViewController:nil];
  [self.todayViewController.view removeFromSuperview];
  [self.todayViewController removeFromParentViewController];
  self.todayViewController = nil;
  
  [self.tomorrowViewController willMoveToParentViewController:nil];
  [self.tomorrowViewController.view removeFromSuperview];
  [self.tomorrowViewController removeFromParentViewController];
  self.tomorrowViewController = nil;
  
  [super removeFromParentViewController];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  [self updateDateLabel];
}

- (void)updateDateLabel
{
  BOOL isToday = self.scrollView.contentOffset.x == 0;
  self.pageControl.currentPage = isToday ? 0 : 1;
  if (self.scheduleListDisplayed) {
    self.dateLabel.text = @"Today";
  } else {
    self.dateLabel.text = isToday > 0 ? @"Today" : @"Tomorrow";
  }
  self.dateLabel.textColor = kColorForNextEventTimeLabel;
  self.dateLabel.font = kFontForNextEventTimeLabel;
}

- (IBAction)didClickScheduleButton:(UIButton *)sender
{
  self.scheduleListDisplayed = !self.scheduleListDisplayed;
  self.scheduleButton.selected = self.scheduleListDisplayed;
  [self updateDateLabel];
  CGFloat targetOriginY = self.scheduleListDisplayed ? kTPScheduleListOriginY : self.view.frame.size.height;
  [UIView animateWithDuration:0.7 animations:^{
    [self.scheduleListViewController.view resetOriginY:targetOriginY];
  } completion:^(BOOL finished) {
    //TODO: 
  }];
}

#pragma mark - Properties
- (TimeDetailViewController *)todayViewController
{
  if (!_todayViewController) {
    _todayViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeDetailViewController"];
    _todayViewController.roomID = self.roomID;
    _todayViewController.isToday = YES;
    [_todayViewController.view resetSize:kTimeDetailPanelSize];
    [_todayViewController.view resetOrigin:CGPointZero];
    [self.scrollView addSubview:_todayViewController.view];
  }
  return _todayViewController;
}

- (TimeDetailViewController *)tomorrowViewController
{
  if (!_tomorrowViewController) {
    _tomorrowViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeDetailViewController"];
    _tomorrowViewController.roomID = self.roomID;
    _tomorrowViewController.isToday = NO;
    [_tomorrowViewController.view resetSize:kTimeDetailPanelSize];
    [_tomorrowViewController.view resetOrigin:CGPointMake(kTimeDetailPanelSize.width, 0)];
    [self.scrollView addSubview:_tomorrowViewController.view];
  }
  return _tomorrowViewController;
}

- (TPScheduleListViewController *)scheduleListViewController
{
  if (!_scheduleListViewController) {
    _scheduleListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TPScheduleListViewController"];
    _scheduleListViewController.roomID = self.roomID;
    
    [self addChildViewController:_scheduleListViewController];
    [_scheduleListViewController.view resetSize:kTPScheduleListViewSize];
    [_scheduleListViewController.view resetOrigin:CGPointMake(0, self.view.frame.size.height)];
    [self.view addSubview:_scheduleListViewController.view];
    [_scheduleListViewController didMoveToParentViewController:self];
  }
  return _scheduleListViewController;
}

- (NSString *)roomTitle
{
  char title = 'A' + self.roomID - 1;
  return [NSString stringWithFormat:@"%c", title];
}

@end
