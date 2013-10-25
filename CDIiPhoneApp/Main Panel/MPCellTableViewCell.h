//
//  MPCellTableViewCell.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-4.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel * contentLabel;
@property (weak, nonatomic) IBOutlet UILabel * seeAllLabel;
@property (nonatomic) BOOL isSeeAllCell;
@property (nonatomic) BOOL isCDIEventsCell;
@property (nonatomic) BOOL isCDIProjectsCell;

@end
