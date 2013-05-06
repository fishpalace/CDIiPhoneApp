//
//  ViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-3.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "MainPanelViewController.h"
#import "MPTableViewCell.h"

@interface MainPanelViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger currentActiveRow;

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

@end
