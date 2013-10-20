//
//  ModelPassGestureViewController.m
//  CDIiPhoneApp
//
//  Created by Emerson on 13-10-20.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "ModelPassGestureViewController.h"
#import "UIView+Addition.h"
#import "UIView+Resize.h"
#import "AppDelegate.h"

static ModelPassGestureViewController *sharedPassGestureViewController;

@interface ModelPassGestureViewController ()

@property (strong, nonatomic) UIView * bgGloomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passGestureImageBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passGestureButtonBottomSpaceConstraint;
@property (strong, nonatomic) UIViewController *contentViewController;
@property (weak, nonatomic) IBOutlet UIImageView * passGestureView;

@end

@implementation ModelPassGestureViewController

+ (ModelPassGestureViewController *)sharedPassGestureViewController
{
    if (!sharedPassGestureViewController) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:NULL];
        sharedPassGestureViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ModelPassGestureViewController"];
    }
    return sharedPassGestureViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (void)displayModelPanelWithViewController:(UIViewController *)vc
{
    [[ModelPassGestureViewController sharedPassGestureViewController]displayModelPanelWithViewController:vc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.passGestureView.translatesAutoresizingMaskIntoConstraints = NO;
//    _passGestureImageBottomSpaceConstraint.constant = - [UIScreen mainScreen].bounds.size.height - 369;
    
//    [self.view setFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width / 2,- [UIScreen mainScreen].bounds.size.height / 2,
//                                   [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    [self.view setFrame:CGRectMake(0.0,0.0,
//                                       [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
}

- (void)displayModelPanelWithViewController:(UIViewController *)vc
{
    [self.view setFrame:CGRectMake(0.0,0.0,
                                   [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view setBackgroundColor:[UIColor clearColor]];
    if (!_bgGloomView) {
        _bgGloomView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    [_bgGloomView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
    [self.view insertSubview:_bgGloomView belowSubview:_passGestureView];
    [_bgGloomView setAlpha:0.0];
    
//    [vc.view addSubview:self.view];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:self.view];
    
    if (kIsiPhone5) {
        _passGestureImageBottomSpaceConstraint.constant = 100;
        _passGestureButtonBottomSpaceConstraint.constant = 105;
    }
    else {
        _passGestureImageBottomSpaceConstraint.constant = 56;
        _passGestureButtonBottomSpaceConstraint.constant = 61;
    }
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
        [_bgGloomView setAlpha:1.0];
    }completion:nil];
}


- (IBAction)removePassGestureView:(id)sender
{
    _passGestureImageBottomSpaceConstraint.constant = -369;
    _passGestureButtonBottomSpaceConstraint.constant = -369;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view layoutIfNeeded];
        [_bgGloomView setAlpha:0.0];
    }completion:^(BOOL finished){
        [self.view removeFromSuperview];
    }];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
