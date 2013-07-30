//
//  DeviceListViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-30.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "DeviceListViewController.h"
#import "CDINetClient.h"

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
	// Do any additional setup after loading the view.
}

- (void)loadData
{
  CDINetClient *client = [CDINetClient client];
  void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
    NSDictionary *rawDict = responseData;
    if ([responseData isKindOfClass:[NSDictionary class]]) {
      NSArray *peopleArray = rawDict[@"data"];
      for (NSDictionary *dict in peopleArray) {
//        [CDIWork insertWorkInfoWithDict:dict inManagedObjectContext:self.managedObjectContext];
      }
      [self.managedObjectContext processPendingChanges];
      [self.fetchedResultsController performFetch:nil];
      
//      [self.tableView reloadData];
    }
  };
  
  [client getProjectListWithCompletion:handleData];
}

- (void)configureRequest:(NSFetchRequest *)request
{
  request.entity = [NSEntityDescription entityForName:@"CDIWork"
                               inManagedObjectContext:self.managedObjectContext];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"workID" ascending:NO];
  request.sortDescriptors = @[sortDescriptor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
  NSInteger count = self.fetchedResultsController.fetchedObjects.count;
  return count == 0 ? 1 : count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//  ProjectListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ProjectListTableViewCell"];
//  cell.isPlaceHolder = self.fetchedResultsController.fetchedObjects.count == 0;
//  if (!cell.isPlaceHolder) {
//    CDIWork *work = self.fetchedResultsController.fetchedObjects[indexPath.row];
//    [cell.imageView loadImageFromURL:work.previewImageURL completion:^(BOOL succeeded) {
//      [cell.imageView fadeIn];
//    }];
//    [cell.projectNameLabel setText:work.name];
//    [cell.projectStatusLabel setText:work.workStatus];
//    [cell.projectTypeLabel setText:work.workType];
//  }
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 90;
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
