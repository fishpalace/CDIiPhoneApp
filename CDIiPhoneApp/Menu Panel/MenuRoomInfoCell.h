//
//  MenuRoomInfoCell.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-19.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuRoomInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sectionNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *roomAButton;
@property (weak, nonatomic) IBOutlet UIButton *roomBButton;
@property (weak, nonatomic) IBOutlet UIButton *roomCButton;
@property (weak, nonatomic) IBOutlet UIButton *roomDButton;

@property (weak, nonatomic) IBOutlet UILabel *roomALabel;
@property (weak, nonatomic) IBOutlet UILabel *roomBLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomCLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomDLabel;

@end
