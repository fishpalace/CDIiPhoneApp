//
//  TimeDisplayPanelViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-2.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeDisplayPanelViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger roomID;
@property (nonatomic, strong) NSString *roomTitle;

@end
