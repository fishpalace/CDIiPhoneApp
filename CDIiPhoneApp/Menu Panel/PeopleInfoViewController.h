//
//  PeopleInfoViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-4.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CDIUser;

@interface PeopleInfoViewController : CoreDataViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) CDIUser *user;
@property (nonatomic, assign) NSInteger index; //For Mock Data

@end
