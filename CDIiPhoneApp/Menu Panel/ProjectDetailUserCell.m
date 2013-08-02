//
//  ProjectDetailUserCell.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-8-2.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "ProjectDetailUserCell.h"

@implementation ProjectDetailUserCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.transform = CGAffineTransformMakeRotation(M_PI_2);
  }
  return self;
}

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

@end
