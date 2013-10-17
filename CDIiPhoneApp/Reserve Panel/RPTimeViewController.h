//
//  RPTimeViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-24.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYPieChart.h"
#import "RPActivityIndictor.h"

@interface RPTimeViewController : CoreDataViewController <GYPieChartDelegate, XYPieChartDataSource,RPActivityIndictorDelegate>

@property (nonatomic, readwrite) NSInteger roomID;

@end
