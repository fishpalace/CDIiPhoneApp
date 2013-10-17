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

#define kUndoButtonGap 8
#define kUndoButtonHeight 50

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
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *undoButtonPositionConstraint;

@property (nonatomic, readwrite) BOOL eventJustCreated;
@property (nonatomic, readwrite) BOOL addedToCalendar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accessKeyBGTopMarginConstraint;
@property (nonatomic,strong) UIActivityIndicatorView * waitingView;

@end

@implementation RPEnsureViewController
{
    NSTimer * waitingTimer;
    float waitingTime;
}

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
    waitingTime = 0.0;
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    self.undoButtonPositionConstraint.constant = self.eventJustCreated ? kUndoButtonGap : -kUndoButtonHeight;
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
    
    self.eventJustCreated = sharedNewEvent.eventJustCreated;
    self.backButton.hidden = self.eventJustCreated;
    self.doneButton.hidden = !self.eventJustCreated;
}

- (IBAction)didClickCalendarButton:(UIButton *)sender
{
    [self createCalendarEvent];
}

- (IBAction)didClickUndoButton:(UIButton *)sender
{
    self.view.userInteractionEnabled = NO;

    [self startWaitingAnimation];
    [self setWaitingTimer];
    [self performSelector:@selector(unregisterEvent) withObject:nil afterDelay:1.0];

}

- (void)unregisterEvent
{
    CDIEventDAO *sharedNewEvent = [CDIEventDAO sharedNewEvent];
    CDINetClient *client = [CDINetClient client];
    
    void (^completion)(BOOL, id) = ^(BOOL succeeded, id responseData) {
        self.view.userInteractionEnabled = YES;
        [_waitingView stopAnimating];
        [waitingTimer invalidate];
        if (succeeded) {
            [CDIDataSource fetchDataWithCompletion:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [NSNotificationCenter postShouldChangeLocalDatasourceNotification];
        } else {
            //TODO: Alert
            [self undoFailed];
        }
    };
    [client unregisterEventWithEventID:sharedNewEvent.eventID
                             accessKey:sharedNewEvent.accessKey
                            completion:completion];
}

- (void)startWaitingAnimation
{
    _waitingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width / 2 - 32.0,
                                                                                [[UIScreen mainScreen]bounds].size.height / 2 - 32.0,
                                                                                64.0,
                                                                                64.0)];
    _waitingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    _waitingView.hidesWhenStopped = YES;
    _waitingView.backgroundColor = [UIColor blackColor];
    _waitingView.layer.cornerRadius = 6;
    _waitingView.layer.masksToBounds = YES;
    [self.view addSubview:_waitingView];
    [_waitingView startAnimating];
}

- (void)setWaitingTimer
{
    waitingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(overTime:) userInfo:nil repeats:YES];
}

- (void)overTime:(NSTimer*)timer
{
    waitingTime += 1.0;
    if (waitingTime >= 10) {
        waitingTime = 0.0;
        [timer invalidate];
        [_waitingView stopAnimating];
        [self undoFailed];
    }
}

- (void)undoFailed
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Undo Reservation Failed"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alertView show];
    self.view.userInteractionEnabled = YES;
}


- (IBAction)didClickDoneButton:(UIButton *)sender
{
    if (self.eventJustCreated) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [NSNotificationCenter postShouldChangeLocalDatasourceNotification];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)didClickBackButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
