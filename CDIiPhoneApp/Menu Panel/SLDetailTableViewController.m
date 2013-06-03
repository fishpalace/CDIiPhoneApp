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
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
  NSLog(@"%@", NSStringFromCGRect(self.topBGImageView.frame));
  NSLog(@"%@", NSStringFromCGRect(self.bottomBGImageView.frame));
  self.topBGImageView.image = [[UIImage imageNamed:@"tableview_bg_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 20, 10) resizingMode:UIImageResizingModeTile];
  
  self.bottomBGImageView.image = [[UIImage imageNamed:@"tableview_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 20, 10) resizingMode:UIImageResizingModeTile];
//  self.topBGImageView.layer.borderColor = [UIColor redColor].CGColor;
//  self.topBGImageView.layer.borderWidth = 2;
//  self.bottomBGImageView.layer.borderColor = [UIColor greenColor].CGColor;
//  self.bottomBGImageView.layer.borderWidth = 3;
}

- (void)configureSubviews
{
  [self.view resetSize:CGSizeMake(kSLDetailTableViewWidth, [self tableViewHeight])];
}

- (void)updateLabels
{
  NSDate *date = [NSDate date];
  if (self.isToday) {
    date = [date dateByAddingTimeInterval:3600 * 24];
  }
  self.todayIndicatorLabel.text = _isToday ? @"Today" : @"Tomorrow";
//  self.weekdayLabel.text = [date ];
}

- (CGFloat)tableViewHeight
{
  CGFloat offset = kIsiPhone5 ? 0 : -88;
  return kSLDetailTableViewHeight + offset;
}

@end
