//
//  GYPositionBounceAnimation.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-7.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "GYPositionBounceAnimation.h"

@implementation GYPositionBounceAnimation

- (void)setValueArrayForStartValue:(CGFloat)startValue endValue:(CGFloat)endValue
{
	NSInteger steps = 60 * self.duration; //60 fps desired

  CGFloat alpha = -0.09;                //弹性幅度，越大幅度越大
  CGFloat omega = 0.15;                 //恢复速率，越大速度越快
  
  NSMutableArray *values = [NSMutableArray arrayWithCapacity:steps];
	CGFloat value = 0;
  
	// y = A * e^(-alpha*t)*cos(omega*t)
	for (NSInteger t = 0; t < steps; t++) {
		CGFloat coefficient =  (startValue - endValue);
    value = coefficient * pow(2.71, alpha * t) * cos(omega * t) + endValue;
		[values addObject:[NSNumber numberWithFloat:value]];
	}
  
  self.values = values;
}

@end
