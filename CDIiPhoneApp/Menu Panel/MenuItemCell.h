//
//  MenuItemCell.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-19.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *functionButton;
@property (weak, nonatomic) IBOutlet UIButton *displayButton;

@end
