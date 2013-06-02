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
  self.pageControl.currentPage = self.scrollView.contentOffset.x > 0 ? 1 : 0;
  self.dateLabel.text = self.scrollView.contentOffset.x > 0 ? @"Tomorrow" : @"Today";
}



#pragma mark - Properties
- (TimeDetailViewController *)todayViewController
{
  if (!_todayViewController) {
    _todayViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeDetailViewController"];
    _todayViewController.isToday = YES;
    [_todayViewController.view resetSize:kTimeDetailPanelSize];
    [_todayViewController.view resetOrigin:CGPointZero];
    _todayViewController.roomID = self.roomID;
    [self.scrollView addSubview:_todayViewController.view];
  }
  return _todayViewController;
}

- (TimeDetailViewController *)tomorrowViewController
{
  if (!_tomorrowViewController) {
    _tomorrowViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeDetailViewController"];
    _tomorrowViewController.isToday = NO;
    [_tomorrowViewController.view resetSize:kTimeDetailPanelSize];
    [_tomorrowViewController.view resetOrigin:CGPointMake(kTimeDetailPanelSize.width, 0)];
    _tomorrowViewController.roomID = self.roomID;
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
