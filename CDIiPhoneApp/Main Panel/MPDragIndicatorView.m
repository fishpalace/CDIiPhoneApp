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

#define kBarBaseOffset    8
#define kUpperBarOriginY  kBarBaseOffset
#define kMiddleBarOriginY kBarBaseOffset + 6
#define kLowerBarOriginY  kBarBaseOffset + 12

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
  self.readyForStretch = YES;
  [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
  [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"contentOffset"] && self.readyForStretch) {
    CGFloat offsetY = self.tableView.contentOffset.y;
    offsetY = offsetY < 0 ? offsetY : 0;

    if (offsetY > -self.stretchLimitHeight) {
      [self.upperBarImageView resetOriginY:kUpperBarOriginY + offsetY * 3 / 4];
      [self.middleBarImageView resetOriginY:kMiddleBarOriginY + offsetY / 2];
      [self.lowerBarImageView resetOriginY:kLowerBarOriginY + offsetY / 4];
    } else {
      if ([self.delegate respondsToSelector:@selector(dragIndicatorViewDidStrecth:)]) {
        [self.delegate dragIndicatorViewDidStrecth:self];
        self.readyForStretch = NO;
      }
      [self view:self.upperBarImageView playAnimationToValue:kUpperBarOriginY];
      [self view:self.middleBarImageView playAnimationToValue:kMiddleBarOriginY];
      [self view:self.lowerBarImageView playAnimationToValue:kLowerBarOriginY];
    }
  }
}

- (void)view:(UIView *)view playAnimationToValue:(CGFloat)value;
{
  GYPositionBounceAnimation *animation = [GYPositionBounceAnimation animationWithKeyPath:@"position.y"];
  animation.duration = 0.7;
  animation.numberOfBounces = 4;
  [animation setValueArrayForStartValue:view.frame.origin.y endValue:value];
  [view.layer setValue:[NSNumber numberWithFloat:value] forKeyPath:animation.keyPath];
  [view.layer addAnimation:animation forKey:@"bounce"];
}

@end
