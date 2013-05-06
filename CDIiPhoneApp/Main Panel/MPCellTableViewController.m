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

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)setUpWithRow:(NSInteger)row delegate:(id<MPCellTableViewControllerDelegate>)delegate
{
  [self.view resetOrigin:CGPointZero];
  self.row = row;
  self.delegate = delegate;
}

- (void)moveByOffset:(CGFloat)offset
{
  CGPoint currentOffset = self.tableView.contentOffset;
  CGPoint targetPoint = CGPointMake(currentOffset.x, currentOffset.y + offset);
  [self.tableView setContentOffset:targetPoint];
  NSLog(@"row:%d, offset:%f", self.row, self.tableView.contentOffset.y);
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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

@end
