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
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "UIImageView+Addition.h"
#import "UIView+Addition.h"
#import "NSNotificationCenter+Addition.h"

#define SeeAllTableCellNumber 1

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
    [NSNotificationCenter registerDidFetchNewDataNotificationWithSelector:@selector(refresh) target:self];
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

- (void)refresh
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if ([self.delegate respondsToSelector:@selector(numberOfRowsAtRow:)]) {
        numberOfRows = [self.delegate numberOfRowsAtRow:self.row];
    }
    
    if (self.row != 0) {
        numberOfRows = numberOfRows + SeeAllTableCellNumber;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MPCellTableViewCell";
    MPCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.seeAllLabel.hidden = YES;
    
    if (indexPath.row == [self.delegate numberOfRowsAtRow:self.row] && self.row != 0) {
        cell.seeAllLabel.hidden = NO;
        cell.isSeeAllCell = YES;
        if (self.row == 1) {
            cell.isCDIProjectsCell = YES;
        }
        else if (self.row == 2) {
            cell.isCDIProjectsCell = NO;
        }
    }
    else
        cell.isSeeAllCell = NO;
    
    
    if (cell.isSeeAllCell) {
        cell.isSeeAllCell = YES;
        cell.contentLabel.text = @"";
        cell.contentImageView.image = nil;
        cell.coverImageView.image = nil;
    }
    else {
        NSString *imageName = @"";
        if ([self.delegate respondsToSelector:@selector(imageURLForCellAtIndex:atRow:)]) {
            imageName = [self.delegate imageURLForCellAtIndex:self.row atRow:indexPath.row];
        }
        
        if ([self.delegate respondsToSelector:@selector(contentNameForCellAtIndex:atRow:)]) {
            cell.contentLabel.text = [self.delegate contentNameForCellAtIndex:self.row atRow:indexPath.row];
            cell.contentLabel.numberOfLines = 2;
            cell.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            //        cell.contentLabel.numberOfLines = 0;
            //        cell.contentLabel.frame = CGRectMake(cell.contentLabel.frame.origin.x,
            //                                             cell.contentLabel.frame.origin.y,
            //                                             cell.contentLabel.frame.size.width,
            //                                             labelSize.height);
            //        NSLog(@"cell contentLabel text is %@",cell.contentLabel.text);
        }
        
        switch (self.row) {
            case 0:
                cell.coverImageView.image = [UIImage imageNamed:@"green_gloom.png"];
                break;
            case 1:
                cell.coverImageView.image = [UIImage imageNamed:@"blue_gloom.png"];
                break;
            case 2:
                cell.coverImageView.image = [UIImage imageNamed:@"purple_gloom.png"];
                break;
            default:
                break;
        }
        
        //    CGRect cellRect = cell.contentImageView.frame;
        //    cell.contentImageView.frame = CGRectMake(cellRect.origin.x, cellRect.origin.y, 170.0, 170.0);
        
        cell.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentImageView loadImageFromURL:imageName completion:^(BOOL succeeded) {
            [cell.contentImageView fadeIn];
            cell.contentImageView.layer.masksToBounds = YES;
        }];
        
        //    NSLog(@"%f %f",cell.contentImageView.frame.size.width,cell.contentImageView.frame.size.height);
        //    NSLog(@"%f %f",cell.contentImageView.image.size.width,cell.contentImageView.image.size.width);
        //    NSLog(@"%d",cell.contentImageView.contentMode);
        
        //    cell.contentImageView.layer.cornerRadius = 5;
        //    cell.contentImageView.layer.masksToBounds = YES;
    }
    [cell setNeedsDisplay];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 157;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(didSelectCellAtIndex:ofRow:)]) {
        [self.delegate didSelectCellAtIndex:indexPath.row ofRow:self.row];
    }
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
