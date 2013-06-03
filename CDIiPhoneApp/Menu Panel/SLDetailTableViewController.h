//
//  SLDetailTableViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-3.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLDetailTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL isToday;

- (void)configureSubviews;

@end
