//
//  PeopleListViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-3.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "PeopleListViewController.h"
#import "PeopleListCollectionViewCell.h"
#import "PeopleInfoViewController.h"
#import "ModelPanelViewController.h"
#import "CDIUser.h"
#import "CDINetClient.h"
#import "UIImageView+AFNetworking.h"

@interface PeopleListViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) NSMutableArray *userArray;

@end

@implementation PeopleListViewController

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
  _collectionView.delegate = self;
  _collectionView.dataSource = self;
  _collectionView.collectionViewLayout = self.layout;
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
        [CDIUser insertUserInfoWithDict:dict inManagedObjectContext:self.managedObjectContext];
      }
      [self.managedObjectContext processPendingChanges];
      [self.fetchedResultsController performFetch:nil];
      
      [self.collectionView reloadData];
    }
  };
  
  [client getUserListWithCompletion:handleData];
}

- (void)configureRequest:(NSFetchRequest *)request
{
  request.entity = [NSEntityDescription entityForName:@"CDIUser"
                               inManagedObjectContext:self.managedObjectContext];
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  request.sortDescriptors = @[sortDescriptor];
}

- (IBAction)didClickBackButton:(UIButton *)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.fetchedResultsController.fetchedObjects.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"PeopleListCollectionViewCell";
  
  PeopleListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  
  CDIUser *user = self.fetchedResultsController.fetchedObjects[indexPath.row];
  cell.userNameLabel.text = user.name;
  cell.userPositionLabel.text = user.position;
  cell.userTitleLabel.text = user.title;
  [cell.avatarImageView setImageWithURL:[NSURL URLWithString:user.avatarMidURL]];

  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  PeopleInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PeopleInfoViewController"];
  vc.user = self.fetchedResultsController.fetchedObjects[indexPath.row];
  vc.index = indexPath.row;
  [ModelPanelViewController displayModelPanelWithViewController:vc
                                                  withTitleName:vc.user.name
                                             functionButtonName:@"Write"
                                                       imageURL:vc.user.avatarSmallURL
                                                           type:ModelPanelTypePeopleInfo];
}

- (NSMutableArray *)userArray
{
  if (!_userArray) {
    _userArray = [NSMutableArray array];
    CDIUser *user1 = [[CDIUser alloc] initWithName:@"Xiaohua Sun" title:@"Professor" position:@"Director of CDI"];
    CDIUser *user2 = [[CDIUser alloc] initWithName:@"Evan Fung" title:@"Student" position:@"Project Manager"];
    CDIUser *user3 = [[CDIUser alloc] initWithName:@"Alex Yan" title:@"Student" position:@"Web Engineer"];
    CDIUser *user4 = [[CDIUser alloc] initWithName:@"Gabriel Yeah" title:@"Student" position:@"iOS Engineer"];
    CDIUser *user5 = [[CDIUser alloc] initWithName:@"Zexi Feng" title:@"Student" position:@"Designer"];
    CDIUser *user6 = [[CDIUser alloc] initWithName:@"Yayi Tang" title:@"Student" position:@"Designer"];
    
    [_userArray addObject:user1];
    [_userArray addObject:user2];
    [_userArray addObject:user3];
    [_userArray addObject:user4];
    [_userArray addObject:user5];
    [_userArray addObject:user6];
  }
  return _userArray;
}

- (UICollectionViewFlowLayout *)layout
{
  if (!_layout) {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    [_layout setItemSize:CGSizeMake(160, 220)];
    [_layout setMinimumInteritemSpacing:0];
    [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];
  }
  return _layout;
}

@end
