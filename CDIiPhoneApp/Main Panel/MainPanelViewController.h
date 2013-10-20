//
//  ViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-3.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPCellTableViewController.h"
#import "MPDragIndicatorView.h"
@class MenuPanelViewController;

@interface MainPanelViewController : CoreDataViewController <UITableViewDelegate, UITableViewDataSource,
    MPCellTableViewControllerDelegate, MPDragIndicatorViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) MenuPanelViewController *menuPanelViewController;

@property (assign, nonatomic) BOOL isMainPanel;

@end
