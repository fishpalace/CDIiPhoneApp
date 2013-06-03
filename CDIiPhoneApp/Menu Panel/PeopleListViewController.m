//
//  PeopleListViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-3.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "PeopleListViewController.h"
#import "PeopleListCollectionViewCell.h"

@interface PeopleListViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

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
}

- (IBAction)didClickBackButton:(UIButton *)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"PeopleListCollectionViewCell";
  
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

  return cell;
}

- (UICollectionViewFlowLayout *)layout
{
  if (!_layout) {
    _layout = [[UICollectionViewFlowLayout alloc] init];
    [_layout setItemSize:CGSizeMake(150, 220)];
    [_layout setMinimumInteritemSpacing:10];
    [_layout setScrollDirection:UICollectionViewScrollDirectionVertical];
  }
  return _layout;
}

@end
