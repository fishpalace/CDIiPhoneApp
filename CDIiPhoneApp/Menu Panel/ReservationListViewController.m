//
//  ReservationListViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-28.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "ReservationListViewController.h"
#import "UIView+Resize.h"
#import "CDIEventDAO.h"
#import "NSDate+Addition.h"

@interface ReservationListViewController ()

@property (nonatomic, strong) ScheduleListTableViewController *tableViewController;

@end

@implementation ReservationListViewController

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
  self.tableViewController.delegate = self;
}

#pragma mark - Schedule List Table View Controller Delegate
- (void)slTableViewController:(ScheduleListTableViewController *)vc configureRequest:(NSFetchRequest *)request
{
  [self configureRequest:request];
}

- (void)configureRequest:(NSFetchRequest *)request
{
  request.entity = [NSEntityDescription entityForName:@"CDIEvent"
                               inManagedObjectContext:self.managedObjectContext];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES];
  
  request.sortDescriptors = @[sortDescriptor];
  request.predicate = [NSPredicate predicateWithFormat:@"creator == %@ && passed == 0", self.currentUser];
}

- (void)didSelectEvent:(CDIEventDAO *)event
{
  [CDIEventDAO updateSharedNewEvent:event];
  [self performSegueWithIdentifier:@"ReservationInfoSegue" sender:self];
}

#pragma mark - IBActions

- (IBAction)didClickBackButton:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (ScheduleListTableViewController *)tableViewController
{
  if (!_tableViewController) {
    _tableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScheduleListTableViewController"];
    
    [self addChildViewController:_tableViewController];
    [_tableViewController.view resetSize:CGSizeMake(320, kCurrentScreenHeight - kTopBarHeight)];
    [_tableViewController.view resetOrigin:CGPointMake(0, kTopBarHeight)];
    [self.view addSubview:_tableViewController.view];
    [_tableViewController didMoveToParentViewController:self];
  }
  return _tableViewController;
}

@end
