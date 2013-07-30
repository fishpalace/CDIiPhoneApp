//
//  ProjectListTableViewCell.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-29.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "ProjectListTableViewCell.h"

@interface ProjectListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;


@end

@implementation ProjectListTableViewCell

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
  self.imageView.hidden = isPlaceHolder;
  self.projectNameLabel.hidden = isPlaceHolder;
  self.projectTypeLabel.hidden = isPlaceHolder;
  self.projectStatusLabel.hidden = isPlaceHolder;
  self.placeHolderLabel.hidden = !isPlaceHolder;
  _isPlaceHolder = isPlaceHolder;
}

@end
