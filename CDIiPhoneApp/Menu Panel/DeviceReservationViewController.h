//
//  DeviceReservationViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-31.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CoreDataViewController.h"

@class CDIDevice;
@class DeviceInfoViewController;

@interface DeviceReservationViewController : CoreDataViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) CDIDevice *currentDevice;
@property (nonatomic, weak) DeviceInfoViewController *prevDeviceInfoViewController;

@end
