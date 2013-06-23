//
//  LoginViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-23.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "LoginViewController.h"
#import "UIView+Addition.h"
#import "UIImage+StackBlur.h"
#import "UIImage+ScreenShoot.h"
#import "CDINetClient.h"
#import "CDIUser.h"

#define kTextfieldShowConstraint 70
#define kTextfieldHiddenConstraint -254

static LoginViewController *sharedLoginViewController;

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textfieldTopMarginConstraint;

@end

@implementation LoginViewController

+ (LoginViewController *)sharedLoginViewController
{
  if (!sharedLoginViewController) {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:NULL];
    sharedLoginViewController = [storyBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [sharedLoginViewController.view flashOut];
    [UIApplication insertViewUnderCover:sharedLoginViewController.view];
  }
  return sharedLoginViewController;
}

+ (void)displayLoginPanel
{
  [[LoginViewController sharedLoginViewController] displayLoginPanel];
}

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
  _userNameTextfield.delegate = self;
  _passwordTextfield.delegate = self;
  
  _textfieldTopMarginConstraint.constant = kTextfieldHiddenConstraint;

}

- (void)displayLoginPanel
{
  void (^completion)(UIImage *bgImage) = ^(UIImage *bgImage) {
    self.bgImageView.image = bgImage;
    [self.bgImageView fadeIn];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
      
    } completion:nil];
  };
  
  [self configureBGImageWithCompletion:completion];
  self.textfieldTopMarginConstraint.constant = kTextfieldShowConstraint;
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  }];
  
  [self.view flashIn];
  [self.userNameTextfield becomeFirstResponder];
  for (UIView *view in self.view.subviews) {
    if (![view isEqual:self.bgImageView]) {
      [view fadeIn];
    }
  }
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

- (IBAction)didClickCloseButton:(UIButton *)sender
{
  [self hide];
}

- (void)hide
{
//  self.textfieldTopMarginConstraint.constant = 0;
  [self.userNameTextfield resignFirstResponder];
  [self.passwordTextfield resignFirstResponder];
  
  self.textfieldTopMarginConstraint.constant = kTextfieldHiddenConstraint;
  
  [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    [self.view layoutIfNeeded];
  } completion:nil];
  
  [self.view fadeOutWithDuration:0.5 completion:^{
    self.bgImageView.image = nil;
    self.userNameTextfield.text = @"";
    self.passwordTextfield.text = @"";
  }];
}

- (void)login
{
  CDINetClient *client = [CDINetClient client];
  void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
    if (succeeded) {
      if ([responseData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = responseData[@"data"];
        CDIUser *user = [CDIUser insertUserInfoWithDict:dict
                                 inManagedObjectContext:self.managedObjectContext];
        [CDIUser updateCurrentUserID:user.userID];
        [self.managedObjectContext processPendingChanges];
        [self hide];
      }
    } else {
      //TODO Report Error
    }
  };
  
  [client loginWithUserName:self.userNameTextfield.text
                   passWord:self.passwordTextfield.text
                 completion:handleData];
}

#pragma mark - UIText Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  BOOL result = NO;
  if ([textField isEqual:self.userNameTextfield]) {
    if (self.userNameTextfield.text.length > 0) {
      result = YES;
      [self.passwordTextfield becomeFirstResponder];
    }
  } else if ([textField isEqual:self.passwordTextfield]) {
    if (self.passwordTextfield.text.length > 0) {
      if (self.userNameTextfield.text.length > 0) {
        [self login];
        result = YES;
      } else {
        [self.userNameTextfield becomeFirstResponder];
      }
    }
  }
  return result;
}

@end
