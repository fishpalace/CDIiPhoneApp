//
//  UIView+Addition.m
//  WeTongji
//
//  Created by 紫川 王 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

- (void)fadeIn
{
  [self fadeInWithDuration:0.3f];
}

- (void)fadeOut
{
  [self fadeOutWithDuration:0.3f];
}

- (void)flashIn
{
  [self fadeInWithDuration:0.0f];
}

- (void)flashOut
{
  [self fadeOutWithDuration:0.0f];
}

- (void)fadeInWithCompletion:(void (^)(void))completion
{
  [self fadeInWithDuration:0.3f completion:completion];
}

- (void)fadeOutWithCompletion:(void (^)(void))completion
{
  [self fadeOutWithDuration:0.3f completion:completion];
}

- (void)transitionFadeIn
{
  self.alpha = 0;
  [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    self.alpha = 1;
  } completion:nil];
}

- (void)transitionFadeOut
{
  self.alpha = 1;
  [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    self.alpha = 0;
  } completion:nil];
}

- (void)fadeInWithDuration:(float)duration
{
  [self fadeInWithDuration:duration completion:nil];
}

- (void)fadeOutWithDuration:(float)duration
{
  [self fadeOutWithDuration:duration completion:nil];
}

- (void)fadeInWithDuration:(float)duration completion:(void (^)(void))completion
{
  self.alpha = 0;
  [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    self.alpha = 1;
  } completion:^(BOOL finished) {
    if(completion)
      completion();
  }];
}

- (void)fadeOutWithDuration:(float)duration completion:(void (^)(void))completion
{
  self.alpha = 1;
  [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    self.alpha = 0;
  } completion:^(BOOL finished) {
    if(completion)
      completion();
  }];
}

- (void)removeAllSubviews
{
  for (UIView *view in self.subviews) {
    [view removeFromSuperview];
  }
}

- (void)blinkForRepeatCount:(NSInteger)count duration:(CGFloat)duration
{
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  [animation setFromValue:[NSNumber numberWithFloat:0.0]];
  [animation setToValue:[NSNumber numberWithFloat:1.0]];
  [animation setDuration:duration];
  [animation setTimingFunction:[CAMediaTimingFunction
                                functionWithName:kCAMediaTimingFunctionLinear]];
  [animation setAutoreverses:YES];
  [animation setRepeatCount:count];
  [self.layer addAnimation:animation forKey:@"opacity"];
}


@end
