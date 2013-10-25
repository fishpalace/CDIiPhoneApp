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

#define refreshLabel_X_Point 263.0
#define kBarBaseOffset    15
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
      _menuButton.hidden = YES;
      _refreshButton.hidden = YES;
  }
  return self;
}

- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    return [string sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]].width;
}

- (CGFloat)heightOfString:(NSString *)string withFont:(UIFont *)font {
    return [string sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]].height;
}

- (void)addMenuAndRefresheLabel
{
    NSString * menuString = NSLocalizedStringFromTable(@"Menu", @"InfoPlist", nil);
    [_menuLabel setBackgroundColor:[UIColor colorWithRed:234.0 / 255.0 green:234.0 / 255.0 blue:234.0 / 255.0 alpha:1.0]];
    [_menuLabel setText:menuString];
    
    NSString * refreshLabelString = NSLocalizedStringFromTable(@"Refresh", @"InfoPlist", nil);
    [_refreshLabel setBackgroundColor:[UIColor colorWithRed:234.0 / 255.0 green:234.0 / 255.0 blue:234.0 / 255.0 alpha:1.0]];
    [_refreshLabel setText:refreshLabelString];
//    [_refreshLabel setBackgroundColor:[UIColor redColor]];
//    CGRect refreshLabelFrame = _refreshLabel.frame;
//    [_refreshLabel setFrame:CGRectMake(refreshLabelFrame.origin.x
//                                       , refreshLabelFrame.origin.y
//                                       , [self widthOfString:_refreshLabel.text withFont:_refreshLabel.font]
//                                       , [self heightOfString:_refreshLabel.text withFont:_refreshLabel.font])];
}

- (void)showMenuAndRefreshButton
{
    _menuButton.hidden = NO;
    _refreshButton.hidden = NO;
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
    CGFloat baseOffset = self.scrollView.contentSize.height - self.scrollView.frame.size.height + 5;
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

-(void)drawLineOnTableCellView
{
    
    UIGraphicsBeginImageContext(CGSizeMake(1.0, 34.0));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0] CGColor]);
    CGContextMoveToPoint(context, 1.0, 0.0);
    CGContextAddLineToPoint(context, 1.0, 34.0);
    CGContextStrokePath(context);
    UIImage * newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView * nnView = [[UIImageView alloc]initWithImage:newPic];
    [nnView setFrame:CGRectMake(240.0, 8.0, 1.0, 34.0)];
    [self addSubview:nnView];
}

- (IBAction)didClickMenuButton:(id)sender {
    [self.delegate excuteAfterClickDragIndicatorMenuButton];
}

- (IBAction)didClickReFreshButton:(id)sender {
    _refreshLabel.hidden = YES;
    
    _waitingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(refreshLabel_X_Point + 16.0 / 2 ,16.0,16.0,16.0)];
    _waitingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _waitingView.hidesWhenStopped = YES;
    [self addSubview:_waitingView];
    [_waitingView startAnimating];
    
    [self.delegate excuteAfterClickDragIndicatorRefreshButton];
}

@end
