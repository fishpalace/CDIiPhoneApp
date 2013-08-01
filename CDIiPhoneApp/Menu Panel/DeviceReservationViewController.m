//
//  DeviceReservationViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-31.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "DeviceReservationViewController.h"
#import "NSDate+Addition.h"
#import "CDIWork.h"
#import "CDIDevice.h"
#import "CDINetClient.h"
#import "DeviceInfoViewController.h"

@interface DeviceReservationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *projectButton;
@property (weak, nonatomic) IBOutlet UIButton *startDateButton;
@property (weak, nonatomic) IBOutlet UIButton *endDateButton;
@property (weak, nonatomic) IBOutlet UIButton *reserveButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *projectPicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *datePickerBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectPickerBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIButton *coverButton;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, readwrite) BOOL isStartDate;
@property (nonatomic, readwrite) BOOL isDatePicker;

@property (nonatomic, readwrite) BOOL projectSelected;
@property (nonatomic, readwrite) BOOL startDateSelected;
@property (nonatomic, readwrite) BOOL endDateSelected;

@property (nonatomic, weak) CDIWork *selectedProject;

@end

@implementation DeviceReservationViewController

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
  _coverButton.alpha = 0;
  _datePickerBottomSpaceConstraint.constant = -300;
  _projectPickerBottomSpaceConstraint.constant = -300;
  _datePicker.datePickerMode = UIDatePickerModeDate;
  _startDate = [NSDate date];
  _endDate = [self.startDate dateByAddingTimeInterval:3600 * 24];
  _projectPicker.dataSource = self;
  _projectPicker.delegate = self;
  _reserveButton.enabled = NO;
  [self.fetchedResultsController performFetch:nil];
}

- (IBAction)didClickCoverButton:(UIButton *)sender
{
  if (self.isDatePicker) {
    [self hideProjectPicker];
    if (self.selectedProject == nil) {
      self.selectedProject = [self.fetchedResultsController.fetchedObjects firstObject];
      [self.projectButton setTitle:self.selectedProject.name forState:UIControlStateNormal];
      [self.projectButton setTitle:self.selectedProject.name forState:UIControlStateHighlighted];
    }
  } else {
    [self hideDatePicker];
    if (self.isStartDate) {
      self.startDate = self.datePicker.date;
      if ([[self.endDate laterDate:self.startDate] isEqual:self.startDate]) {
        self.endDate = [self.startDate dateByAddingTimeInterval:3600 * 24];
      }
    } else {
      self.endDate = self.datePicker.date;
      if ([[self.endDate laterDate:self.startDate] isEqual:self.startDate]) {
        self.startDate = [self.endDate dateByAddingTimeInterval:-3600 * 24];
      }
    }
  }
  
  self.reserveButton.enabled = self.projectSelected && self.startDateSelected && self.endDateSelected;
}

- (void)setStartDate:(NSDate *)startDate
{
  _startDate = startDate;
  NSString *startString = [NSDate stringOfDate:_startDate includingYear:YES];
  [self.startDateButton setTitle:startString forState:UIControlStateNormal];
  [self.startDateButton setTitle:startString forState:UIControlStateHighlighted];
}

- (void)setEndDate:(NSDate *)endDate
{
  _endDate = endDate;
  NSString *endString = [NSDate stringOfDate:_endDate includingYear:YES];
  [self.endDateButton setTitle:endString forState:UIControlStateNormal];
  [self.endDateButton setTitle:endString forState:UIControlStateHighlighted];
}

- (IBAction)didClickStartDateButton:(UIButton *)sender
{
  self.startDateSelected = YES;
  [self showDatePicker];
  [self.datePicker setDate:self.startDate];
  [self.datePicker setMinimumDate:[NSDate date]];
  self.isStartDate = YES;
}

- (IBAction)didClickEndDateButton:(UIButton *)sender
{
  self.endDateSelected = YES;
  [self showDatePicker];
  [self.datePicker setMinimumDate:[self.startDate dateByAddingTimeInterval:3600 * 24]];
  self.isStartDate = NO;
}

- (IBAction)didClickProjectButton:(UIButton *)sender
{
  self.isDatePicker = YES;
  self.projectSelected = YES;
  self.projectPickerBottomSpaceConstraint.constant = 0;
  [UIView animateWithDuration:0.5 animations:^{
    [self.view layoutIfNeeded];
    _coverButton.alpha = 1.0;
  }];
}

- (IBAction)didClickBackButton:(UIButton *)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickReserveButton:(UIButton *)sender
{
  [self reserveDevice];
}

- (void)showDatePicker
{
  self.isDatePicker = NO;
  self.datePickerBottomSpaceConstraint.constant = 0;
  [UIView animateWithDuration:0.5 animations:^{
    [self.view layoutIfNeeded];
    _coverButton.alpha = 1.0;
  }];
}

- (void)hideProjectPicker
{
  self.projectPickerBottomSpaceConstraint.constant = -300;
  [UIView animateWithDuration:0.5 animations:^{
    [self.view layoutIfNeeded];
    _coverButton.alpha = 0.0;
  }];
}

- (void)hideDatePicker
{
  self.datePickerBottomSpaceConstraint.constant = -300;
  [UIView animateWithDuration:0.5 animations:^{
    [self.view layoutIfNeeded];
    _coverButton.alpha = 0.0;
  }];
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  return self.fetchedResultsController.fetchedObjects.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  CDIWork *work = self.fetchedResultsController.fetchedObjects[row];
  return work.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  CDIWork *project = self.fetchedResultsController.fetchedObjects[row];
  self.selectedProject = project;
  [self.projectButton setTitle:project.name forState:UIControlStateNormal];
  [self.projectButton setTitle:project.name forState:UIControlStateHighlighted];
}

- (void)configureRequest:(NSFetchRequest *)request
{
  request.entity = [NSEntityDescription entityForName:@"CDIWork"
                               inManagedObjectContext:self.managedObjectContext];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"workID" ascending:NO];
  request.sortDescriptors = @[sortDescriptor];
}

- (void)reserveDevice
{
  CDINetClient *client = [CDINetClient client];
  void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
    if (succeeded) {
      [self.prevDeviceInfoViewController loadData];
      [self.navigationController popViewControllerAnimated:YES];
    } else {
      //TODO:  report error
    }
  };
  
  [client reserveDeviceWithSessionKey:self.currentUser.sessionKey
                           borrowDate:self.startDate
                              dueDate:self.endDate
                               userID:self.currentUser.userID
                               workID:self.selectedProject.workID
                             deviceID:self.currentDevice.deviceID
                           completion:handleData];
}

@end
