//
//  TPScheduleListViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-21.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleListTableViewController.h"

#define kTPScheduleListViewSize CGSizeMake(320, 330)

@protocol TPScheduleListViewControllerDelegate <NSObject>

- (void)didClickPanelButton;

@end

@interface TPScheduleListViewController : CoreDataViewController <ScheduleListTableViewDelegate>

@property (nonatomic, readwrite) NSInteger roomID;

@property (nonatomic, weak) id<TPScheduleListViewControllerDelegate> delegate;

+ (CGSize)sizeAccordingToDevice;

@end
