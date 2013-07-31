//
//  DeviceListAllDeviceCell.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-30.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "DeviceListAllDeviceCell.h"

@interface DeviceListAllDeviceCell ()

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@end

@implementation DeviceListAllDeviceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsPlaceHolder:(BOOL)isPlaceHolder
{
  
  self.deviceNameLabel.hidden = isPlaceHolder;
  self.deviceTypeLabel.hidden = isPlaceHolder;
  self.deviceStatusImageView.hidden = isPlaceHolder;
  self.placeHolderLabel.hidden = !isPlaceHolder;
  _isPlaceHolder = isPlaceHolder;
}

@end
