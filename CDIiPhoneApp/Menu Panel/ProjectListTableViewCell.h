//
//  ProjectListTableViewCell.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-29.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectStatusLabel;

@property (nonatomic, readwrite) BOOL isPlaceHolder;

@end
