//
//  ScheduleListViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-3.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "ScheduleListViewController.h"
#import "SLDetailTableViewController.h"
#import "UIView+Resize.h"
#import <QuartzCore/QuartzCore.h>

#define kScrollViewWidth 320

@interface ScheduleListViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *scheduleButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) SLDetailTableViewController *todayScheduleViewController;
@property (nonatomic, strong) SLDetailTableViewController *tomorrowScheduleViewController;

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
  [self.todayScheduleViewController configureSubviews];
  [self.tomorrowScheduleViewController configureSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
  self.scrollView.contentSize = CGSizeMake(kScrollViewWidth * 2, self.scrollView.frame.size.height);
  [self.scrollView setContentOffset:CGPointZero];
  self.scrollView.delegate = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  
}

#pragma mark - IBActions

- (IBAction)didClickBackButton:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Properties
- (SLDetailTableViewController *)todayScheduleViewController
{
  if (!_todayScheduleViewController) {
    _todayScheduleViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SLDetailTableViewController"];
    _todayScheduleViewController.isToday = YES;
    [self addChildViewController:_todayScheduleViewController];
    [_todayScheduleViewController.view resetOrigin:CGPointMake(9, 0)];
    [self.scrollView addSubview:_todayScheduleViewController.view];
    [_todayScheduleViewController didMoveToParentViewController:self];
  }
  return _todayScheduleViewController;
}

- (SLDetailTableViewController *)tomorrowScheduleViewController
{
  if (!_tomorrowScheduleViewController) {
    _tomorrowScheduleViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SLDetailTableViewController"];
    _tomorrowScheduleViewController.isToday = NO;
    [self addChildViewController:_tomorrowScheduleViewController];
    [_tomorrowScheduleViewController.view resetOrigin:CGPointMake(kScrollViewWidth + 9, 0)];
    [self.scrollView addSubview:_tomorrowScheduleViewController.view];
    [_tomorrowScheduleViewController didMoveToParentViewController:self];
  }
  return _tomorrowScheduleViewController;
}

@end
