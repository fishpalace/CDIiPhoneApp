//
//  RPRoomViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-24.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "RPRoomViewController.h"
#import "RPRoomCell.h"
#import "CDIDataSource.h"

@interface RPRoomViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RPRoomViewController

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
  _tableView.dataSource = self;
  _tableView.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RPRoomCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RPRoomCell"];
  
  NSInteger roomID = indexPath.row + 1;
  
  [cell.roomNameLabel setText:[CDIDataSource nameForRoomID:roomID]];
  [cell.roomNameLabel setTextColor:kColorRPRoomNameLabel];
  [cell.roomNameLabel setFont:kFontRPRoomNameLabel];
  
  NSInteger eventNumber = [self eventNumberForRoom:roomID];
  NSString *eventNumberString = @"";
  if (eventNumber == 0) {
    eventNumberString = [NSString stringWithFormat:@"No Event"];
  } else if (eventNumber == 1) {
    eventNumberString = [NSString stringWithFormat:@"%d Event", [self eventNumberForRoom:roomID]];
  } else if (eventNumber > 1) {
    eventNumberString = [NSString stringWithFormat:@"%d Events", [self eventNumberForRoom:roomID]];
  }
  [cell.eventCountLabel setText:eventNumberString];
  [cell.eventCountLabel setTextColor:kColorRPEventCountLabel];
  [cell.eventCountLabel setFont:kFontRPEventCountLabel];
  
  NSInteger percentage = [CDIDataSource availablePercentageWithRoomID:indexPath.row + 1 isToday:YES];
  NSString *percentageString = [NSString stringWithFormat:@"%d", percentage];
  NSString *buttonBGImageName = @"";
  UIColor *color = nil;
  if (percentage == 0) {
    buttonBGImageName = @"menu_status_red";
    color = kRRoomStatusUnvailableColor;
  } else if (percentage < 50) {
    percentageString = [percentageString stringByAppendingString:@"%"];
    buttonBGImageName = @"menu_status_yellow";
    color = kRRoomStatusAvailableColor;
  } else {
    percentageString = [percentageString stringByAppendingString:@"%"];
    buttonBGImageName = @"menu_status_green";
    color = kRRoomStatusFreeColor;
  }
  [cell.percentageLabel setText:percentageString];
  [cell.percentageLabel setTextColor:color];
  [cell.percentageLabel setFont:[UIFont systemFontOfSize:10]];
  [cell.percentageLabel setTextAlignment:NSTextAlignmentCenter];
  
  [cell.statusButton setTitle:[self titleForRoom:roomID] forState:UIControlStateNormal];
  [cell.statusButton setBackgroundImage:[UIImage imageNamed:buttonBGImageName] forState:UIControlStateNormal];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 82;
}

- (IBAction)didClickBackButton:(UIButton *)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)eventNumberForRoom:(NSInteger)roomID
{
  NSInteger result = 0;
  NSArray *events = nil;
  events = [CDIDataSource todayEventsForRoomID:roomID];
  for (CDIEventDAO *event in events) {
    if (!event.passed.boolValue) {
      result++;
    }
  }
  
  return result;
}


- (NSString *)titleForRoom:(NSInteger)roomID
{
  char title = 'A' + roomID - 1;
  return [NSString stringWithFormat:@"%c", title];
}

@end
