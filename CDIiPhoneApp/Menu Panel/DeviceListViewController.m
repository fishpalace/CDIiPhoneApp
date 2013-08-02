//
//  DeviceListViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-30.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "DeviceListViewController.h"
#import "DeviceInfoViewController.h"
#import "CDINetClient.h"
#import "CDIDevice.h"
#import "DeviceListAllDeviceCell.h"
#import "DeviceListMyApplicationCell.h"
#import "CDIApplication.h"
#import "NSDate+Addition.h"

@interface DeviceListViewController ()

@property (weak, nonatomic) IBOutlet UIButton *segmentAllButton;
@property (weak, nonatomic) IBOutlet UIButton *segmentMyButton;
@property (weak, nonatomic) IBOutlet UITableView *allDeviceTableView;
@property (weak, nonatomic) IBOutlet UITableView *myApplicationTableView;

@property (nonatomic, weak) CDIDevice *selectedDevice;

@property (nonatomic, strong) NSFetchedResultsController *myApplicationFetchedResultsController;

@end

@implementation DeviceListViewController

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
  _allDeviceTableView.delegate = self;
  _allDeviceTableView.dataSource = self;
  _myApplicationTableView.delegate = self;
  _myApplicationTableView.dataSource = self;
  self.myApplicationTableView.hidden = YES;
  self.allDeviceTableView.hidden = NO;
  _segmentAllButton.selected = YES;
  _segmentMyButton.selected = NO;
  
  [self loadDeviceData];
  [self loadApplicationData];
}

- (void)loadDeviceData
{
  CDINetClient *client = [CDINetClient client];
  void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
    NSDictionary *rawDict = responseData;
    if ([responseData isKindOfClass:[NSDictionary class]]) {
      NSArray *peopleArray = rawDict[@"data"];
      for (NSDictionary *dict in peopleArray) {
        [CDIDevice insertDeviceInfoWithDict:dict inManagedObjectContext:self.managedObjectContext];
      }
      [self.managedObjectContext processPendingChanges];
      [self.fetchedResultsController performFetch:nil];
      
      [self.allDeviceTableView reloadData];
    }
  };
  
  [client getDeviceListWithCompletion:handleData];
}

- (void)loadApplicationData
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
      [self.myApplicationFetchedResultsController performFetch:nil];
      
      [self.myApplicationTableView reloadData];
    }
  };
  
  [client getDeviceApplicationListWithCurrentUserID:self.currentUser.userID
                                         completion:handleData];
}

- (void)configureRequest:(NSFetchRequest *)request
{
  request.entity = [NSEntityDescription entityForName:@"CDIDevice"
                               inManagedObjectContext:self.managedObjectContext];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"deviceID" ascending:YES];
  request.sortDescriptors = @[sortDescriptor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
  NSInteger count = 0;
  if ([tableView isEqual:self.allDeviceTableView]) {
    count = self.fetchedResultsController.fetchedObjects.count;
  } else if ([tableView isEqual:self.myApplicationTableView]) {
    count = self.myApplicationFetchedResultsController.fetchedObjects.count;
  }

  return count == 0 ? 1 : count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = nil;
  
  if ([tableView isEqual:self.allDeviceTableView]) {
    cell = [self cellOfDeviceForRowAtIndexPath:indexPath];
  } else if ([tableView isEqual:self.myApplicationTableView]) {
    cell = [self cellOfApplicationForRowAtIndexPath:indexPath];
  }
  
  return cell;
}

- (UITableViewCell *)cellOfDeviceForRowAtIndexPath:(NSIndexPath *)indexPath
{
  DeviceListAllDeviceCell *cell = [self.allDeviceTableView dequeueReusableCellWithIdentifier:@"DeviceListAllDeviceCell"];
  cell.isPlaceHolder = self.fetchedResultsController.fetchedObjects.count == 0;
  if (!cell.isPlaceHolder) {
    CDIDevice *device = self.fetchedResultsController.fetchedObjects[indexPath.row];
    
    [cell.deviceNameLabel setText:device.deviceName];
    [cell.deviceTypeLabel setText:device.deviceType];
    if (device.available.boolValue) {
      cell.deviceStatusImageView.image = [UIImage imageNamed:@"icon_available"];
    } else {
      cell.deviceStatusImageView.image = [UIImage imageNamed:@"icon_unavailable"];
    }
  }
  return cell;
}

- (UITableViewCell *)cellOfApplicationForRowAtIndexPath:(NSIndexPath *)indexPath
{
  DeviceListMyApplicationCell *cell = [self.myApplicationTableView dequeueReusableCellWithIdentifier:@"DeviceListMyApplicationCell"];
  cell.isPlaceHolder = self.myApplicationFetchedResultsController.fetchedObjects.count == 0;
  if (!cell.isPlaceHolder) {
    CDIApplication *application = self.myApplicationFetchedResultsController.fetchedObjects[indexPath.row];
    
    [cell.deviceNameLabel setText:application.deviceName];
    UIColor *color = nil;
    NSString *resultString = @"";
    NSString *dateString = [NSDate stringOfDate:application.borrowDate includingYear:YES];
    if ([application.deviceStatus isEqualToString:@"Pending"]) {
      cell.deviceStatusImageView.image = [UIImage imageNamed:@"icon_pending"];
      resultString = @"Pending ";
      color = kColorTintYellow;
    } else if ([application.deviceStatus isEqualToString:@"Approved"]) {
      cell.deviceStatusImageView.image = [UIImage imageNamed:@"icon_approved"];
      resultString = [NSString stringWithFormat:@"Approved %@", dateString];
      color = kColorTintGreen;
    } else if ([application.deviceStatus isEqualToString:@"Rejected"]) {
      cell.deviceStatusImageView.image = [UIImage imageNamed:@"icon_rejected"];
      resultString = [NSString stringWithFormat:@"Approved %@", dateString];
      color = kColorTintRed;
    } else if ([application.deviceStatus isEqualToString:@"Overtime"]) {
      cell.deviceStatusImageView.image = [UIImage imageNamed:@"icon_rejected"];
      resultString = [NSString stringWithFormat:@"Overtime %@", dateString];
      color = kColorTintRed;
    } else if ([application.deviceStatus isEqualToString:@"Returned"]) {
      cell.deviceStatusImageView.image = [UIImage imageNamed:@"icon_approved"];
      resultString = [NSString stringWithFormat:@"Approved %@", dateString];
      color = kColorTintGreen;
    } else if ([application.deviceStatus isEqualToString:@"Cancelled"]) {
      cell.deviceStatusImageView.image = [UIImage imageNamed:@"icon_rejected"];
      resultString = [NSString stringWithFormat:@"Cancelled %@", dateString];
      color = kColorTintRed;
    }
    [cell.deviceTypeLabel setText:resultString];
    [cell.deviceTypeLabel setTextColor:color];
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([tableView isEqual:self.allDeviceTableView]) {
    self.selectedDevice = self.fetchedResultsController.fetchedObjects[indexPath.row];
    [self performSegueWithIdentifier:@"DeviceInfoSegue" sender:self];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  DeviceInfoViewController *vc = segue.destinationViewController;
  vc.currentDevice = self.selectedDevice;
  vc.previousController = self;
  vc.appliedDeviceStrings = [NSMutableArray array];
  for (CDIApplication *application in self.myApplicationFetchedResultsController.fetchedObjects) {
    [vc.appliedDeviceStrings addObject:application.deviceID];
  }
}

#pragma mark - IBActions
- (IBAction)didClickBackButton:(UIButton *)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickSegmentButton:(UIButton *)sender
{
  BOOL didClickMyButton = [self.segmentMyButton isEqual:sender];
  self.segmentMyButton.selected = didClickMyButton;
  self.segmentMyButton.userInteractionEnabled = !didClickMyButton;
  self.segmentAllButton.selected = !didClickMyButton;
  self.segmentAllButton.userInteractionEnabled = didClickMyButton;
  self.myApplicationTableView.hidden = !didClickMyButton;
  self.allDeviceTableView.hidden = didClickMyButton;
}


- (NSFetchedResultsController *)myApplicationFetchedResultsController
{
  if (_myApplicationFetchedResultsController == nil) {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"CDIApplication"
                                 inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"applicationID" ascending:NO];
    request.sortDescriptors = @[sortDescriptor];
    
    _myApplicationFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:self.managedObjectContext
                                                                                   sectionNameKeyPath:nil cacheName:nil];
    _myApplicationFetchedResultsController.delegate = self;
    
    [_myApplicationFetchedResultsController performFetch:nil];
  }
  return _myApplicationFetchedResultsController;
}

@end
