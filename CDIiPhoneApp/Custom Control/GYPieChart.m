//
//  GYPieChart.m
//  GYPieChart
//
//  Created by Gabriel Yeah on 13-3-20.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "GYPieChart.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Resize.h"

#define kPullerDefaultFrame       CGRectMake(0.0, 0.0, 44.0, 100.0)
#define kLabelDefaultFrame        CGRectMake(-16.0, -80.0, 80.0, 76.0)
#define kPeriodAvailableColor [[UIColor colorWithRed:0.0/255.0 green:150.0/255.0 blue:218.0/255.0 alpha:0.5] CGColor]
#define kPeriodErrorColor [[UIColor colorWithRed:234.0/255.0 green:82.0/255.0 blue:81.0/255.0 alpha:0.5] CGColor]
#define kStartLableColor  [UIColor colorWithRed:12.0/255.0 green:194.0/255.0 blue:203.0/255.0 alpha:1.0]
#define kEndLableColor    [UIColor colorWithRed:234.0/255.0 green:82.0/255.0 blue:81.0/255.0 alpha:1.0]

@interface GYPieChart ()

@property (nonatomic, strong) UIPanGestureRecognizer *startPullerGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *endPullerGestureRecoginzer;
@property (nonatomic, strong) SliceLayer *selectionLayer;
@property (nonatomic, assign) BOOL observerAlreadyAdded;
@property (nonatomic, assign) BOOL selectionAvailable;

@end

@implementation GYPieChart

static CGPathRef CGPathCreateArc(CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle)
{
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathMoveToPoint(path, NULL, center.x, center.y);
  
  CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle - M_PI / 2, endAngle - M_PI / 2, 0);
  CGPathCloseSubpath(path);
  
  return path;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    _minPieAngle = M_PI / 12;
    _maxPieAngle = M_PI / 2;
    _selectionLayer = [self createSliceLayer];
    [_selectionLayer setStartAngle:0.0];
    [_selectionLayer setEndAngle:M_PI / 12];
    [_selectionLayer setFillColor:kPeriodAvailableColor];
    [_selectionLayer setValue:10];
    [_selectionLayer setPercentage:0.3];
    [_selectionLayer setIsForPresentation:YES];
    
    [self.layer addSublayer:_selectionLayer];
    self.showPercentage = NO;
    self.showLabel = NO;
    
    [self configurePanGestureRecognizers];
    [self configurePullers];
//    [self configureLabels];
  }
  return self;
}

- (void)configurePanGestureRecognizers
{
  _startPullerGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handlePanGesture:)];
  _endPullerGestureRecoginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(handlePanGesture:)];
  _startPullerGestureRecognizer.maximumNumberOfTouches = 1;
  _startPullerGestureRecognizer.minimumNumberOfTouches = 1;
  _endPullerGestureRecoginzer.maximumNumberOfTouches = 1;
  _endPullerGestureRecoginzer.minimumNumberOfTouches = 1;
}

- (void)configurePullers
{
  _startPuller = [[UIImageView alloc] initWithFrame:kPullerDefaultFrame];
  _endPuller = [[UIImageView alloc] initWithFrame:kPullerDefaultFrame];
  
  [_startPuller addGestureRecognizer:_startPullerGestureRecognizer];
  [_endPuller addGestureRecognizer:_endPullerGestureRecoginzer];
  
  [self configurePullerBasic:_startPuller];
  [self configurePullerBasic:_endPuller];
}

- (void)configureLabels
{
  UIFont *font = [UIFont fontWithName:@"Melbourne" size:24.0];
  _startLabel = [[UILabel alloc] initWithFrame:kLabelDefaultFrame];
  [_startLabel setFont:font];
  [_startLabel setTextColor:kStartLableColor];
  [_startLabel setBackgroundColor:[UIColor clearColor]];
  [_startLabel setTextAlignment:NSTextAlignmentCenter];
  [_startLabel.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
  
  _endLabel = [[UILabel alloc] initWithFrame:kLabelDefaultFrame];
  [_endLabel setFont:font];
  [_endLabel setTextColor:kEndLableColor];
  [_endLabel setBackgroundColor:[UIColor clearColor]];
  [_endLabel setTextAlignment:NSTextAlignmentCenter];
  [_endLabel.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    
  [self.startPuller addSubview:_startLabel];
  [self.endPuller addSubview:_endLabel];
  
}

- (void)configurePullerBasic:(UIImageView *)puller
{
  [puller setContentMode:UIViewContentModeTop];
  [puller setUserInteractionEnabled:YES];
  [puller setExclusiveTouch:YES];
  [puller setMultipleTouchEnabled:NO];
  [self addSubview:puller];
}

- (void)configurePuller:(UIImageView *)imageView withImage:(UIImage *)image
{
  [imageView setImage:image];
  [imageView resetSize:image.size];
}

- (void)setStartPullerImage:(UIImage *)startPullerImage
             endPullerImage:(UIImage *)endPullerImage
{
  [self configurePuller:self.startPuller withImage:startPullerImage];
  [self configurePuller:self.endPuller withImage:endPullerImage];
  [self.startPuller.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
  [self.endPuller.layer setAnchorPoint:CGPointMake(0.5, 1.0)];
  [self.startPuller.layer setPosition:self.pieCenter];
  [self.endPuller.layer setPosition:self.pieCenter];
  [self.endPuller setTransform:CGAffineTransformMakeRotation(self.minPieAngle)];
}

- (void)setStartPullerInitialAngle:(CGFloat)percentage
{
  CGFloat initialAngle = M_PI * 2 * percentage;
  self.startPullerAngle = initialAngle;
  self.endPullerAngle = initialAngle + self.minPieAngle;
}

- (void)reloadData
{
  [super reloadData];

  [self bringSubviewToFront:self.startPuller];
  [self bringSubviewToFront:self.endPuller];
  
  [self updateSelectionLayerWithStartAngle:self.startPullerAngle endAngle:self.endPullerAngle];
  [self handlePanGesture:nil];
}

- (float)angleBetweenCenterAndPoint:(CGPoint)point
{
  CGFloat angle = atan2(point.x - self.pieCenter.x, self.pieCenter.y - point.y);
	return angle < 0 ? angle + M_PI * 2 : angle;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
  CGFloat angle = [self angleBetweenCenterAndPoint:[sender locationInView:self]];
  
  BOOL isDraggingFrom = [sender.view isEqual:self.startPuller];
  if (isDraggingFrom) {
    [self didRotateStartPullerToAngle:angle];
  } else if ([sender.view isEqual:self.endPuller]) {
    [self didRotateEndPullerToAngle:angle];
  }
  
  if (sender.state == UIGestureRecognizerStateBegan) {
    if ([self.delegateForGY respondsToSelector:@selector(GYPieChart:didStartDraggingWithFrom:)]) {
      [self.delegateForGY GYPieChart:self didStartDraggingWithFrom:isDraggingFrom];
    }
  } else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
    if ([self.delegateForGY respondsToSelector:@selector(GYPieChartdidEndDragging:)]) {
      [self.delegateForGY GYPieChartdidEndDragging:self];
    }
  }
  
  CGFloat startPercentage = self.startPullerAngle / (M_PI * 2);
  CGFloat endPercentage = self.endPullerAngle / (M_PI * 2);
  
  if ([self.delegateForGY respondsToSelector:@selector(GYPieChart:didChangeStartPercentage:endPercentage:)]) {
    self.selectionAvailable = [self.delegateForGY GYPieChart:self
                                    didChangeStartPercentage:startPercentage
                                               endPercentage:endPercentage];
  }
  
  [self updateLabelsWithStartPercentage:startPercentage endPercentage:endPercentage];
  [self updatePullersWithStartPercentage:startPercentage endPercentage:endPercentage gestureState:sender.state];

}

- (void)updateLabelsWithStartPercentage:(CGFloat)startPercentage
                          endPercentage:(CGFloat)endPercentage
{
  if ([self.delegateForGY respondsToSelector:@selector(stringForPercentage:)]) {
    if (self.selectionAvailable) {
      NSString *startString = [self.delegateForGY stringForPercentage:startPercentage];
      NSString *endString = [self.delegateForGY stringForPercentage:endPercentage];
      [self.startLabel setText:startString];
      [self.endLabel setText:endString];
    } else {
      [self.startLabel setText:@""];
      [self.endLabel setText:@"不可用"];
    }
  }
}

- (void)updatePullersWithStartPercentage:(CGFloat)startPercentage
                           endPercentage:(CGFloat)endPercentage
                            gestureState:(UIGestureRecognizerState)state
{
  if (state == UIGestureRecognizerStateEnded) {
    if ([self.delegateForGY respondsToSelector:@selector(decentPercentageForRawPercentage:)]) {
      CGFloat decentStartPercentage = [self.delegateForGY decentPercentageForRawPercentage:startPercentage];
      CGFloat decentEndPercentage = [self.delegateForGY decentPercentageForRawPercentage:endPercentage];
      self.startPullerAngle = M_PI * 2 * decentStartPercentage;
      self.endPullerAngle = M_PI * 2 * decentEndPercentage;
      [UIView animateWithDuration:0.3 animations:^{
        [self updatePullerPosition];
      } completion:^(BOOL finished) {
        [self updateSelectionLayer];
        [self.selectionLayer removeAllAnimations];
      }];
      [self playSelectionAnimation];
    }
  } else {
    [self updatePullerPosition];
    [self updateSelectionLayer];
  }
}

- (void)updatePullerPosition
{
  [self.startPuller setTransform:CGAffineTransformMakeRotation(self.startPullerAngle)];
  [self.endPuller setTransform:CGAffineTransformMakeRotation(self.endPullerAngle)];
  
  [self.startLabel setTransform:CGAffineTransformMakeRotation(-self.startPullerAngle)];
  [self.endLabel setTransform:CGAffineTransformMakeRotation(-self.endPullerAngle)];
}

- (void)playSelectionAnimation
{
  CGPathRef targetPath = CGPathCreateArc(self.pieCenter, self.pieRadius, self.startPullerAngle, self.endPullerAngle);
  CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
  animation.duration = 0.3;
  animation.values = [NSArray arrayWithObjects:(id)self.selectionLayer.path, targetPath, nil];
  animation.fillMode = kCAFillModeForwards;
  animation.removedOnCompletion = NO;
  [self.selectionLayer addAnimation:animation forKey:nil];
  CFRelease(targetPath);
}

- (void)updateSelectionLayer
{
  [self updateSelectionLayerWithStartAngle:self.startPullerAngle endAngle:self.endPullerAngle];
  if (self.selectionAvailable) {
    [self.selectionLayer setFillColor:kPeriodAvailableColor];
  } else {
    [self.selectionLayer setFillColor:kPeriodErrorColor];
  }
}

- (void)updateSelectionLayerWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
  CGPathRef path = CGPathCreateArc(self.pieCenter, self.pieRadius, startAngle, endAngle);
  [self.selectionLayer setPath:path];
  CFRelease(path);
}

- (void)didRotateStartPullerToAngle:(CGFloat)angle
{
  CGFloat delta = angle - self.startPullerAngle;
  
  if (delta < -M_PI_4) {
    if (self.startPullerAngle > M_PI * 3 / 4) {
      self.startPullerAngle = M_PI * 2 - self.minPieAngle;
      self.endPullerAngle = M_PI * 2 - 0.001;
    }
    return;
  } else if (delta > M_PI_4) {
    if (self.startPullerAngle < M_PI_4) {
      self.startPullerAngle = 0.0;
      if (self.endPullerAngle - self.startPullerAngle > self.maxPieAngle) {
        self.endPullerAngle = self.maxPieAngle;
      }
    }
    return;
  }
  
  if (angle > M_PI * 2 - self.minPieAngle) {
    self.startPullerAngle = self.startPullerAngle > M_PI ? M_PI * 2 - self.minPieAngle : 0.0;
    self.endPullerAngle = self.startPullerAngle > M_PI ? M_PI * 2 - 0.001 : self.endPullerAngle;
    return;
  }
  
  if (self.endPullerAngle - angle > self.minPieAngle) {
    if (self.endPullerAngle - angle > self.maxPieAngle) {
      self.endPullerAngle += delta;
    }
    self.startPullerAngle = angle;
  } else {
    if (self.endPullerAngle + delta > self.minPieAngle) {
      self.startPullerAngle = angle;
      self.endPullerAngle += delta;
    } else {
      self.startPullerAngle = M_PI * 2 - self.minPieAngle;
      self.endPullerAngle = M_PI * 2 - 0.001;
    }
  }
}

- (void)didRotateEndPullerToAngle:(CGFloat)angle
{
  CGFloat delta = angle - self.endPullerAngle;
  
  if (delta < -M_PI_4) {
    if (self.endPullerAngle > M_PI * 3 / 4) {
      self.endPullerAngle = M_PI * 2 - 0.001;
      if (self.endPullerAngle - self.startPullerAngle > self.maxPieAngle) {
        self.startPullerAngle = M_PI * 2 - self.maxPieAngle;
      }
    }
    return;
  } else if (delta > M_PI_4) {
    if (self.endPullerAngle > M_PI_4 * 3) {
      self.startPullerAngle = M_PI * 2 - self.minPieAngle;
      self.endPullerAngle = M_PI * 2 - 0.001;
    }
    return;
  }
  
  if (angle < self.minPieAngle) {
    self.endPullerAngle = self.endPullerAngle > M_PI ? M_PI * 2 - 0.001 : self.minPieAngle;
    self.startPullerAngle = self.endPullerAngle > M_PI ? self.startPullerAngle : 0.0;
    return;
  }
  
  if (angle - self.startPullerAngle > self.minPieAngle) {
    if (angle - self.startPullerAngle > self.maxPieAngle) {
      self.startPullerAngle += delta;
    }
    self.endPullerAngle = angle;
  } else {
    if (self.startPullerAngle + delta < M_PI * 2 - self.minPieAngle) {
      self.endPullerAngle = angle;
      self.startPullerAngle += delta;
    } else {
      self.startPullerAngle = 0.0;
      self.endPullerAngle = self.minPieAngle;
    }
  }
}

- (void)setPieCenter:(CGPoint)pieCenter
{
  [super setPieCenter:pieCenter];
  
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  
}

@end
