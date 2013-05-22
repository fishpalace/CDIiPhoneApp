//
//  MPCellTableViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-4.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "MPCellTableViewController.h"
#import "MPCellTableViewCell.h"
#import "UIView+Resize.h"

@interface MPCellTableViewController ()

@property (nonatomic, assign) CGFloat prevOffset;

@end

@implementation MPCellTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)setUpWithRow:(NSInteger)row delegate:(id<MPCellTableViewControllerDelegate>)delegate
{
  [self.view resetOrigin:CGPointZero];
  self.row = row;
  self.delegate = delegate;
  self.tableView.contentOffset = CGPointMake(0.0, 0.5);
}

- (void)moveByOffset:(CGFloat)offset
{
  CGPoint currentOffset = self.tableView.contentOffset;
  CGPoint targetPoint = CGPointMake(currentOffset.x, currentOffset.y + offset);
  [self.tableView setContentOffset:targetPoint];
}

#pragma mark - Table view data source

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
  static NSString *CellIdentifier = @"MPCellTableViewCell";
  MPCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 200;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Navigation logic may go here. Create and push another view controller.
  /*
   <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   */
}

#pragma mark - Scroll View delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  self.prevOffset = scrollView.contentOffset.y;
  if ([self.delegate respondsToSelector:@selector(registerCurrentActiveRow:)]) {
    [self.delegate registerCurrentActiveRow:self.row];
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  BOOL shouldAffectOtherCells = NO;
  if ([self.delegate respondsToSelector:@selector(isActiveForRow:)]) {
    shouldAffectOtherCells = [self.delegate isActiveForRow:self.row];
  }
  
  if (shouldAffectOtherCells && [self.delegate respondsToSelector:@selector(cellForRow:didMoveByOffset:)]) {
    [self.delegate cellForRow:self.row didMoveByOffset:scrollView.contentOffset.y - self.prevOffset];
    self.prevOffset = scrollView.contentOffset.y;
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  CGFloat maxOffsetY = scrollView.contentSize.height - scrollView.frame.size.width;
  CGFloat minOffsetY = 0;
  if (scrollView.contentOffset.y == minOffsetY) {
    scrollView.contentOffset = CGPointMake(0.0, minOffsetY + 0.5);
  } else if (scrollView.contentOffset.y == maxOffsetY) {
    scrollView.contentOffset = CGPointMake(0.0, maxOffsetY - 0.5);
  }
}

@end
