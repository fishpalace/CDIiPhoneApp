//
//  ResourceList.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-22.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#ifndef CDIiPhoneApp_ResourceList_h
#define CDIiPhoneApp_ResourceList_h

#define kUserDefaultsCurrentUserID @"kUserDefaultsCurrentUserID"

#define kRTintBlue [UIColor colorWithRed:0.0/255.0 green:150.0/255.0 blue:218.0/255.0 alpha:1.0]
#define kRFontWitSize(o) [UIFont systemFontOfSize:o]
#define kRBoldFontWithSize(o) [UIFont boldSystemFontOfSize:o]
#define kRLightFontWithSize(o) [UIFont fontWithName:@"Helvetica-Light" size:o]

#pragma mark - Main Panel
#define kColorCurrentUserNameLabel [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1.0]
#define kFontCurrentUserNameLabel kRLightFontWithSize(12)

#pragma mark - Menu Panel
#define kRRoomStatusFreeColor [UIColor colorWithRed:9.0/255.0 green:187.0/255.0 blue:68.0/255.0 alpha:1.0]
#define kRRoomStatusUnvailableColor [UIColor colorWithRed:234.0/255.0 green:82.0/255.0 blue:81.0/255.0 alpha:1.0]
#define kRRoomStatusAvailableColor [UIColor colorWithRed:243.0/255.0 green:151.0/255.0 blue:0.0/255.0 alpha:1.0]

#define kColorItemTitle [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0]
#define kFontItemTitle kRFontWitSize(17)

#pragma mark - Schedule List
#define kRSLTimeLabelColor [UIColor colorWithRed:0.0/255.0 green:150.0/255.0 blue:218.0/255.0 alpha:1.0]
#define kRSLDateLabelColor [UIColor colorWithRed:177.0/255.0 green:177.0/255.0 blue:177.0/255.0 alpha:1.0]
#define kRSLTimeLabelFont kRFontWitSize(14)
#define kRSLDateLabelFont kRFontWitSize(12)

#define kRSLCellTitleFont kRLightFontWithSize(17)
#define kRSLCellRelatedInfoFont kRFontWitSize(12)
#define kRSLCellRoomFont kRFontWitSize(12)
#define kRSLCellTimeFont kRFontWitSize(12)
#define kRSLCellTitleColor [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]
#define kRSLCellRoomColor [UIColor colorWithRed:177.0/255.0 green:177.0/255.0 blue:177.0/255.0 alpha:1.0]
#define kRSLCellTimeColor [UIColor colorWithRed:106.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0]
#define kRSLCellRelatedInfoColor kRTintBlue
#define kRSLCellDisabledColor [UIColor colorWithRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:1.0]

#pragma mark - Model Panel
#define kFModelTitle kRLightFontWithSize(14)
#define kCModelTitleShadow [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.2]
#define kCModelTitle [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]

#define kColorForNextEventTimeLabel [UIColor colorWithRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:1.0]
#define kFontForNextEventTimeLabel kRFontWitSize(12)

#define kColorTimePanelTitle [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define kColorTimePanelTitleShadow [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3]
#define kFontTimePanelTitlePercentage kRLightFontWithSize(20)
#define kFontTimePanelTitleEvent kRLightFontWithSize(12)

#define kFontTimePanelNextEventTitle kRFontWitSize(12)
#define kFontTimePanelNextEventTime  kRFontWitSize(12)
#define kColorTimePanelNextEventTitle kRTintBlue
#define kColorTimePanelNextEventTime  kRSLDateLabelColor

#pragma mark - People Info Panel
#define kFontPeopleInfoTitleLabel kRBoldFontWithSize(10)
#define kFontPeopleInfoPositionLabel kRFontWitSize(12)
#define kColorPeopleInfoTitleLabel [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
#define kColorPeopleInfoPositionLabel [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]

#define kColorPeopleInfoWorkNameLabel [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]
#define kColorPeopleInfoWorkTypeLabel kRTintBlue
#define kFontPeopleInfoWorkNameLabel  kRLightFontWithSize(17)
#define kFontPeopleInfoWorkTypeLabel  kRFontWitSize(12)

#define kColorPeopleInfoCellNameLabel [UIColor colorWithRed:106.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1.0]
#define kColorPeopleInfoCellTitleLabel kColorPeopleInfoCellNameLabel
#define kColorPeopleInfoCellPositionLabel kRTintBlue

#define kFontPeopleInfoCellNameLabel kRLightFontWithSize(14)
#define kFontPeopleInfoCellTitleLabel kRFontWitSize(10)
#define kFontPeopleInfoCellPositionLabel kRFontWitSize(10)

#pragma mark - Reserve Panel
#define kFontRPRoomNameLabel kRLightFontWithSize(17)
#define kColorRPRoomNameLabel [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0]
#define kFontRPEventCountLabel kRFontWitSize(12)
#define kColorRPEventCountLabel [UIColor colorWithRed:186.0/255.0 green:186.0/255.0 blue:186.0/255.0 alpha:1.0]

#define kFontRPTimeRoomNameLabel kRLightFontWithSize(17)
#define kColorRPTimeRoomNameLabel [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1.0]
#define kColorRPTimeRoomNameLabelShadow [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4]

#define kFontRPTimeSpanLabel kRFontWitSize(12)
#define kColorRPTimeSpanLabelBlue kRTintBlue
#define kColorRPTimeSpanLabelGray [UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0]

#define kFontRPTodayOrTomorrowLabel kRLightFontWithSize(17)
#define kColorRPTodayOrTomorrowLabel [UIColor whiteColor]
#define kColorRPTodayOrTomorrowLabelShadow [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3]

#define kFontRPDateLabel kRLightFontWithSize(10)
#define kColorRPDateLabel [UIColor colorWithRed:118.0/255.0 green:212.0/255.0 blue:255.0/255.0 alpha:1.0]
#define kColorRPDateLabelShadow [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3]

#define kFontRPEventNameLabel kRLightFontWithSize(20)
#define kColorRPEventNameLabel [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]

#define kFontRPEventRelatedinfoLabel kRLightFontWithSize(14)
#define kColorRPEventRelatedinfoLabel kRTintBlue

#define kFontRPInstructionLabel kRLightFontWithSize(12)

#define kFontRPEventAccessKeyLabel kRLightFontWithSize(36)
#define kColorRPGreen [UIColor colorWithRed:9.0/255.0 green:187.0/255.0 blue:68.0/255.0 alpha:1.0]
#define kColorRPGray [UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0]

#endif
