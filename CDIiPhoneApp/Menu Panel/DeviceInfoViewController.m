//
//  DeviceInfoViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-31.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "CDIDevice.h"
#import "CDINetClient.h"
#import "DeviceInfoHistoryCell.h"
#import "CDIApplication.h"
#import "UIImageView+Addition.h"
#import "UIView+Addition.h"
#import "NSDate+Addition.h"

@interface DeviceInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *deviceStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *reserveButton;
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

@end

@implementation DeviceInfoViewController

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
  _historyTableView.dataSource = self;
  _historyTableView.delegate = self;
  [_deviceNameLabel setText:self.currentDevice.deviceName];
  [_deviceTypeLabel setText:self.currentDevice.deviceType];
  [_deviceStatusLabel setText:self.currentDevice.deviceStatus];
  if (self.currentDevice.available.boolValue) {
    [_deviceStatusLabel setTextColor:kColorTintGreen];
    [_deviceStatusImageView setImage:[UIImage imageNamed:@"icon_available"]];
  } else {
    [_deviceStatusLabel setTextColor:kColorTintRed];
    [_deviceStatusImageView setImage:[UIImage imageNamed:@"icon_unavailable"]];
  }
  
  NSString *buttonTitle = @"";
  if (self.currentDevice.available.boolValue) {
    if ([self.currentDevice.deviceStatus isEqualToString:@"Pending"]) {
      buttonTitle = @"Reservation Pending";
      self.reserveButton.enabled = NO;
    } else {
      buttonTitle = @"Reserve";
      self.reserveButton.enabled = YES;
    }
  } else {
    buttonTitle = @"Device Unavailable";
    self.reserveButton.enabled = NO;
  }
  [self.reserveButton setTitle:buttonTitle forState:UIControlStateNormal];
  [self.reserveButton setTitle:buttonTitle forState:UIControlStateHighlighted];
  [self.reserveButton setTitle:buttonTitle forState:UIControlStateDisabled];
  [self loadData];
}

- (void)loadData
{
  CDINetClient *client = [CDINetClient client];
  void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
    NSDictionary *rawDict = responseData;
    if ([responseData isKindOfClass:[NSDictionary class]]) {
      NSArray *peopleArray = rawDict[@"data"];
      for (NSDictionary *dict in peopleArray) {
        [CDIApplication insertApplicationInfoWithDict:dict inManagedObjectContext:self.managedObjectContext];
      }
      [self.managedObjectContext processPendingChanges];
      [self.fetchedResultsController performFetch:nil];
      
      [self.historyTableView reloadData];
    }
  };
  
  [client getDeviceApplicationListWithDeviceID:self.currentDevice.deviceID
                                    completion:handleData];
}

- (void)configureRequest:(NSFetchRequest *)request
{
  request.entity = [NSEntityDescription entityForName:@"CDIApplication"
                               inManagedObjectContext:self.managedObjectContext];
  request.predicate = [NSPredicate predicateWithFormat:@"deviceID == %@", self.currentDevice.deviceID];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"applicationID" ascending:NO];
  request.sortDescriptors = @[sortDescriptor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
  NSInteger count = self.fetchedResultsController.fetchedObjects.count;
  return count == 0 ? 1 : count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  DeviceInfoHistoryCell *cell = [self.historyTableView dequeueReusableCellWithIdentifier:@"DeviceInfoHistoryCell"];
  cell.isPlaceHolder = self.fetchedResultsController.fetchedObjects.count == 0;
  if (!cell.isPlaceHolder) {
    CDIApplication *application = self.fetchedResultsController.fetchedObjects[indexPath.row];
    [cell.userAvatarImageView loadImageFromURL:application.userAvatarURL completion:^(BOOL succeeded) {
      [cell.userAvatarImageView fadeIn];
    }];
    [cell.userNameLabel setText:application.userRealName];
    [cell.statusLabel setText:application.deviceStatus];
    
    NSString *startDateString = [NSDate stringOfDate:application.borrowDate includingYear:YES];
    NSString *endDateString = [NSDate stringOfDate:application.dueDate includingYear:YES];
    NSString *dateString = [NSString stringWithFormat:@"From %@ to %@", startDateString, endDateString];
    
    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:dateString];
    
    [titleAttributedString addAttribute:NSForegroundColorAttributeName
                                  value:kColorTintGray150
                                  range:NSMakeRange(0, titleAttributedString.length)];
    [titleAttributedString addAttribute:NSForegroundColorAttributeName
                                  value:kColorTintBlue
                                  range:NSMakeRange(5, startDateString.length)];
    [titleAttributedString addAttribute:NSForegroundColorAttributeName
                                  value:kColorTintBlue
                                  range:NSMakeRange(9 + startDateString.length, endDateString.length)];
    
    cell.borrowDurationLabel.attributedText = titleAttributedString;
    
    if ([application.deviceStatus isEqualToString:@"Pending"]) {
      cell.statusLabel.textColor = kColorTintYellow;
    } else if ([application.deviceStatus isEqualToString:@"Approved"]) {
      cell.statusLabel.textColor = kColorTintGreen;
    } else if ([application.deviceStatus isEqualToString:@"Rejected"]) {
      cell.statusLabel.textColor = kColorTintRed;
    } else if ([application.deviceStatus isEqualToString:@"Overtime"]) {
      cell.statusLabel.textColor = kColorTintRed;
    } else if ([application.deviceStatus isEqualToString:@"Returned"]) {
      cell.statusLabel.textColor = kColorTintGreen;
    } else if ([application.deviceStatus isEqualToString:@"Cancelled"]) {
      cell.statusLabel.textColor = kColorTintRed;
    }
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 78;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//  ProjectDetailViewController *vc = segue.destinationViewController;
//  vc.work = self.selectedWork;
}

#pragma mark - IBActions
- (IBAction)didClickBackButton:(UIButton *)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

@end
