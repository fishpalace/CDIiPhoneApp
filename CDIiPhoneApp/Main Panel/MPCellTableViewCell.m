//
//  MPCellTableViewCell.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-4.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "MPCellTableViewCell.h"
#import "UIView+Resize.h"
#import <QuartzCore/QuartzCore.h>

@interface MPCellTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation MPCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.transform = CGAffineTransformMakeRotation(M_PI_2);
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    if (self.isSeeAllCell) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGRect colorRect = CGRectMake(0.0, 0.0, 157.0, 157.0);
        if (self.isCDIEventsCell) {
            CGContextSetRGBFillColor(context, 0.0/100.0, 255.0/255.0, 0.0/255.0, 1.0);
        }
        else if (self.isCDIProjectsCell) {
            CGContextSetRGBFillColor(context, 0.0/255.0, 175.0/255.0, 255.0/255.0, 1.0);
        }
        else {
            CGContextSetRGBFillColor(context, 192.0/255.0, 83.0/255.0, 255.0/255.0, 1.0);
        }
        CGContextFillRect(context, colorRect);
    }
}

@end
