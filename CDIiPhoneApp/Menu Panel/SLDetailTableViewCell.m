//
//  SLDetailTableViewCell.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-3.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "SLDetailTableViewCell.h"

@implementation SLDetailTableViewCell

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
  self.eventName.hidden = isPlaceHolder;
  self.roomName.hidden = isPlaceHolder;
  self.eventRelatedInfo.hidden = isPlaceHolder;
  self.startingTime.hidden = isPlaceHolder;
  self.nowIndicatorLabel.hidden = YES;
  self.calendarButton.hidden = isPlaceHolder;
  self.noEventLabel.hidden = !isPlaceHolder;
  _isPlaceHolder = isPlaceHolder;
}

- (IBAction)didClickAddToCalendarButton:(UIButton *)sender
{
  if ([self.delegate respondsToSelector:@selector(cellDidClickAddEventButton:)]) {
    [self.delegate cellDidClickAddEventButton:self];
  }
}

@end
