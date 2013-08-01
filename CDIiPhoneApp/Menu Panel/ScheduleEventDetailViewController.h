//
//  ScheduleEventDetailViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-8-2.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CoreDataViewController.h"

@class CDIEvent;

@interface ScheduleEventDetailViewController : CoreDataViewController

@property (nonatomic, weak) CDIEvent *event;

@end
