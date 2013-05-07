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
	
	CGFloat alpha = 0;
	if (startValue == endValue) {
		alpha = log2f(0.1f)/steps;
	} else {
		alpha = log2f(0.1f/fabsf(endValue - startValue))/steps;
	}
	if (alpha > 0) {
		alpha = -1.0f * alpha;
	}
	CGFloat numberOfPeriods = self.numberOfBounces / 2 + 0.5;
	CGFloat omega = numberOfPeriods * 2 * M_PI / steps;
	
	NSMutableArray *values = [NSMutableArray arrayWithCapacity:steps];
	CGFloat value = 0;
  
	CGFloat oscillationComponent;
	CGFloat coefficient;
	
	// conforms to y = A * e^(-alpha*t)*cos(omega*t)
	for (NSInteger t = 0; t < steps; t++) {
    if (self.shake) {
			oscillationComponent =  sin(omega*t);
		} else {
			oscillationComponent =  cos(omega*t);
		}
		coefficient =  (startValue - endValue);
		value = coefficient * pow(2.71, alpha*t) * oscillationComponent + endValue;
		[values addObject:[NSNumber numberWithFloat:value]];
	}
  
  self.values = values;
//  self.timingFunction = @"kCAMediaTimingFunctionLinear";
}

- (BOOL)shake
{
	return [[super valueForKey:@"shakeKey"] boolValue];
}

- (BOOL)shouldOvershoot
{
	return [[super valueForKey:@"shouldOvershootKey"] boolValue];
}

- (void)setShouldOvershoot:(BOOL)newShouldOvershoot
{
	[super setValue:[NSNumber numberWithBool:newShouldOvershoot] forKey:@"shouldOvershootKey"];
}

@end
