//
//  SLDetailTableViewCell.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-3.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *eventRelatedInfo;
@property (weak, nonatomic) IBOutlet UILabel *startingTime;
@property (weak, nonatomic) IBOutlet UILabel *noEventLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nowIndicatorLabel;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;

@property (nonatomic, readwrite) BOOL isPlaceHolder;

@end
