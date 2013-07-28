//
//  ScheduleListTableViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-23.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLDetailTableViewCell.h"

@class ScheduleListTableViewController;
@class CDIEventDAO;

@protocol ScheduleListTableViewDelegate <NSObject>

@required
- (void)slTableViewController:(ScheduleListTableViewController *)vc configureRequest:(NSFetchRequest *)request;

@optional
- (void)didSelectEvent:(CDIEventDAO *)event;

@end

@interface ScheduleListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, SLDetailTableViewCellDelegate>

@property (nonatomic, weak) id<ScheduleListTableViewDelegate> delegate;

@end
