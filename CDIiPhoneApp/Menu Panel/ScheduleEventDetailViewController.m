//
//  ScheduleEventDetailViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-8-2.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "ScheduleEventDetailViewController.h"
#import "TTTAttributedLabel.h"
#import "UIImageView+Addition.h"
#import "CDIEventDAO.h"
#import "UIView+Addition.h"
#import "NSDate+Addition.h"
#import "CDICalendar.h"
#import "CDIDataSource.h"

#define kLineSpacing                      4

@interface ScheduleEventDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *titleContainerView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleContainerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *saveEventButton;

@end

@implementation ScheduleEventDetailViewController

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
    UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 320.0, 182.0)];
    [maskView setBackgroundColor:[UIColor whiteColor]];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_imageView.layer setMask:maskView.layer];
    [_imageView loadImageFromURL:self.event.imageURL completion:^(BOOL succeeded) {
        [_imageView fadeIn];
    }];
    [_titleLabel setText:self.event.name];
    [_typeLabel setText:self.event.type];
    
    NSString *startDateString = [NSDate stringOfDate:self.event.startDate includingYear:YES];
    NSString *endDateString = [NSDate stringOfDate:self.event.endDate includingYear:YES];
    NSString *dateString;
    if (kIsChinese) {
        dateString = [NSString stringWithFormat:@"从 %@ 到 %@",startDateString,endDateString];
    } else {
        dateString = [NSString stringWithFormat:@"From %@ to %@", startDateString, endDateString];
    }
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:dateString];
    
    if (kIsChinese) {
        [attriString addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica-Light" size:14]
                            range:NSMakeRange(0, attriString.length)];
        [attriString addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica-Bold" size:14]
                            range:NSMakeRange(2, startDateString.length)];
        [attriString addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica-Bold" size:14]
                            range:NSMakeRange(5 + startDateString.length, endDateString.length)];
    }
    else {
        [attriString addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica-Light" size:14]
                            range:NSMakeRange(0, attriString.length)];
        [attriString addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica-Bold" size:14]
                            range:NSMakeRange(5, startDateString.length)];
        [attriString addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica-Bold" size:14]
                            range:NSMakeRange(9 + startDateString.length, endDateString.length)];
    }
    
    _dateLabel.attributedText = attriString;
    
    [_contentLabel setText:self.event.relatedInfo];
    [_contentLabel setNumberOfLines:100000];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:_contentLabel.attributedText];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:kLineSpacing];
    [style setLineBreakMode:NSLineBreakByCharWrapping];
    [string addAttribute:NSParagraphStyleAttributeName
                   value:style
                   range:NSMakeRange(0, string.length)];
    [_contentLabel setAttributedText:string];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    self.contentLabelHeightConstraint.constant = [self heightForContentLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    CGFloat height = self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height;
    height = height < self.scrollView.frame.size.height ? self.scrollView.frame.size.height + 1 : height;
    [self.scrollView setContentSize:CGSizeMake(320, height)];
}

- (void)viewDidLayoutSubviews
{
    CGFloat height = self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height;
    height = height < self.scrollView.frame.size.height ? self.scrollView.frame.size.height + 1 : height;
    [self.scrollView setContentSize:CGSizeMake(320, height)];
}

- (CGFloat)heightForContentLabel
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)self.contentLabel.attributedText);
    CFRange fitRange;
    CFRange textRange = CFRangeMake(0, self.contentLabel.attributedText.length);
    
    CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, textRange, NULL, CGSizeMake(290, CGFLOAT_MAX), &fitRange);
    
    CFRelease(framesetter);
    return frameSize.height + 25;
}

- (IBAction)didClickBackButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickSaveEventButton:(id)sender
{
    if (self.saveEventButton.selected) {
        [self removeEvent];
    } else {
        [self addEvent];
    }
}

- (void)removeEvent
{
    [CDICalendar requestAccess:^(BOOL granted, NSError *error) {
        if (granted) {
            
            self.saveEventButton.selected = NO;
            [CDICalendar deleteEventWitdStoreID:self.event.eventStoreID];
            self.event.eventStoreID = @"";
            [CDIEvent updateEventStoreID:@""
                          forEventWithID:self.event.eventID
                  inManagedObjectContext:self.managedObjectContext];
            [self.managedObjectContext processPendingChanges];
            [self performSelectorOnMainThread:@selector(showRemovedAlertViewWithEvent:) withObject:self.event waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(updateCalendarButton) withObject:nil waitUntilDone:NO];
        } else {
            //TODO Report error
        }
    }];
}

- (void)addEvent
{
    [CDICalendar requestAccess:^(BOOL granted, NSError *error) {
        if (granted) {
            EKEvent *event = [CDICalendar addEventWithStartDate:self.event.startDate
                                                        endDate:self.event.endDate
                                                      withTitle:self.event.name
                                                     inLocation:[CDIDataSource nameForRoomID:self.event.roomID.integerValue]];
            if (event) {
                self.saveEventButton.selected = YES;
                self.event.eventStoreID = event.eventIdentifier;
                [CDIEvent updateEventStoreID:self.event.eventStoreID
                              forEventWithID:self.event.eventID
                      inManagedObjectContext:self.managedObjectContext];
                [self.managedObjectContext processPendingChanges];
                [self performSelectorOnMainThread:@selector(showAddedAlertViewWithEvent:) withObject:self.event waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(updateCalendarButton) withObject:nil waitUntilDone:NO];
            } else {
                //TODO Creation Failed
            }
        } else {
            //TODO Report error
        }
    }];
}


- (void)updateCalendarButton
{
    NSString *imageName = self.saveEventButton.selected ? @"tableview_icon_calendar_hl" : @"tableview_icon_calendar";
    [self.saveEventButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.saveEventButton setNeedsDisplay];
}

- (void)showAddedAlertViewWithEvent:(CDIEventDAO *)eventDAO
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:eventDAO.name
                                                        message:NSLocalizedStringFromTable(@"Event added to calendar.", @"InfoPlist", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @"InfoPlist", nil)
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)showRemovedAlertViewWithEvent:(CDIEventDAO *)eventDAO
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:eventDAO.name
                                                        message:NSLocalizedStringFromTable(@"Event removed to calendar.", @"InfoPlist", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @"InfoPlist", nil)
                                              otherButtonTitles:nil];
    [alertView show];
}


@end
