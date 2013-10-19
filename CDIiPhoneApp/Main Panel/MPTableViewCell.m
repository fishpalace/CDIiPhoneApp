//
//  MPTableViewCell.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-4.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "MPTableViewCell.h"
#import "UIStoryboard+Addition.h"
#import "UIView+Resize.h"

@implementation MPTableViewCell

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

#pragma mark - Property
- (MPCellTableViewController *)contentTableViewController
{
  if (!_contentTableViewController) {
    _contentTableViewController = [UIStoryboard instantiateViewControllerWithIdentifier:@"MPCellTableViewController"];
    [_contentTableViewController.view resetOrigin:CGPointZero];
    [_contentTableViewController.view resetSize:CGSizeMake(157, 320)];
    _contentTableViewController.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self addSubview:_contentTableViewController.view];
  }
  return _contentTableViewController;
}

@end
