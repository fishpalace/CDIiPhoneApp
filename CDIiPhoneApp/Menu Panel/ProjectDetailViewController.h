//
//  ProjectDetailViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-29.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CoreDataViewController.h"

@class CDIWork;

@interface ProjectDetailViewController : CoreDataViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, weak) CDIWork *work;

@end
