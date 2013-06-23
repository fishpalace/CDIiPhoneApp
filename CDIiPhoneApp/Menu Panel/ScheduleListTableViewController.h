//
//  ScheduleListTableViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-23.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScheduleListTableViewController;

@protocol ScheduleListTableViewDelegate <NSObject>

@required
- (void)slTableViewController:(ScheduleListTableViewController *)vc configureRequest:(NSFetchRequest *)request;

@end

@interface ScheduleListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) id<ScheduleListTableViewDelegate> delegate;

@end
