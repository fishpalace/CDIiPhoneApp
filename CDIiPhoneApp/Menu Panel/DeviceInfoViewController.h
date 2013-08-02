//
//  DeviceInfoViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-31.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CoreDataViewController.h"

@class CDIDevice;
@class DeviceListViewController;

@interface DeviceInfoViewController : CoreDataViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) CDIDevice *currentDevice;
@property (nonatomic, weak) DeviceListViewController *previousController;
@property (nonatomic, strong) NSMutableArray *appliedDeviceStrings;

- (void)updateViewContent;

@end
