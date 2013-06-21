//
//  PeopleInfoWorkListCell.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-21.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "PeopleInfoWorkListCell.h"

@implementation PeopleInfoWorkListCell

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
  self.noItemIndicatorLabel.hidden = !isPlaceHolder;
  self.workNameLabel.hidden = isPlaceHolder;
  self.workTypeLabel.hidden = isPlaceHolder;
  self.workPicImageView.hidden = isPlaceHolder;
  self.workPicCoverImageView.hidden = isPlaceHolder;
  _isPlaceHolder = isPlaceHolder;
}

@end
