//
//  MPTableViewCell.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-4.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPCellTableViewController.h"

@interface MPTableViewCell : UITableViewCell

@property (nonatomic, strong) MPCellTableViewController *contentTableViewController;

@end
