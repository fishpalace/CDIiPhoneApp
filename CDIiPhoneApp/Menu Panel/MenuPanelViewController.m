//
//  MenuPanelViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-7.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "MenuPanelViewController.h"
#import "UIView+Resize.h"
#import "MPDragIndicatorView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSNotificationCenter+Addition.h"
#import "ModelPanelViewController.h"
#import "TimeDisplayPanelViewController.h"
#import "CDIDataSource.h"
#import "MenuItemCell.h"

@interface MenuPanelViewController ()

@property (nonatomic, strong) MPDragIndicatorView *dragIndicatorView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UIButton *checkRoomA;
@property (weak, nonatomic) IBOutlet UIButton *checkRoomB;
@property (weak, nonatomic) IBOutlet UIButton *checkRoomC;
@property (weak, nonatomic) IBOutlet UIButton *checkRoomD;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *iconImageNameArray;

@end

@implementation MenuPanelViewController

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
  [self.tableView setTableFooterView:self.dragIndicatorView];
  [self.dragIndicatorView configureScrollView:self.tableView];
  self.dragIndicatorView.stretchLimitHeight = 100;
  self.dragIndicatorView.delegate = self;
  _tableView.delegate = self;
  _tableView.dataSource = self;
}

- (void)setUp
{
  self.avatarImageView.layer.borderColor = [UIColor blackColor].CGColor;
  self.avatarImageView.layer.borderWidth = 1;
}

- (void)refresh
{
  [self.tableView setContentOffset:CGPointZero];
  [self.dragIndicatorView resetHeight:kDragIndicatorViewHeight];
  [self.dragIndicatorView resetWidth:320];
  [self.dragIndicatorView resetPositions];
}

- (NSString *)imageNameForStatusWithRoomID:(NSInteger)roomID
{
  NSString *imageName = nil;
  CDIRoomStatus status = [CDIDataSource statusForRoom:roomID isToday:YES];
  if (status == CDIRoomStatusAvailable) {
    imageName = @"menu_room_clear";
  } else if (status == CDIRoomStatusBusy) {
    imageName = @"menu_room_available";
  } else {
    imageName = @"menu_room_unavailable";
  }
  return imageName;
}

- (void)dragIndicatorViewDidStrecth:(MPDragIndicatorView *)view
{
  [NSNotificationCenter postShouldBounceUpNotification];
}

#pragma mark - Table View Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
  UIView *view = nil;
  if (section == 0) {
    view = [[UIView alloc] initWithFrame:CGRectMake(0, -1, 320, 15)];
    view.backgroundColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
  }
  return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat height = 60;
  if (indexPath.section == 1 && indexPath.row == 3) {
    height = 143;
  }
  return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  CGFloat height = 0;
  if (section == 0) {
    height = 15;
  }
  return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger numberOfRows = 0;
  if (section == 0) {
    numberOfRows = 2;
  } else {
    numberOfRows = 4;
  }
  return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = nil;
  if (indexPath.section == 1 && indexPath.row == 3) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"MenuRoomInfoCell"];
  } else {
    cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCell"];
  }

  return cell;
}

#pragma mark - IBActions
- (IBAction)didClickCheckRoomButton:(UIButton *)sender
{
//  [self displayModelPanelWithRoomID:sender.tag];
}

- (void)displayModelPanelWithRoomID:(NSInteger)roomID
{
//  TimeDisplayPanelViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeDisplayPanelViewController"];
//  vc.roomID = roomID;
//  [ModelPanelViewController displayModelPanelWithViewController:vc];
}

#pragma mark - Properties
- (MPDragIndicatorView *)dragIndicatorView
{
  if (!_dragIndicatorView) {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MPDragIndicatorView"
                                                  owner:self
                                                options:nil];
    _dragIndicatorView = [nibs objectAtIndex:0];
    _dragIndicatorView.isReversed = YES;
  }
  return _dragIndicatorView;
}

@end
