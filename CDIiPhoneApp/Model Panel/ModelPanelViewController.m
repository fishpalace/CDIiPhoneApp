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

@property (weak, nonatomic) IBOutlet UIImageView *modelBGImageView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *functionButton;
@property (strong, nonatomic) UIViewController *contentViewController;

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
{
  [[ModelPanelViewController sharedModelPanelViewController] displayModelPanelWithViewController:vc
                                                                                   withTitleName:titleName
                                                                              functionButtonName:functionButtonName
                                                                                        imageURL:imageURL
                                                                                            type:type];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  _titleImageView.layer.cornerRadius = 19;
  _titleImageView.layer.masksToBounds = YES;
}

- (void)displayModelPanelWithViewController:(UIViewController *)vc
                              withTitleName:(NSString *)titleName
                         functionButtonName:(NSString *)functionButtonName
                                   imageURL:(NSString *)imageURL
                                       type:(ModelPanelType)type
{
  self.contentViewController = vc;
  void (^completion)(UIImage *bgImage) = ^(UIImage *bgImage) {
    self.modelBGImageView.image = bgImage;
    [self addChildViewController:self.contentViewController];
    [self.contentViewController.view setFrame:kContentViewControllerFrame];
    [self.containerView addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
    [self.view fadeIn];
  };
  [self configureBGImageWithCompletion:completion];
  
  self.titleName = titleName;
  self.functionButtonName = functionButtonName;
  self.imageURL = imageURL;
  self.panelType = type;
  [self updateTitleSection];
}

- (void)updateTitleSection
{
  NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:self.titleName];
  if (self.panelType == ModelPanelTypeRoomInfo) {
    [titleAttributedString addAttribute:NSFontAttributeName
                                  value:[UIFont boldSystemFontOfSize:14]
                                  range:NSMakeRange(0, 1)];
    
    [titleAttributedString addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:14]
                                  range:NSMakeRange(1, titleAttributedString.length - 1)];
  }
  self.titleLabel.attributedText = titleAttributedString;
  
  NSString *buttonBGNamge = @"";
  if (self.panelType == ModelPanelTypeRoomInfo) {
    buttonBGNamge = @"model_button_schedule";
  } else if (self.panelType == ModelPanelTypePeopleInfo) {
    buttonBGNamge = @"model_button_write";
  }
  UIImage *functionButtonBGImage = [UIImage imageNamed:buttonBGNamge];
  [self.functionButton setBackgroundImage:functionButtonBGImage forState:UIControlStateNormal];
  [self.functionButton setBackgroundImage:functionButtonBGImage forState:UIControlStateHighlighted];
  [self.functionButton setTitle:self.functionButtonName forState:UIControlStateNormal];
  [self.functionButton setTitle:self.functionButtonName forState:UIControlStateHighlighted];
  self.titleLabel.text = self.titleName;
  [self.titleImageView setImageWithURL:[NSURL URLWithString:self.imageURL]];
}

- (void)configureBGImageWithCompletion:(void (^)(UIImage *bgImage))completion
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIImage *resultImage = [[UIImage screenShoot] stackBlur:6];
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
  [self hide];
  [self.contentViewController willMoveToParentViewController:nil];  // 1
  [self.contentViewController.view removeFromSuperview];            // 2
  [self.contentViewController removeFromParentViewController];      // 3
  self.contentViewController = nil;
}

#pragma mark - View Hierarchy Methods
- (void)hide
{
  [self.view fadeOutWithCompletion:^{
    self.modelBGImageView.image = nil;
    //TODO Release the content View Controllers
  }];
}

@end
