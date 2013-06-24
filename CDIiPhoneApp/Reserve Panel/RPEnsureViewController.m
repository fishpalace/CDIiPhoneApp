//
//  RPEnsureViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-24.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "RPEnsureViewController.h"
#import "CDIEventDAO.h"
#import "CDIDataSource.h"
#import "NSDate+Addition.h"
#import "CDINetClient.h"
#import "CDICalendar.h"
#import "CDIEvent.h"
#import "NSNotificationCenter+Addition.h"

@interface RPEnsureViewController ()

@property (weak, nonatomic) IBOutlet UILabel *roomTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventRelatedInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *accessKeyLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;

@property (nonatomic, readwrite) BOOL addedToCalendar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accessKeyBGTopMarginConstraint;

@end

@implementation RPEnsureViewController

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
  [self updateLabel];
  _accessKeyBGTopMarginConstraint.constant = kIsiPhone5 ? 105 : 85;
}

- (void)updateLabel
{
  CDIEventDAO *sharedNewEvent = [CDIEventDAO sharedNewEvent];
  [self.roomTitleLabel setText:[CDIDataSource nameForRoomID:sharedNewEvent.roomID.integerValue]];
  [self.roomTitleLabel setTextColor:kColorRPTimeRoomNameLabel];
  [self.roomTitleLabel setFont:kFontRPTimeRoomNameLabel];
  [self.roomTitleLabel setShadowColor:kColorRPTimeRoomNameLabelShadow];
  [self.roomTitleLabel setShadowOffset:CGSizeMake(0, 1)];
  
  NSString *period = [NSDate stringFromDate:sharedNewEvent.startDate
                                           toDate:sharedNewEvent.endDate
                                        inChinese:NO];
  NSString *periodString = [NSString stringWithFormat:@"From %@", period];
  [self.dateLabel setText:periodString];
  [self.dateLabel setTextColor:kColorRPTimeSpanLabelBlue];
  [self.dateLabel setFont:kFontRPTimeSpanLabel];
  
  self.eventTitleLabel.text = sharedNewEvent.name;
  self.eventTitleLabel.textColor = kColorRPEventNameLabel;
  self.eventTitleLabel.font = kFontRPEventNameLabel;
  
  self.eventRelatedInfoLabel.text = sharedNewEvent.relatedInfo;
  self.eventRelatedInfoLabel.textColor = kColorRPEventRelatedinfoLabel;
  self.eventRelatedInfoLabel.font = kFontRPEventRelatedinfoLabel;
  
  self.accessKeyLabel.text = sharedNewEvent.accessKey;
  self.accessKeyLabel.textColor = kColorRPGreen;
  self.accessKeyLabel.font = kFontRPEventAccessKeyLabel;
  
  NSString *roomName = [CDIDataSource nameForRoomID:sharedNewEvent.roomID.integerValue];
  NSString *partOne = @"Enter the code during ";
  NSString *partTwo = @" on the iPad panel in ";
  NSString *partThree = @" to confirm the event.";
  NSString *instruction = [NSString stringWithFormat:@"%@%@%@%@%@",partOne, period, partTwo, roomName, partThree];
  
  NSInteger location1 = partOne.length;
  NSInteger location2 = partOne.length + partTwo.length + period.length;
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:instruction];
  [attributedString addAttribute:NSFontAttributeName
                           value:kFontRPInstructionLabel
                           range:NSMakeRange(0, attributedString.length)];
  
  [attributedString addAttribute:NSForegroundColorAttributeName
                           value:kColorRPGray
                           range:NSMakeRange(0, attributedString.length)];
  
  [attributedString addAttribute:NSForegroundColorAttributeName
                           value:kColorRPGreen
                           range:NSMakeRange(location1, period.length)];
  
  [attributedString addAttribute:NSForegroundColorAttributeName
                           value:kColorRPGreen
                           range:NSMakeRange(location2, roomName.length)];
  
  self.instructionLabel.attributedText = attributedString;
}

- (IBAction)didClickCalendarButton:(UIButton *)sender
{
  [self createCalendarEvent];
}

- (IBAction)didClickUndoButton:(UIButton *)sender
{
  CDIEventDAO *sharedNewEvent = [CDIEventDAO sharedNewEvent];
  CDINetClient *client = [CDINetClient client];
  
  void (^completion)(BOOL, id) = ^(BOOL succeeded, id responseData) {
    if (succeeded) {
      [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
      //TODO: Alert
    }
  };
  
  [client unregisterEventWithEventID:sharedNewEvent.eventID
                           accessKey:sharedNewEvent.accessKey
                          completion:completion];
}

- (IBAction)didClickDoneButton:(UIButton *)sender
{
  [self.navigationController popToRootViewControllerAnimated:YES];
  [NSNotificationCenter postShouldChangeLocalDatasourceNotification];
}

- (void)createCalendarEvent
{
  CDIEventDAO *eventDAO = [CDIEventDAO sharedNewEvent];
  if (self.addedToCalendar) {
    [self removeEvent:eventDAO];
  } else {
    [self addEvent:eventDAO];
  }
  self.addedToCalendar = !self.addedToCalendar;
}

- (void)removeEvent:(CDIEventDAO *)eventDAO
{
  [CDICalendar requestAccess:^(BOOL granted, NSError *error) {
    if (granted) {
      
      [CDICalendar deleteEventWitdStoreID:eventDAO.eventStoreID];
      eventDAO.eventStoreID = @"";
      [CDIEvent updateEventStoreID:@""
                    forEventWithID:eventDAO.eventID
            inManagedObjectContext:self.managedObjectContext];
      [self.managedObjectContext processPendingChanges];
      [self performSelectorOnMainThread:@selector(showRemovedAlertViewWithEvent:) withObject:eventDAO waitUntilDone:NO];
      
    } else {
      //TODO Report error
    }
  }];
}

- (void)addEvent:(CDIEventDAO *)eventDAO
{
  [CDICalendar requestAccess:^(BOOL granted, NSError *error) {
    if (granted) {
      EKEvent *event = [CDICalendar addEventWithStartDate:eventDAO.startDate
                                                  endDate:eventDAO.endDate
                                                withTitle:eventDAO.name
                                               inLocation:[CDIDataSource nameForRoomID:eventDAO.roomID.integerValue]];
      if (event) {
        eventDAO.eventStoreID = event.eventIdentifier;
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
  [self.calendarButton setSelected:YES];
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:eventDAO.name
                                                      message:@"Event added to calendar."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
  [alertView show];
}

- (void)showRemovedAlertViewWithEvent:(CDIEventDAO *)eventDAO
{
  [self.calendarButton setSelected:NO];
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:eventDAO.name
                                                      message:@"Event removed to calendar."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
  [alertView show];
}

@end
