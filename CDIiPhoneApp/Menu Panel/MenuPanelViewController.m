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
    NSInteger index = indexPath.section == 1 ? indexPath.row + 2 : indexPath.row;
    MenuItemCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCell"];
    detailCell.iconImageView.image = [UIImage imageNamed:self.iconImageNameArray[index]];
    detailCell.titleLabel.text = self.titleArray[index];
    detailCell.functionButton.hidden = indexPath.row != 0 || indexPath.section == 1;
    detailCell.displayButton.hidden = indexPath.row != 1 || indexPath.section == 1;
    cell = detailCell;
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *segueID = @"";
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      segueID = @"MenuScheduleSegue";
    }
  } else {
    if (indexPath.row == 2) {
      segueID = @"MenuPeopleSegue";
    }
  }
  [self performSegueWithIdentifier:segueID sender:self];
}

#pragma mark - IBActions
- (IBAction)didClickCheckRoomButton:(UIButton *)sender
{
  [self displayModelPanelWithRoomID:sender.tag];
}

- (void)displayModelPanelWithRoomID:(NSInteger)roomID
{
  TimeDisplayPanelViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeDisplayPanelViewController"];
  vc.roomID = roomID;
  
  char title = 'A' + roomID - 1;
  NSString *roomTitle = [NSString stringWithFormat:@"%c %@", title, [CDIDataSource nameForRoomID:roomID]];
  
  [ModelPanelViewController displayModelPanelWithViewController:vc
                                                  withTitleName:roomTitle
                                             functionButtonName:@"Reserve"
                                                       imageURL:@""
                                                           type:ModelPanelTypeRoomInfo];
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

- (NSMutableArray *)iconImageNameArray
{
  if (!_iconImageNameArray) {
    _iconImageNameArray = [NSMutableArray arrayWithObjects:@"menu_icon_cal", @"menu_icon_key",
                           @"menu_icon_news", @"menu_icon_proj", @"menu_icon_people", nil];
  }
  return _iconImageNameArray;
}

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
      _titleArray = [NSMutableArray arrayWithObjects:@"Schedule", @"My Reservations",
                     @"News", @"Projects", @"People", nil];
  }
    return _titleArray;
}

@end
