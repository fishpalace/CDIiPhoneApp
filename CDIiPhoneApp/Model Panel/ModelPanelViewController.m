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


@property (strong,nonatomic) UIView * bgGloomView;

@end

@implementation ModelPanelViewController
{
    float modelViewMovingFirstPosition;
    float modelViewMovingFinalPosition;
    NSInteger timesHasExcuted;
}

+ (ModelPanelViewController *)sharedModelPanelViewController
{
    if (!sharedModelPanelViewController) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:NULL];
        sharedModelPanelViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ModelPanelViewController"];
        //    [sharedModelPanelViewController.view flashOut];
        [UIApplication insertViewUnderCover:sharedModelPanelViewController.view];
        [sharedModelPanelViewController hideWithFirstTimeWithDuration:0.0];
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
    
    _bgGloomView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [_bgGloomView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
    [self.view insertSubview:_bgGloomView aboveSubview:_modelBGImageView];
    [_bgGloomView setAlpha:0.0];
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_bgGloomView setAlpha:1.0];
    }completion:nil];
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
    [_bgGloomView setAlpha:0.0];
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_bgGloomView setAlpha:1.0];
    }completion:nil];
    
    self.contentViewController = vc;
    
    self.bottomSpaceConstraint.constant = -self.panelView.frame.size.height;
    void (^completion)(UIImage *bgImage) = ^(UIImage *bgImage) {
        self.modelBGImageView.image = bgImage;
        [self.modelBGImageView fadeIn];
    };
    [self configureBGImageWithCompletion:completion];
    
    [self addChildViewController:self.contentViewController];
    [self.contentViewController.view setFrame:kContentViewControllerFrame];
    [self.containerView addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
    [self.view flashIn];
    
//    self.bottomSpaceConstraint.constant = 0;
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        [self.panelView layoutIfNeeded];
//    } completion:nil];
    
//    [UIView animateWithDuration:0.1 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.bottomSpaceConstraint.constant = self.bottomSpaceConstraint.constant - 20.0;
//        [self.panelView layoutIfNeeded];
//    } completion:nil];
    
    timesHasExcuted = 0;
    modelViewMovingFirstPosition = -self.panelView.frame.size.height;
    modelViewMovingFinalPosition = self.panelView.frame.size.height;
    [NSTimer scheduledTimerWithTimeInterval:0.006 target:self selector:@selector(displayModelViewTimer:) userInfo:nil repeats:YES];
    
    self.titleName = titleName;
    self.functionButtonName = functionButtonName;
    self.imageURL = imageURL;
    self.panelType = type;
    _callback = nil;
    self.callback = callback;
    [self updateTitleSection];
}

- (void)movingModelViewMaxDistance
{
    self.bottomSpaceConstraint.constant = [self getEaseOutPositionWithFirstPosition:modelViewMovingFirstPosition
                                                                      finalPosition:modelViewMovingFinalPosition
                                                                    timesHasExcuted:timesHasExcuted
                                                                     allExcutedTime:80];
//    NSLog(@"constant position is %f",self.bottomSpaceConstraint.constant);
    [UIView animateWithDuration:0.0 animations:^{
        [self.panelView layoutIfNeeded];
    }];
}

- (float)getEaseOutPositionWithFirstPosition:(float)firstPosition
                              finalPosition:(float)finalPosition
                            timesHasExcuted:(float)times
                             allExcutedTime:(float)allTimes
{
    times = times / allTimes - 1;
    return -finalPosition * (times * times * times * times - 1) + firstPosition;
}

- (void)displayModelViewTimer:(NSTimer *)timer
{
    ++ timesHasExcuted;
    [self movingModelViewMaxDistance];
    if (fabsf(self.bottomSpaceConstraint.constant - 0.0) < 0.1) {
        [timer invalidate];
        timesHasExcuted = 0;
    }
}

- (void)hideModelViewTimer:(NSTimer *)timer
{
    ++ timesHasExcuted;
    [self movingModelViewMaxDistance];
    if (fabsf(self.bottomSpaceConstraint.constant - modelViewMovingFinalPosition) < 0.1) {
        [self removeContentViewController];
        timesHasExcuted = 0;
        [timer invalidate];
    }
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
//        UIImage *resultImage = [[UIImage screenShoot] stackBlur:10];
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completion) {
//                completion(resultImage);
//            }
        });
    });
}

#pragma mark - IBActions
- (IBAction)didClickCloseButton:(UIButton *)sender
{
    [self hideWithCompletion:nil andDuration:0.4];
}

- (IBAction)didClickFunctionButton:(UIButton *)sender
{
    [self hideWithCompletion:self.callback andDuration:0.4];
}


- (void)removeContentViewController
{
    [self.contentViewController willMoveToParentViewController:nil];  // 1
    [self.contentViewController.view removeFromSuperview];            // 2
    [self.contentViewController removeFromParentViewController];      // 3
    self.contentViewController = nil;
}

#pragma mark - View Hierarchy Methods
- (void)hideWithCompletion:(MondelPanelFunctionCallback)completion andDuration:(float)duration
{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_bgGloomView setAlpha:0.0];
    }completion:nil];
    
//    self.bottomSpaceConstraint.constant = -self.panelView.frame.size.height;
    
    timesHasExcuted = 0;
    modelViewMovingFirstPosition = self.bottomSpaceConstraint.constant;
    modelViewMovingFinalPosition = -self.panelView.frame.size.height;
    [NSTimer scheduledTimerWithTimeInterval:0.006 target:self selector:@selector(hideModelViewTimer:) userInfo:nil repeats:YES];
    
//    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        [self.panelView layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        [self removeContentViewController];
//        if (completion) {
//            completion();
//        }
//    }];
    
    [self.modelBGImageView fadeOutWithCompletion:^{
        [self.view flashOut];
        self.modelBGImageView.image = nil;
    }];
}

- (void)hideWithFirstTimeWithDuration:(float)duration
{
    self.bottomSpaceConstraint.constant = -self.panelView.frame.size.height;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.panelView layoutIfNeeded];
    } completion:nil];
}

@end
