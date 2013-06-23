//
//  SLDetailTableViewCell.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-3.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSLDetailTableViewCellStandardHeight  80
#define kSingleLineHeight                     21

@class SLDetailTableViewCell;

@protocol SLDetailTableViewCellDelegate <NSObject>

- (void)cellDidClickAddEventButton:(SLDetailTableViewCell *)cell;

@end

@interface SLDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *eventRelatedInfo;
@property (weak, nonatomic) IBOutlet UILabel *startingTime;
@property (weak, nonatomic) IBOutlet UILabel *noEventLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nowIndicatorLabel;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;

@property (nonatomic, readwrite) BOOL isPlaceHolder;
@property (nonatomic, weak) id<SLDetailTableViewCellDelegate> delegate;

@property (nonatomic, readwrite) BOOL calendarButtonSelected;

- (void)setCalendarButtonSelected:(BOOL)selected;

@end
