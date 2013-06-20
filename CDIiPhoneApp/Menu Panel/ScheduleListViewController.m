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

#define kScrollViewWidth 320

@interface ScheduleListViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *scheduleButton;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

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
  _tableview.delegate = self;
  _tableview.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  CGFloat height = 0;
  if (section == 1) {
    height = 30;
  }
  return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SLDetailTableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"SLDetailTableViewCell"];
  return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
  headerView.backgroundColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];

  UILabel *tomorrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 7, 100, 14)];
  tomorrowLabel.textColor = [UIColor colorWithRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:1.0];
  tomorrowLabel.font = [UIFont systemFontOfSize:12];
  tomorrowLabel.backgroundColor = [UIColor clearColor];
  tomorrowLabel.text = @"Tomorrow";
  
  [headerView addSubview:tomorrowLabel];
  
  return headerView;
}

#pragma mark - IBActions

- (IBAction)didClickBackButton:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Properties
\

@end
