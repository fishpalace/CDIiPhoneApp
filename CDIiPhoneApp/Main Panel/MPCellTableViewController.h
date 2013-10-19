//
//  MPCellTableViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-4.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPCellTableViewControllerDelegate <NSObject>

- (void)cellForRow:(NSInteger)row didMoveByOffset:(CGFloat)offset;
- (void)registerCurrentActiveRow:(NSInteger)row;
- (BOOL)isActiveForRow:(NSInteger)row;
- (NSString *)imageURLForCellAtIndex:(NSInteger)index atRow:(NSInteger)row;
- (NSString *)contentNameForCellAtIndex:(NSInteger)index atRow:(NSInteger)row;
- (NSInteger)numberOfRowsAtRow:(NSInteger)row;

- (void)didSelectCellAtIndex:(NSInteger)index ofRow:(NSInteger)row;

@end

@interface MPCellTableViewController : UITableViewController <UIScrollViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, weak) id<MPCellTableViewControllerDelegate> delegate;

- (void)setUpWithRow:(NSInteger)row
            delegate:(id<MPCellTableViewControllerDelegate>)delegate;

- (void)moveByOffset:(CGFloat)offset;

@end
