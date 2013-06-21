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

@interface TPScheduleListViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *showGraphButton;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *todayArray;
@property (nonatomic, strong) NSMutableArray *tomorrowArray;

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
  _tableview.delegate = self;
  _tableview.dataSource = self;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger numberOfRows = 0;
  if (section == 0) {
    numberOfRows = self.todayArray.count;
  } else {
    numberOfRows = self.tomorrowArray.count;
  }
  numberOfRows = numberOfRows == 0 ? 1 : numberOfRows;
  return numberOfRows;
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
  NSArray *eventArray = nil;
  if (indexPath.section == 0) {
    eventArray = self.todayArray;
  } else {
    eventArray = self.tomorrowArray;
  }
  
  cell.isPlaceHolder = eventArray.count == 0;
  if (!cell.isPlaceHolder) {
    CDIEventDAO *eventDAO = eventArray[indexPath.row];
    cell.eventName.text = eventDAO.name;
    cell.roomName.text = [CDIDataSource nameForRoomID:eventDAO.roomID.integerValue];
    cell.eventRelatedInfo.text = eventDAO.relatedInfo;
    cell.startingTime.text = [NSDate stringOfTime:eventDAO.startDate];
  }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSArray *eventArray = nil;
  if (indexPath.section == 0) {
    eventArray = self.todayArray;
  } else {
    eventArray = self.tomorrowArray;
  }
  
  CGFloat height = kSLDetailTableViewCellStandardHeight;
  if (eventArray.count != 0) {
    CDIEventDAO *event = [eventArray objectAtIndex:indexPath.row];
    CGSize size = [event.name sizeWithFont:[UIFont boldSystemFontOfSize:17]
                         constrainedToSize:CGSizeMake(169, 1000)
                             lineBreakMode:NSLineBreakByCharWrapping];
    height = kSLDetailTableViewCellStandardHeight + size.height - kSingleLineHeight;
  }
  return height;
}

#pragma mark - Properties
- (NSMutableArray *)todayArray
{
  if (!_todayArray) {
    _todayArray = [NSMutableArray array];
    NSDate *tomorrowDate = [[NSDate todayDateStartingFromHour:0] dateByAddingTimeInterval:3600 * 24];
    for (CDIEvent *event in self.fetchedResultsController.fetchedObjects) {
      if ([[event.startDate laterDate:tomorrowDate] isEqualToDate:tomorrowDate]) {
        CDIEventDAO *eventDAO = [CDIEventDAO eventDAOInstanceWithEvent:event];
        [_todayArray addObject:eventDAO];
      }
    }
  }
  return _todayArray;
}

- (NSMutableArray *)tomorrowArray
{
  if (!_tomorrowArray) {
    _tomorrowArray = [NSMutableArray array];
    NSDate *tomorrowDate = [[NSDate todayDateStartingFromHour:0] dateByAddingTimeInterval:3600 * 24];
    for (CDIEvent *event in self.fetchedResultsController.fetchedObjects) {
      if ([[event.startDate earlierDate:tomorrowDate] isEqualToDate:tomorrowDate]) {
        CDIEventDAO *eventDAO = [CDIEventDAO eventDAOInstanceWithEvent:event];
        [_tomorrowArray addObject:eventDAO];
      }
    }
  }
  return _tomorrowArray;
}


@end
