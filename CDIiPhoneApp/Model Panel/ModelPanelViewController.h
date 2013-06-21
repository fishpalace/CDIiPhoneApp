//
//  ModelPanelViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-2.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  ModelPanelTypePeopleInfo,
  ModelPanelTypeRoomInfo,
} ModelPanelType;

@interface ModelPanelViewController : UIViewController

@property (nonatomic, readwrite) NSString *titleName;
@property (nonatomic, readwrite) NSString *functionButtonName;
@property (nonatomic, readwrite) NSString *imageURL;
@property (nonatomic, readwrite) ModelPanelType panelType;

+ (void)displayModelPanelWithViewController:(UIViewController *)vc
                              withTitleName:(NSString *)titleName
                         functionButtonName:(NSString *)functionButtonName
                                   imageURL:(NSString *)imageURL
                                       type:(ModelPanelType)type;

@end
