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
#import "NSNotificationCenter+Addition.h"
#import "NSString+Dictionary.h"

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
//        [sharedLoginViewController.view flashOut];
        [UIApplication insertViewUnderCover:sharedLoginViewController.view];
        [sharedLoginViewController hideWithCallBack:nil andDuration:0.0];
    }
    return sharedLoginViewController;
}

+ (void)displayLoginPanelWithCallBack:(LoginPanelCallback)callBack
{
    [[LoginViewController sharedLoginViewController] displayLoginPanelWithCallBack:callBack];
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
    _userNameTextfield.text = @"";
    _passwordTextfield.text = @"";
    _userNameTextfield.delegate = self;
    _passwordTextfield.delegate = self;
    
    _userNameTextfield.keyboardAppearance = UIKeyboardAppearanceDark;
    _passwordTextfield.keyboardAppearance = UIKeyboardAppearanceDark;
    _passwordTextfield.returnKeyType = UIReturnKeyDone;
    
    _textfieldTopMarginConstraint.constant = kTextfieldHiddenConstraint;
    
    UIView * bgGloomView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [bgGloomView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
    [self.view insertSubview:bgGloomView aboveSubview:_bgImageView];
    [UIView animateWithDuration:0.25 delay:0.0 options:7 << 16 animations:^{
        [bgGloomView setAlpha:1.0];
    }completion:nil];
    
}

- (void)displayLoginPanelWithCallBack:(LoginPanelCallback)callBack
{
    self.callBack = callBack;
    
    void (^completion)(UIImage *bgImage) = ^(UIImage *bgImage) {
        self.bgImageView.image = bgImage;
        [self.bgImageView fadeIn];
        [UIView animateWithDuration:0.25 delay:0 options:7 << 16 animations:^{
            
        } completion:nil];
    };
    
    [self configureBGImageWithCompletion:completion];
    self.textfieldTopMarginConstraint.constant = kTextfieldShowConstraint;
    [UIView animateWithDuration:0.25 delay:0 options:7 << 16 animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    
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
//        UIImage *resultImage = [[UIImage screenShoot] stackBlur:10];
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completion) {
//                completion(resultImage);
//            }
        });
    });
}

-(IBAction)beginPasswordInput:(id)sender
{
    [_passwordTextfield becomeFirstResponder];
}

- (IBAction)didClickCloseButton:(UIButton *)sender
{
    [self hideWithCallBack:nil andDuration:0.25];
}

- (void)hideWithCallBack:(LoginPanelCallback)callBack andDuration:(float) duration
{
    //  self.textfieldTopMarginConstraint.constant = 0;
    [self.userNameTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
    
    self.textfieldTopMarginConstraint.constant = kTextfieldHiddenConstraint;
    
    [UIView animateWithDuration:duration delay:0 options:7 << 16 animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    
    [self.view fadeOutWithDuration:duration completion:^{
        self.bgImageView.image = nil;
        self.userNameTextfield.text = @"";
        self.passwordTextfield.text = @"";
        
        if (callBack) {
            callBack();
        }
    }];
}

- (void)login
{
    CDINetClient *client = [CDINetClient client];
    void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
        self.view.userInteractionEnabled = YES;
        self.view.superview.userInteractionEnabled = YES;
        RPActivityIndictor * activityIndictor = [RPActivityIndictor sharedRPActivityIndictor];
        [activityIndictor stopWaitingTimer];
        
        if (succeeded) {
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = responseData[@"data"];
                CDIUser *user = [CDIUser insertUserInfoWithDict:dict
                                         inManagedObjectContext:self.managedObjectContext];
                user.sessionKey = [NSString stringForDict:responseData key:@"sessionKey"];
                user.password = self.passwordTextfield.text;
                [CDIUser updateCurrentUserID:user.userID];
                [self.managedObjectContext processPendingChanges];
                [self hideWithCallBack:self.callBack andDuration:0.25];
                
                [NSNotificationCenter postDidChangeCurrentUserNotification];
            }
        } else {
            //TODO Report Error
            [self loginFailed];
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
                self.view.userInteractionEnabled = NO;
                self.view.superview.userInteractionEnabled = NO;
                RPActivityIndictor * activityIndictor = [RPActivityIndictor sharedRPActivityIndictor];
                activityIndictor.delegate = self;
                [activityIndictor resetBasicData];
                [activityIndictor startWaitingAnimationInView:self.view];
                [activityIndictor setWaitingTimer];
                [self performSelector:@selector(login) withObject:nil afterDelay:1.0];
                result = YES;
            } else {
                [self.userNameTextfield becomeFirstResponder];
            }
        }
    }
    return result;
}

- (void)loginFailed
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"Login Failed", @"InfoPlist", nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alertView show];
    self.view.userInteractionEnabled = YES;
    self.view.superview.userInteractionEnabled = YES;
}

#pragma mark - RPActivityView Delegate
- (void)someThingAfterActivityIndicatorOverTimer
{
    [self loginFailed];
}

@end
