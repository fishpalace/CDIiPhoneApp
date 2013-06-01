//
//  MenuPanelViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-7.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "MenuPanelViewController.h"
#import "UIView+Resize.h"
#import "MPDragIndicatorView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSNotificationCenter+Addition.h"

#define kContentSize  CGSizeMake(320, 568)
#define kBottomGap    5

@interface MenuPanelViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *containerScrollview;
@property (nonatomic, strong) MPDragIndicatorView *dragIndicatorView;

@end

@implementation MenuPanelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.containerScrollview addSubview:self.dragIndicatorView];
  self.dragIndicatorView.stretchLimitHeight = 120;
  self.dragIndicatorView.delegate = self;
  [self.dragIndicatorView configureScrollView:self.containerScrollview];
}

- (void)setUp
{
  //Set up
}

- (void)viewDidLayoutSubviews
{
  [self.dragIndicatorView resetOriginY:kContentSize.height - kDragIndicatorViewHeight - kBottomGap];
  [self.dragIndicatorView resetHeight:kDragIndicatorViewHeight];
  [self.dragIndicatorView resetWidth:320];
  [self.containerScrollview setContentSize:kContentSize];
}

- (void)dragIndicatorViewDidStrecth:(MPDragIndicatorView *)view
{
  [NSNotificationCenter postShouldBounceUpNotification];
}

- (MPDragIndicatorView *)dragIndicatorView
{
  if (!_dragIndicatorView) {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MPDragIndicatorView"
                                                  owner:self
                                                options:nil];
    _dragIndicatorView = [nibs objectAtIndex:0];
    _dragIndicatorView.isReversed = YES;
  }
  return _dragIndicatorView;
}

@end
