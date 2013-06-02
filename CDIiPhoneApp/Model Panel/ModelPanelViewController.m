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
#import <QuartzCore/QuartzCore.h>

#define kRelativeGapOfCloseButton 30

static ModelPanelViewController *sharedModelPanelViewController;

@interface ModelPanelViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *modelBGImageView;
@property (weak, nonatomic) IBOutlet UIImageView *contentBGImageView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

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
{
  [[ModelPanelViewController sharedModelPanelViewController] displayModelPanelWithViewController:vc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
  self.contentBGImageView.center = self.view.center;
  [self.closeButton resetOriginY:self.contentBGImageView.frame.origin.y + kRelativeGapOfCloseButton];
}

- (void)displayModelPanelWithViewController:(UIViewController *)vc
{
  void (^completion)(UIImage *bgImage) = ^(UIImage *bgImage) {
    self.modelBGImageView.image = bgImage;
    [self.view fadeIn];
  };
  
  [self configureBGImageWithCompletion:completion];
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
