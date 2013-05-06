//
//  UIView+Addition.h
//  WeTongji
//
//  Created by 紫川 王 on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@interface UIView (Addition)

- (void)fadeIn;

- (void)fadeOut;

- (void)flashIn;

- (void)flashOut;

- (void)fadeInWithCompletion:(void (^)(void))completion;

- (void)fadeOutWithCompletion:(void (^)(void))completion;

- (void)transitionFadeIn;

- (void)transitionFadeOut;

- (void)fadeInWithDuration:(float)duration;

- (void)fadeOutWithDuration:(float)duration;

- (void)fadeInWithDuration:(float)duration
                completion:(void (^)(void))completion;

- (void)fadeOutWithDuration:(float)duration
                 completion:(void (^)(void))completion;

- (void)removeAllSubviews;

@end
