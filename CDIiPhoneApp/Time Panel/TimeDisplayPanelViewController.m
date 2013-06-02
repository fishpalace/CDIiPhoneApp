//
//  TimeDisplayPanelViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-2.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "TimeDisplayPanelViewController.h"
#import "TimeDetailViewController.h"
#import "UIView+Resize.h"
#import "CDIDataSource.h"

@interface TimeDisplayPanelViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *roomIdentifier;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
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
  _roomIdentifier.text = self.roomTitle;
  _roomNameLabel.text = [CDIDataSource nameForRoomID:self.roomID];
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
  BOOL isToday = self.scrollView.contentOffset.x == 0;
  self.pageControl.currentPage = isToday ? 0 : 1;
  self.dateLabel.text = isToday > 0 ? @"Today" : @"Tomorrow";
  
  NSString *imageName = nil;
  NSString *statusString = nil;
  UIColor *color = nil;
  CDIRoomStatus status = [CDIDataSource statusForRoom:self.roomID isToday:isToday];
  if (status == CDIRoomStatusAvailable) {
    imageName = @"menu_room_clear";
    statusString = @"Available";
    color = [UIColor colorWithRed:0.0/255.0 green:172.0/255.0 blue:65.0/255.0 alpha:1.0];
  } else if (status == CDIRoomStatusBusy) {
    imageName = @"menu_room_available";
    statusString = @"Busy";
    color = [UIColor colorWithRed:250.0/255.0 green:140.0/255.0 blue:20.0/255.0 alpha:1.0];
  } else {
    imageName = @"menu_room_unavailable";
    statusString = @"Unavailable";
    color = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0];
  }
  self.statusImageView.image = [UIImage imageNamed:imageName];
  self.statusLabel.text = statusString;
  self.statusLabel.textColor = color;
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

- (NSString *)roomTitle
{
  char title = 'A' + self.roomID - 1;
  return [NSString stringWithFormat:@"%c", title];
}

@end
