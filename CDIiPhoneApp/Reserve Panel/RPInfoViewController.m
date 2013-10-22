//
//  RPInfoViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-24.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "RPInfoViewController.h"
#import "CDIDataSource.h"
#import "NSDate+Addition.h"
#import "UIView+Addition.h"
#import "CDINetClient.h"
#import "CDIEvent.h"

@interface RPInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *roomTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextField *eventTitleTextfield;
@property (weak, nonatomic) IBOutlet UITextField *eventRelatedinfoTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *errorIndicatorImageView;

@end

@implementation RPInfoViewController

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
    _eventRelatedinfoTextfield.delegate = self;
    _eventTitleTextfield.delegate = self;
    [_eventTitleTextfield becomeFirstResponder];
    [self updateLabel];
}

- (void)updateLabel
{
    CDIEventDAO *sharedNewEvent = [CDIEventDAO sharedNewEvent];
    [self.roomTitleLabel setText:[CDIDataSource nameForRoomID:self.roomID]];
    [self.roomTitleLabel setTextColor:kColorRPTimeRoomNameLabel];
    [self.roomTitleLabel setFont:kFontRPTimeRoomNameLabel];
    [self.roomTitleLabel setShadowColor:kColorRPTimeRoomNameLabelShadow];
    [self.roomTitleLabel setShadowOffset:CGSizeMake(0, 1)];
    
    NSString *periodString = [NSDate stringFromDate:sharedNewEvent.startDate
                                             toDate:sharedNewEvent.endDate
                                          inChinese:NO];
    periodString = [NSString stringWithFormat:@"From %@", periodString];
    [self.dateLabel setText:periodString];
    [self.dateLabel setTextColor:kColorRPTimeSpanLabelBlue];
    [self.dateLabel setFont:kFontRPTimeSpanLabel];
}

- (NSInteger)roomID
{
    return [[[CDIEventDAO sharedNewEvent] roomID] integerValue];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL result = NO;
    if ([textField isEqual:self.eventTitleTextfield]) {
        [self.eventRelatedinfoTextfield becomeFirstResponder];
        result = YES;
    } else if ([textField isEqual:self.eventRelatedinfoTextfield]) {
        if (self.eventTitleTextfield.text.length > 0) {
            self.view.userInteractionEnabled = NO;
            RPActivityIndictor * activityIndictor = [RPActivityIndictor sharedRPActivityIndictor];
            activityIndictor.delegate = self;
            [activityIndictor resetBasicData];
            [activityIndictor startWaitingAnimationInView:self.view];
            [activityIndictor setWaitingTimer];
            [textField resignFirstResponder];
            [self performSelector:@selector(createEvent) withObject:nil afterDelay:1.0];
        } else {
            [self showError];
        }
    }
    return YES;
}

- (void)createEvent
{
    CDIEventDAO *sharedNewEvent = [CDIEventDAO sharedNewEvent];
    sharedNewEvent.name = self.eventTitleTextfield.text;
    sharedNewEvent.relatedInfo = @"";
    sharedNewEvent.relatedDescription = self.eventRelatedinfoTextfield.text;
    
    CDINetClient *client = [CDINetClient client];
    
    void (^completion)(BOOL, id) = ^(BOOL succeeded, id responseData) {
        self.view.userInteractionEnabled = YES;
        RPActivityIndictor * activityIndictor = [RPActivityIndictor sharedRPActivityIndictor];
        [activityIndictor stopWaitingTimer];
        
        if (succeeded) {
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = responseData;
                if ([dict[@"data"] isKindOfClass:[NSDictionary class]]) {
                    CDIEvent *event = [CDIEvent insertUserInfoWithDict:dict[@"data"]
                                                            updateTime:[NSDate date]
                                                inManagedObjectContext:self.managedObjectContext];
                    sharedNewEvent.accessKey = event.accessKey;
                    sharedNewEvent.eventID = event.eventID;
                    sharedNewEvent.eventJustCreated = YES;
                    event.creator = self.currentUser;
                    event.roomID = sharedNewEvent.roomID;
                    [self.managedObjectContext processPendingChanges];
                }
            }
            [self performSegueWithIdentifier:@"InfoEnsureSegue" sender:self];
        } else {
            //TODO: Alert
//            [self createEventFailed];
            [[RPActivityIndictor sharedRPActivityIndictor]excuteFailedinNotOverTimeStiution];
        }
    };
    
    [client createEvent:sharedNewEvent
             sessionKey:sharedNewEvent.creator.sessionKey
             completion:completion];
}

- (void)showError
{
    [self.errorIndicatorImageView blinkForRepeatCount:2 duration:0.3];
}

- (IBAction)didClickBackButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createEventFailed
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:
                               NSLocalizedStringFromTable(@"Create Event Failed", @"InfoPlist", nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedStringFromTable(@"Close", @"InfoPlist", nil) otherButtonTitles:nil];
    [alertView show];
    self.view.userInteractionEnabled = YES;
}

#pragma mark - RPActivityDelegate
-(void)someThingAfterActivityIndicatorOverTimer
{
    [self createEventFailed];
}

@end
