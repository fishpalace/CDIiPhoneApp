//
//  RPRoomViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-24.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPRoomViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readwrite) NSInteger selectedRoomID;

@end
