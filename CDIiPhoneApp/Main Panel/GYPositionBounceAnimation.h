//
//  GYPositionBounceAnimation.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-7.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface GYPositionBounceAnimation : CAKeyframeAnimation

- (void)setValueArrayForStartValue:(CGFloat)startValue endValue:(CGFloat)endValue;

@end
