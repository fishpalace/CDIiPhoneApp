//
//  DeviceInfoViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-31.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CoreDataViewController.h"

@class CDIDevice;

@interface DeviceInfoViewController : CoreDataViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) CDIDevice *currentDevice;

- (void)loadData;

@end
