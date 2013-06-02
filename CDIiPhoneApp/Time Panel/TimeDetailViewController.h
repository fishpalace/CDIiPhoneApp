//
//  TimeDetailViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-2.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYPieChart.h"

@interface TimeDetailViewController : UIViewController <XYPieChartDataSource>

- (void)configureWithDate:(BOOL)isToday;

@end
