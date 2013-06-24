//
//  ScheduleListTableViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-23.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "ScheduleListTableViewController.h"
#import "SLDetailTableViewCell.h"
#import "CDIEventDAO.h"
#import "CDIEvent.h"
#import "CDIDataSource.h"
#import "NSDate+Addition.h"
#import "AppDelegate.h"
#import "CDICalendar.h"

@import EventKit;

@interface ScheduleListTableViewController ()

@property (nonatomic, strong) NSMutableArray  *todayArray;
@property (nonatomic, strong) NSMutableArray  *tomorrowArray;
@property (nonatomic, strong) EKEventStore    *eventStore;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation ScheduleListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)configureRequest:(NSFetchRequest *)request
{
  if ([self.delegate respondsToSelector:@selector(slTableViewController:configureRequest:)]) {
    [self.delegate slTableViewController:self configureRequest:request];
  }
}

#pragma mark - Table View Delegates

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
  SLDetailTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SLDetailTableViewCell"];
  cell.delegate = self;
  
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
    
    [cell.eventName setFont:kRSLCellTitleFont];
    [cell.roomName setFont:kRSLCellRoomFont];
    [cell.eventRelatedInfo setFont:kRSLCellRelatedInfoFont];
    [cell.startingTime setFont:kRSLTimeLabelFont];
    [cell.startingTime setTextAlignment:NSTextAlignmentRight];
    
    cell.nowIndicatorLabel.hidden = !eventDAO.active.boolValue || eventDAO.passed.boolValue;
    
    if (eventDAO.passed.boolValue || eventDAO.abandoned.boolValue) {
      [cell.eventName setTextColor:kRSLCellDisabledColor];
      [cell.roomName setTextColor:kRSLCellDisabledColor];
      [cell.eventRelatedInfo setTextColor:kRSLCellDisabledColor];
      [cell.startingTime setTextColor:kRSLCellDisabledColor];
    } else {
      [cell.eventName setTextColor:kRSLCellTitleColor];
      [cell.roomName setTextColor:kRSLCellRoomColor];
      [cell.eventRelatedInfo setTextColor:kRSLCellRelatedInfoColor];
      [cell.startingTime setTextColor:kRSLCellTimeColor];
    }
    
    BOOL eventStoreIDExisted = [CDICalendar doesEventExistInStoreWithID:eventDAO.eventStoreID];
    [cell setCalendarButtonSelected:eventStoreIDExisted];
    if (!eventStoreIDExisted) {
      [CDIEvent updateEventStoreID:@"" forEventWithID:eventDAO.eventID inManagedObjectContext:self.managedObjectContext];
    }
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
    CGSize size = [event.name sizeWithFont:kRLightFontWithSize(17)
                         constrainedToSize:CGSizeMake(205, 1000)
                             lineBreakMode:NSLineBreakByCharWrapping];
    height = kSLDetailTableViewCellStandardHeight + size.height - kSingleLineHeight;
  }
  return height;
}

#pragma mark - SLDetail Table View Cell Delegate
- (void)cellDidClickAddEventButton:(SLDetailTableViewCell *)cell
{
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  NSArray *eventArray = nil;
  if (indexPath.section == 0) {
    eventArray = self.todayArray;
  } else {
    eventArray = self.tomorrowArray;
  }
  
  CDIEventDAO *eventDAO = eventArray[indexPath.row];
  if (cell.calendarButtonSelected) {
    [self removeEvent:eventDAO forCell:cell];
  } else {
    [self addEvent:eventDAO forCell:cell];
  }
}

- (void)removeEvent:(CDIEventDAO *)eventDAO forCell:(SLDetailTableViewCell *)cell
{
  [CDICalendar requestAccess:^(BOOL granted, NSError *error) {
    if (granted) {
      
      [CDICalendar deleteEventWitdStoreID:eventDAO.eventStoreID];
      eventDAO.eventStoreID = @"";
      [CDIEvent updateEventStoreID:@""
                    forEventWithID:eventDAO.eventID
            inManagedObjectContext:self.managedObjectContext];
      [cell setCalendarButtonSelected:NO];
      [self.managedObjectContext processPendingChanges];
      [self performSelectorOnMainThread:@selector(showRemovedAlertViewWithEvent:) withObject:eventDAO waitUntilDone:NO];

    } else {
      //TODO Report error
    }
  }];
}

- (void)addEvent:(CDIEventDAO *)eventDAO forCell:(SLDetailTableViewCell *)cell
{
  [CDICalendar requestAccess:^(BOOL granted, NSError *error) {
    if (granted) {
      EKEvent *event = [CDICalendar addEventWithStartDate:eventDAO.startDate
                                                  endDate:eventDAO.endDate
                                                withTitle:eventDAO.name
                                               inLocation:[CDIDataSource nameForRoomID:eventDAO.roomID.integerValue]];
      if (event) {
        eventDAO.eventStoreID = event.eventIdentifier;
        [cell setCalendarButtonSelected:YES];
        [CDIEvent updateEventStoreID:eventDAO.eventStoreID
                      forEventWithID:eventDAO.eventID
              inManagedObjectContext:self.managedObjectContext];
        [self.managedObjectContext processPendingChanges];
        [self performSelectorOnMainThread:@selector(showAddedAlertViewWithEvent:) withObject:eventDAO waitUntilDone:NO];
      } else {
        //TODO Creation Failed
      }
    } else {
      //TODO Report error
    }
  }];
}

- (void)showAddedAlertViewWithEvent:(CDIEventDAO *)eventDAO
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:eventDAO.name
                                                      message:@"Event added to calendar."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
  [alertView show];
}

- (void)showRemovedAlertViewWithEvent:(CDIEventDAO *)eventDAO
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:eventDAO.name
                                                      message:@"Event removed to calendar."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
  [alertView show];
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

- (NSManagedObjectContext*)managedObjectContext
{
  if (_managedObjectContext == nil) {
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _managedObjectContext = [delegate managedObjectContext];
  }
  return _managedObjectContext;
}

- (NSFetchedResultsController *)fetchedResultsController
{
  if (_fetchedResultsController == nil) {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [self configureRequest:fetchRequest];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    [_fetchedResultsController performFetch:nil];
  }
  return _fetchedResultsController;
}

@end
