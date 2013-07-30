//
//  DeviceListAllDeviceCell.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-30.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceListAllDeviceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *deviceStatusImageView;

@end
