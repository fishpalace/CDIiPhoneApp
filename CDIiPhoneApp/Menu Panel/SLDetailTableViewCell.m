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

- (void)setCalendarButtonSelected:(BOOL)selected
{
  _calendarButtonSelected = selected;
  [self performSelectorOnMainThread:@selector(updateCalendarButton) withObject:nil waitUntilDone:NO];
}

- (void)updateCalendarButton
{
  NSString *imageName = self.calendarButtonSelected ? @"tableview_icon_calendar_hl" : @"tableview_icon_calendar";
  [self.calendarButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
  [self.calendarButton setNeedsDisplay];
}

@end
