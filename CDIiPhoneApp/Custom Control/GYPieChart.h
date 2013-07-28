//
//  GYPieChart.h
//  GYPieChart
//
//  Created by Gabriel Yeah on 13-3-20.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@class GYPieChart;

@protocol GYPieChartDelegate <NSObject>

@optional
- (BOOL)GYPieChart:(GYPieChart *)pieChart
    didChangeStartPercentage:(CGFloat)startPercentage
               endPercentage:(CGFloat)endPercentage;
- (NSString *)stringForPercentage:(CGFloat)percentage;
- (CGFloat)decentPercentageForRawPercentage:(CGFloat)rawPercentage;

- (void)GYPieChart:(GYPieChart *)pieChart
    didStartDraggingWithFrom:(BOOL)isDraggingFrom;
- (void)GYPieChartdidEndDragging:(GYPieChart *)pieChart;

@end

@interface GYPieChart : XYPieChart

@property (nonatomic, strong) UIImageView *startPuller;
@property (nonatomic, strong) UIImageView *endPuller;
@property (nonatomic, strong) UILabel     *startLabel;
@property (nonatomic, strong) UILabel     *endLabel;
@property (nonatomic, assign) CGFloat     startPullerAngle;
@property (nonatomic, assign) CGFloat     endPullerAngle;
@property (nonatomic, assign) CGFloat     minPieAngle;
@property (nonatomic, assign) CGFloat     maxPieAngle;
@property (nonatomic, weak) id<GYPieChartDelegate> delegateForGY;


- (void)setStartPullerImage:(UIImage *)startPullerImage
             endPullerImage:(UIImage *)endPullerImage;
- (void)setStartPullerInitialAngle:(CGFloat)percentage;

@end
