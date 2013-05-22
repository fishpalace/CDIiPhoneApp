//
//  ViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-3.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "MainPanelViewController.h"
#import "MPTableViewCell.h"
#import "MPDragIndicatorView.h"
#import "MenuPanelViewController.h"
#import "UIView+Resize.h"
#import "UIApplication+Addition.h"
#import <QuartzCore/QuartzCore.h>

#define kDragIndicatorViewHeight 32

@interface MainPanelViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MPDragIndicatorView *dragIndicatorView;
@property (strong, nonatomic) MenuPanelViewController *menuPanelViewController;
@property (assign, nonatomic) NSInteger currentActiveRow;
@property (weak, nonatomic) IBOutlet UIView *tableViewContainerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewTopSpaceConstraint;

@end

@implementation MainPanelViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self configureBasicViews];
}

#pragma mark - View Setup Methods
- (void)configureBasicViews
{
  UIImage *backgroundImage = [[UIImage imageNamed:@"mp_bg"] resizableImageWithCapInsets:UIEdgeInsetsZero];
  [self.backgroundImageView setImage:backgroundImage];
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.tableView setTableHeaderView:self.dragIndicatorView];
  self.dragIndicatorView.stretchLimitHeight = 120;
  self.dragIndicatorView.delegate = self;
  [self.dragIndicatorView configureTableView:self.tableView];
  
  [self.menuPanelViewController setUp];
}

- (void)viewDidAppear:(BOOL)animated
{
  [self.dragIndicatorView resetHeight:kDragIndicatorViewHeight];
  [self.menuPanelViewController.view resetOrigin:CGPointZero];
  [self.menuPanelViewController.view resetSize:kCurrentScreenSize];
}

- (void)updateViewConstraints
{
  [super updateViewConstraints];
  self.tableViewHeightConstraint.constant = kCurrentScreenHeight;
  self.tableViewTopSpaceConstraint.constant = kCurrentScreenHeight;
  self.containerViewTopSpaceConstraint.constant = -kCurrentScreenHeight;
}

- (IBAction)clickButton:(id)sender
{
  NSLog(@"container, %@", NSStringFromCGRect(self.tableViewContainerView.frame));
  NSLog(@"menupanel, %@", NSStringFromCGRect(self.menuPanelViewController.view.frame));
  NSLog(@"tableview, %@", NSStringFromCGRect(self.tableView.frame));
  NSLog(@"headerview, %@", NSStringFromCGRect(self.dragIndicatorView.frame));
}

#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"MPTableViewCell";
  MPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  [cell.contentTableViewController setUpWithRow:indexPath.row delegate:self];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 200;
}

#pragma mark - MPCell Table View Delegate
- (void)cellForRow:(NSInteger)row didMoveByOffset:(CGFloat)offset
{
  NSArray *visibleCells = self.tableView.visibleCells;
  for (MPTableViewCell *cell in visibleCells) {
    MPCellTableViewController *cellTableViewController = cell.contentTableViewController;
    NSInteger gap = abs(cellTableViewController.row - row);
    if (gap != 0) {
      [cellTableViewController moveByOffset:offset / ((CGFloat)gap + 1.0)];
    }
  }
}

- (void)registerCurrentActiveRow:(NSInteger)row
{
  self.currentActiveRow = row;
}

- (BOOL)isActiveForRow:(NSInteger)row
{
  return self.currentActiveRow == row;
}

#pragma mark - Drag View Delegate
- (void)dragIndicatorViewDidStrecth:(MPDragIndicatorView *)view
{
  [self showMenuPanel];
}

- (void)showMenuPanel
{
  [self.tableView resetOriginY:kCurrentScreenHeight - self.tableView.contentOffset.y];
  self.tableView.scrollEnabled = NO;
  self.tableView.scrollEnabled = YES;

  [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    [self.tableViewContainerView resetOriginY:0];
  } completion:^(BOOL finished) {
    [self.tableView resetOriginY:kCurrentScreenHeight];
  }];
}

#pragma mark - Property
- (MPDragIndicatorView *)dragIndicatorView
{
  if (!_dragIndicatorView) {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MPDragIndicatorView"
                                                  owner:self
                                                options:nil];
    _dragIndicatorView = [nibs objectAtIndex:0];
    [_dragIndicatorView resetHeight:32];
  }
  return _dragIndicatorView;
}

- (MenuPanelViewController *)menuPanelViewController
{
  if (!_menuPanelViewController) {
    _menuPanelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuPanelViewController"];
    [self.tableViewContainerView addSubview:_menuPanelViewController.view];
  }
  return _menuPanelViewController;
}

@end
