//
//  PeopleInfoWorkListCell.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-21.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleInfoWorkListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noItemIndicatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *workNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *workTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *workPicImageView;
@property (weak, nonatomic) IBOutlet UIImageView *workPicCoverImageView;
@property (nonatomic, readwrite) BOOL isPlaceHolder;

@end
