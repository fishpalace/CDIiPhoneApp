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
#import "UIApplication+Addition.h"

#define kBarBaseOffset    8
#define kUpperBarOriginY  kBarBaseOffset
#define kMiddleBarOriginY kBarBaseOffset + 6
#define kLowerBarOriginY  kBarBaseOffset + 12
#define kArrowOriginY     kBarBaseOffset + 18

@interface MPDragIndicatorView ()

@property (weak, nonatomic) IBOutlet UIImageView *upperBarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *middleBarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lowerBarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (weak, nonatomic) UIScrollView *scrollView;
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

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    
  }
  return self;
}

- (void)configureScrollView:(UIScrollView *)scrollView
{
  self.scrollView = scrollView;
  self.readyForStretch = YES;
  [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
  [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"contentOffset"] && self.readyForStretch) {
    [self handleDragEvent];
  }
}

- (void)handleDragEvent
{
  CGFloat offsetY = self.scrollView.contentOffset.y;
  BOOL didStrech = NO;
  if (!self.isReversed) {
    offsetY = offsetY < 0 ? offsetY : 0;
    didStrech = offsetY <= -self.stretchLimitHeight;
    if (!didStrech) {
      [self.upperBarImageView resetOriginY:kUpperBarOriginY + offsetY * 11 / 13];
      [self.middleBarImageView resetOriginY:kMiddleBarOriginY + offsetY * 10 / 13];
      [self.lowerBarImageView resetOriginY:kLowerBarOriginY + offsetY * 9 / 13];
      [self.arrowImageView resetOriginY:kArrowOriginY + offsetY * 8 / 13];
    }
  } else {
    CGFloat baseOffset = self.scrollView.contentSize.height - kCurrentScreenHeight;
    offsetY -= baseOffset;
    didStrech = offsetY >= self.stretchLimitHeight;
    if (offsetY < self.stretchLimitHeight && offsetY > 0) {
      [self.upperBarImageView resetOriginY:kUpperBarOriginY + offsetY * 8 / 13];
      [self.middleBarImageView resetOriginY:kMiddleBarOriginY + offsetY * 9 / 13];
      [self.lowerBarImageView resetOriginY:kLowerBarOriginY + offsetY * 10 / 13];
      [self.arrowImageView resetOriginY:kArrowOriginY + offsetY * 11 / 13];
    }
  }
  
  if (didStrech) {
    if ([self.delegate respondsToSelector:@selector(dragIndicatorViewDidStrecth:)]) {
      [self.delegate dragIndicatorViewDidStrecth:self];
      self.readyForStretch = NO;
      [self resetPositions];
      [self performSelector:@selector(refreshStatus) withObject:nil afterDelay:0.7];
    }
  }
}

- (void)setIsReversed:(BOOL)isReversed
{
  _isReversed = isReversed;
  UIImage *topImage = nil;
  UIImage *bottomImage = nil;
  if (isReversed) {
    topImage = [UIImage imageNamed:@"mp_menu_arrow_reverse"];
    bottomImage = [UIImage imageNamed:@"mp_menu_bar"];
  } else {
    topImage = [UIImage imageNamed:@"mp_menu_bar"];
    bottomImage = [UIImage imageNamed:@"mp_menu_arrow"];
  }
  
  self.upperBarImageView.image = topImage;
  self.middleBarImageView.image = [UIImage imageNamed:@"mp_menu_bar"];
  self.lowerBarImageView.image = [UIImage imageNamed:@"mp_menu_bar"];
  self.arrowImageView.image = bottomImage;
  
  [self resetPositions];
}

- (void)resetPositions
{
  [self.upperBarImageView resetOriginY:kUpperBarOriginY];
  [self.middleBarImageView resetOriginY:kMiddleBarOriginY];
  [self.lowerBarImageView resetOriginY:kLowerBarOriginY];
  [self.arrowImageView resetOriginY:kArrowOriginY];
}

- (void)refreshStatus
{
  self.readyForStretch = YES;
}

@end
