//
//  PeopleInfoViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-4.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "PeopleInfoViewController.h"
#import "PIWorkListCell.h"
#import "CDIUser.h"

@interface PeopleInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPositionLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoHomepageButton;
@property (weak, nonatomic) IBOutlet UIButton *infoDribbleButton;
@property (weak, nonatomic) IBOutlet UIButton *infoWeiboButton;
@property (weak, nonatomic) IBOutlet UIButton *infoLinkedinButton;
@property (weak, nonatomic) IBOutlet UIButton *infoTwitterButton;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation PeopleInfoViewController

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
  _userPositionLabel.text = self.user.position;
  _userTitleLabel.text = self.user.title;
  _tableview.delegate = self;
  _tableview.dataSource = self;
  _userTitleLabel.layer.cornerRadius = 5;
  _userTitleLabel.layer.masksToBounds = YES;
  _userPositionLabel.layer.cornerRadius = 5;
  _userPositionLabel.layer.masksToBounds = YES;
}

- (void)configureRequest:(NSFetchRequest *)request
{
  request.entity = [NSEntityDescription entityForName:@"CDIWork"
                               inManagedObjectContext:self.managedObjectContext];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"nameEn" ascending:YES];
  request.predicate = [NSPredicate predicateWithFormat:@"SELF IN %@", self.user.relatedWork];
  request.sortDescriptors = @[sortDescriptor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger numberOfRows = self.fetchedResultsController.fetchedObjects.count;
  numberOfRows = numberOfRows == 0 ? 1 : numberOfRows;
  return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  PIWorkListCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"PIWorkListCell"];
  
  cell.isPlaceHolder = self.fetchedResultsController.fetchedObjects.count == 0;
  if (!cell.isPlaceHolder) {

  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80;
}

@end
