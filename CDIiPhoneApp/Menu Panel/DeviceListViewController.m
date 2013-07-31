//
//  DeviceListViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-30.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "DeviceListViewController.h"
#import "CDINetClient.h"
#import "CDIDevice.h"
#import "DeviceListAllDeviceCell.h"

@interface DeviceListViewController ()

@property (weak, nonatomic) IBOutlet UIButton *segmentAllButton;
@property (weak, nonatomic) IBOutlet UIButton *segmentMyButton;
@property (weak, nonatomic) IBOutlet UITableView *allDeviceTableView;
@property (weak, nonatomic) IBOutlet UITableView *myApplicationTableView;

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
  [self loadData];
  self.myApplicationTableView.hidden = YES;
  self.allDeviceTableView.hidden = NO;
  _segmentAllButton.selected = YES;
  _segmentMyButton.selected = NO;
}

- (void)loadData
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

- (void)configureRequest:(NSFetchRequest *)request
{
  request.entity = [NSEntityDescription entityForName:@"CDIDevice"
                               inManagedObjectContext:self.managedObjectContext];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"deviceID" ascending:YES];
  request.sortDescriptors = @[sortDescriptor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
  NSInteger count = self.fetchedResultsController.fetchedObjects.count;
  return count == 0 ? 1 : count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//  self.selectedWork = self.fetchedResultsController.fetchedObjects[indexPath.row];
//  [self performSegueWithIdentifier:@"ProjectDetailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//  ProjectDetailViewController *vc = segue.destinationViewController;
//  vc.work = self.selectedWork;
}

- (IBAction)didClickBackButton:(UIButton *)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (NSFetchedResultsController *)myApplicationFetchedResultsController
{
  if (_myApplicationFetchedResultsController == nil) {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"CDIDevice"
                                 inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"deviceID" ascending:NO];
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
