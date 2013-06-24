//
//  ModelPanelViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-2.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "ModelPanelViewController.h"
#import "UIView+Addition.h"
#import "UIView+Resize.h"
#import "AppDelegate.h"
#import "UIImage+StackBlur.h"
#import "UIImage+ScreenShoot.h"
#import "UIApplication+Addition.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

#define kCloseButtonGap 30
#define kContentViewGap     47
#define kContentViewControllerFrame CGRectMake(0, 0, 320, 450)

static ModelPanelViewController *sharedModelPanelViewController;

@interface ModelPanelViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageVIew;
@property (weak, nonatomic) IBOutlet UIImageView *modelBGImageView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *functionButton;
@property (strong, nonatomic) UIViewController *contentViewController;
@property (weak, nonatomic) IBOutlet UIView *panelView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *panelViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;


@end

@implementation ModelPanelViewController

+ (ModelPanelViewController *)sharedModelPanelViewController
{
  if (!sharedModelPanelViewController) {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:NULL];
    sharedModelPanelViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ModelPanelViewController"];
    [sharedModelPanelViewController.view flashOut];
    [UIApplication insertViewUnderCover:sharedModelPanelViewController.view];
  }
  return sharedModelPanelViewController;
}

+ (void)displayModelPanelWithViewController:(UIViewController *)vc
                              withTitleName:(NSString *)titleName
                         functionButtonName:(NSString *)functionButtonName
                                   imageURL:(NSString *)imageURL
                                       type:(ModelPanelType)type
                                   callBack:(MondelPanelFunctionCallback)callback
{
  [[ModelPanelViewController sharedModelPanelViewController] displayModelPanelWithViewController:vc
                                                                                   withTitleName:titleName
                                                                              functionButtonName:functionButtonName
                                                                                        imageURL:imageURL
                                                                                            type:type
                                                                                        callBack:callback];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _titleImageView.layer.cornerRadius = 19;
  _titleImageView.layer.masksToBounds = YES;
}

- (void)updateViewConstraints
{
  [super updateViewConstraints];
  self.containerViewHeightConstraint.constant = kIsiPhone5 ? 450 : 400;
  self.panelViewHeightConstraint.constant = kIsiPhone5 ? 530 : 480;
}

- (void)displayModelPanelWithViewController:(UIViewController *)vc
                              withTitleName:(NSString *)titleName
                         functionButtonName:(NSString *)functionButtonName
                                   imageURL:(NSString *)imageURL
                                       type:(ModelPanelType)type
                                   callBack:(MondelPanelFunctionCallback)callback
{
  self.contentViewController = vc;
  self.bottomSpaceConstraint.constant = -self.panelView.frame.size.height;
  void (^completion)(UIImage *bgImage) = ^(UIImage *bgImage) {
    self.modelBGImageView.image = bgImage;
    [self addChildViewController:self.contentViewController];
    [self.contentViewController.view setFrame:kContentViewControllerFrame];
    [self.containerView addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
    [self.view fadeIn];
    self.bottomSpaceConstraint.constant = 0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
      [self.panelView layoutIfNeeded];
    } completion:nil];
  };
  [self configureBGImageWithCompletion:completion];
  
  self.titleName = titleName;
  self.functionButtonName = functionButtonName;
  self.imageURL = imageURL;
  self.panelType = type;
  _callback = nil;
  self.callback = callback;
  [self updateTitleSection];
}

- (void)updateTitleSection
{
  [self.titleImageView setImageWithURL:[NSURL URLWithString:self.imageURL]];
  
  NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:self.titleName];
  if (self.panelType == ModelPanelTypeRoomInfo) {
    [titleAttributedString addAttribute:NSFontAttributeName
                                  value:[UIFont boldSystemFontOfSize:14]
                                  range:NSMakeRange(0, 1)];
    
    [titleAttributedString addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:14]
                                  range:NSMakeRange(1, titleAttributedString.length - 1)];
  }
  NSShadow *shadow = [[NSShadow alloc] init];
  [shadow setShadowColor:kCModelTitleShadow];
  [shadow setShadowOffset:CGSizeMake(0, 1)];
  [titleAttributedString addAttribute:NSShadowAttributeName
                                value:shadow
                                range:NSMakeRange(0, titleAttributedString.length)];
  
  [titleAttributedString addAttribute:NSForegroundColorAttributeName
                                value:kCModelTitle
                                range:NSMakeRange(0, titleAttributedString.length)];
 
  
  self.titleLabel.attributedText = titleAttributedString;
  
  NSString *buttonBGNamge = @"";
  if (self.panelType == ModelPanelTypeRoomInfo) {
    buttonBGNamge = @"model_button_schedule";
  } else if (self.panelType == ModelPanelTypePeopleInfo) {
    buttonBGNamge = @"model_button_write";
  }
  UIImage *functionButtonBGImage = [UIImage imageNamed:buttonBGNamge];
  [self.functionButton setTitle:self.functionButtonName forState:UIControlStateNormal];
  [self.functionButton setBackgroundImage:functionButtonBGImage forState:UIControlStateNormal];
  [self.functionButton setTitleShadowColor:kCModelTitleShadow forState:UIControlStateNormal];
  [self.functionButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
}

- (void)configureBGImageWithCompletion:(void (^)(UIImage *bgImage))completion
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIImage *resultImage = [[UIImage screenShoot] stackBlur:10];
    dispatch_async(dispatch_get_main_queue(), ^{
      if (completion) {
        completion(resultImage);
      }
    });
  });
}

#pragma mark - IBActions
- (IBAction)didClickCloseButton:(UIButton *)sender
{
  [self hideWithCompletion:nil];
}

- (IBAction)didClickFunctionButton:(UIButton *)sender
{
  [self hideWithCompletion:self.callback];
}


- (void)removeContentViewController
{
  [self.contentViewController willMoveToParentViewController:nil];  // 1
  [self.contentViewController.view removeFromSuperview];            // 2
  [self.contentViewController removeFromParentViewController];      // 3
  self.contentViewController = nil;
}

#pragma mark - View Hierarchy Methods
- (void)hideWithCompletion:(MondelPanelFunctionCallback)completion
{
  self.bottomSpaceConstraint.constant = -self.panelView.frame.size.height;
  [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    [self.panelView layoutIfNeeded];
  } completion:^(BOOL finished) {
    [self removeContentViewController];
    if (completion) {
      completion();
    }
  }];
  
  [self.view fadeOutWithDuration:0.5 completion:^{
    self.modelBGImageView.image = nil;
  }];
}

@end
