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
#import "ModelPanelViewController.h"
#import "TimeDisplayPanelViewController.h"

#define kContentSize  CGSizeMake(320, 569)
#define kBottomGap    5

@interface MenuPanelViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *containerScrollview;
@property (nonatomic, strong) MPDragIndicatorView *dragIndicatorView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *checkScheduleButton;
@property (weak, nonatomic) IBOutlet UIButton *checkReservationButton;
@property (weak, nonatomic) IBOutlet UIButton *checkNewsButton;
@property (weak, nonatomic) IBOutlet UIButton *checkProjectButton;
@property (weak, nonatomic) IBOutlet UIButton *checkPeopleButton;
@property (weak, nonatomic) IBOutlet UIButton *checkRoomA;
@property (weak, nonatomic) IBOutlet UIButton *checkRoomB;
@property (weak, nonatomic) IBOutlet UIButton *checkRoomC;
@property (weak, nonatomic) IBOutlet UIButton *checkRoomD;
@property (weak, nonatomic) IBOutlet UIImageView *roomStatusAImageView;
@property (weak, nonatomic) IBOutlet UIImageView *roomStatusBImageView;
@property (weak, nonatomic) IBOutlet UIImageView *roomStatusCImageView;
@property (weak, nonatomic) IBOutlet UIImageView *roomStatusDImageView;


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
  [self.dragIndicatorView configureScrollView:self.containerScrollview];
  self.dragIndicatorView.stretchLimitHeight = 100;
  self.dragIndicatorView.delegate = self;
}

- (void)setUp
{
  self.avatarImageView.layer.borderColor = [UIColor blackColor].CGColor;
  self.avatarImageView.layer.borderWidth = 1;
}

- (void)refresh
{
  [self.containerScrollview setContentOffset:CGPointZero];
}

- (void)viewDidLayoutSubviews
{
  [self.dragIndicatorView resetOriginY:kContentSize.height - kDragIndicatorViewHeight - kBottomGap];
  [self.dragIndicatorView resetHeight:kDragIndicatorViewHeight];
  [self.dragIndicatorView resetWidth:320];
  [self.containerScrollview setContentSize:kContentSize];
  [self.containerScrollview setContentOffset:CGPointMake(0, 88) animated:NO];
}

- (void)dragIndicatorViewDidStrecth:(MPDragIndicatorView *)view
{
  [NSNotificationCenter postShouldBounceUpNotification];
}

#pragma mark - IBActions
- (IBAction)didClickCheckRoomButton:(UIButton *)sender
{
  [self displayModelPanelWithRoomID:1];
}

- (void)displayModelPanelWithRoomID:(NSInteger)roomID
{
  TimeDisplayPanelViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeDisplayPanelViewController"];
  [ModelPanelViewController displayModelPanelWithViewController:vc];
}

#pragma mark - Properties
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
