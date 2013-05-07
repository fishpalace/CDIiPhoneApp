//
//  MPDragIndicatorView.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-7.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "MPDragIndicatorView.h"
#import "UIView+Resize.h"
#import <QuartzCore/QuartzCore.h>
#import "GYPositionBounceAnimation.h"

#define kUpperBarOriginY  20
#define kMiddleBarOriginY 26
#define kLowerBarOriginY  32

@interface MPDragIndicatorView ()

@property (weak, nonatomic) IBOutlet UIImageView *upperBarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *middleBarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lowerBarImageView;
@property (weak, nonatomic) UITableView *tableView;
@property (assign, nonatomic) BOOL animationPlayed;

@end

@implementation MPDragIndicatorView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)configureTableView:(UITableView *)tableView
{
  self.tableView = tableView;
  [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
  [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"contentOffset"] && !self.animationPlayed) {
    CGFloat offsetY = self.tableView.contentOffset.y;
    offsetY = offsetY < 0 ? offsetY : 0;

    if (offsetY > -100) {
      [self.upperBarImageView resetOriginY:kUpperBarOriginY + offsetY];
      [self.middleBarImageView resetOriginY:kMiddleBarOriginY + offsetY * 2 / 3];
      [self.lowerBarImageView resetOriginY:kLowerBarOriginY + offsetY / 3];
    } else {
      [self view:self.upperBarImageView playAnimationToValue:kUpperBarOriginY];
      [self view:self.middleBarImageView playAnimationToValue:kMiddleBarOriginY];
      [self view:self.lowerBarImageView playAnimationToValue:kLowerBarOriginY];
    }
  }
}

- (void)view:(UIView *)view playAnimationToValue:(CGFloat)value;
{
  self.animationPlayed = YES;
  GYPositionBounceAnimation *animation = [GYPositionBounceAnimation animationWithKeyPath:@"position.y"];
  animation.duration = 0.7;
  animation.numberOfBounces = 4;
  [animation setValueArrayForStartValue:view.frame.origin.y endValue:value];
  [view.layer setValue:[NSNumber numberWithFloat:value] forKeyPath:animation.keyPath];
  [view.layer addAnimation:animation forKey:@"bounce"];
}

@end
