//
//  DeviceInfoHistoryCell.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-31.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "DeviceInfoHistoryCell.h"

@interface DeviceInfoHistoryCell ()

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarBGImageView;

@end

@implementation DeviceInfoHistoryCell

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
  self.statusLabel.hidden = isPlaceHolder;
  self.userAvatarImageView.hidden = isPlaceHolder;
  self.userAvatarBGImageView.hidden = isPlaceHolder;
  self.borrowDurationLabel.hidden = isPlaceHolder;
  self.userNameLabel.hidden = isPlaceHolder;
  self.placeHolderLabel.hidden = !isPlaceHolder;
  _isPlaceHolder = isPlaceHolder;
}

@end
