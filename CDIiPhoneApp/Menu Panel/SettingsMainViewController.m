//
//  SettingsMainViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-8-26.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "SettingsMainViewController.h"
#import "CDINetClient.h"
#import "UIImage+ProportionalFill.h"
#import "UIImageView+Addition.h"
#import "NSNotificationCenter+Addition.h"

#define CameraActionSheet 1
#define LogoutActionSheet 2

#define kTextfieldTagBase 100
#define kTextfieldTagTop  106

@interface SettingsMainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *changePhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextfield;
@property (weak, nonatomic) IBOutlet UITextField *weiboTextfield;
@property (weak, nonatomic) IBOutlet UITextField *twitterTextfield;
@property (weak, nonatomic) IBOutlet UITextField *linkedInTextfield;
@property (weak, nonatomic) IBOutlet UITextField *dribbleTextfield;
@property (weak, nonatomic) IBOutlet UITextField *homePageTextfield;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIImageView *emailErrorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mobileErrorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textfieldBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIView *configView;
@property (weak, nonatomic) IBOutlet UIButton *backwardButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *hideKeyboardButton;
@property (weak, nonatomic) IBOutlet UILabel * currentUserNameLabel;

@property (nonatomic, readwrite) CGFloat textfieldTop;
@property (nonatomic, weak) UITextField *currentTextfield;
@property (nonatomic, readwrite) NSInteger currentTag;
@property (nonatomic, readwrite) CGFloat scrollViewContentHeight;

@property (nonatomic, strong) UIImage *image;

@end

@implementation SettingsMainViewController
{
    BOOL isLogoutButtonPressed;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isLogoutButtonPressed = NO;
    
    self.configView.translatesAutoresizingMaskIntoConstraints = NO;
    self.configView.userInteractionEnabled = NO;
    self.textfieldBottomSpaceConstraint.constant = 0;
    self.configView.alpha = 0.0;
    if (kIsChinese) {
        [_currentUserNameLabel setText:self.currentUser.realName];
    }
    else {
        [_currentUserNameLabel setText:self.currentUser.realNameEn];
    }
    
    _emailTextfield.delegate = self;
    _mobileTextfield.delegate = self;
    _weiboTextfield.delegate = self;
    _twitterTextfield.delegate = self;
    _linkedInTextfield.delegate = self;
    _dribbleTextfield.delegate = self;
    _homePageTextfield.delegate = self;
    _scrollView.delegate = self;
    
    _emailTextfield.text = self.currentUser.email;
    _mobileTextfield.text = self.currentUser.mobile;
    _weiboTextfield.text = self.currentUser.weiboURL;
    _twitterTextfield.text = self.currentUser.twitterURL;
    _linkedInTextfield.text = self.currentUser.linkedInURL;
    _dribbleTextfield.text = self.currentUser.dribbleURL;
    _homePageTextfield.text = self.currentUser.homePageURL;
    
//    _changePhotoButton.layer.cornerRadius = 5;
//    [_changePhotoButton.imageView loadImageFromURL:self.currentUser.avatarSmallURL
//                                        completion:^(BOOL succeeded) {
//                                        }];

    UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 141.0, 140.0)];
    [maskView setBackgroundColor:[UIColor whiteColor]];
    maskView.layer.cornerRadius = 5;
//
    
    [_avatorImageView loadImageFromURL:self.currentUser.avatarSmallURL
                            completion:^(BOOL succeeded) {
    }];
//    _avatorImageView.image = [_avatorImageView.image imageScaledToFitSize:CGSizeMake(141, 139)];
    [_avatorImageView.layer setMask:maskView.layer];
//    [_avatorImageView setImage:_avatorImageView.image];
    
//    _changePhotoButton.imageView.image = [_changePhotoButton.imageView.image imageScaledToFitSize:CGSizeMake(139, 139)];
//    [_changePhotoButton setImage:_changePhotoButton.imageView.image forState:UIControlStateNormal];
//    [_changePhotoButton setImage:_changePhotoButton.imageView.image forState:UIControlStateHighlighted];
    
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(keyboardWillHide:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.scrollViewContentHeight = 680;
    self.scrollView.contentSize = CGSizeMake(320, self.scrollViewContentHeight);
}

- (void)viewDidLayoutSubviews
{
    self.scrollViewContentHeight = 680;
    self.scrollView.contentSize = CGSizeMake(320, self.scrollViewContentHeight);
}

- (void)excuteAfterClickDoneButton:(void (^)(void))completion
{
    self.currentUser.email = self.emailTextfield.text;
    self.currentUser.mobile = self.mobileTextfield.text;
    self.currentUser.weiboURL = self.weiboTextfield.text;
    self.currentUser.twitterURL = self.twitterTextfield.text;
    self.currentUser.linkedInURL = self.linkedInTextfield.text;
    self.currentUser.dribbleURL = self.dribbleTextfield.text;
    self.currentUser.homePageURL = self.homePageTextfield.text;
    
    CDINetClient *client = [CDINetClient client];
    void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
        self.view.userInteractionEnabled = YES;
        RPActivityIndictor * activityIndictor = [RPActivityIndictor sharedRPActivityIndictor];
        [activityIndictor stopWaitingTimer];
        
        if (succeeded) {
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                [NSNotificationCenter postDidChangeCurrentUserNotification];
            }
            if (completion) {
                completion();
            }
        }
        else {
            [[RPActivityIndictor sharedRPActivityIndictor]excuteFailedinNotOverTimeStiution];
        }
    };
    
    [client updateUserWithUser:self.currentUser
                      password:self.currentUser.password
                    completion:handleData];
}

- (IBAction)didClickLogoutButton:(UIButton *)sender
{
    self.view.userInteractionEnabled = NO;
    isLogoutButtonPressed = YES;
    CDIUser *currentUser = [CDIUser currentUserInContext:self.managedObjectContext];
    NSString * logoutName;
    if (kIsChinese) {
        logoutName = currentUser.realName;
    }
    else {
        logoutName = currentUser.realNameEn;
    }
    UIActionSheet* mySheet = [[UIActionSheet alloc]
                              initWithTitle:logoutName
                              delegate:self
                              cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"InfoPlist", nil)
                              destructiveButtonTitle:NSLocalizedStringFromTable(@"Logout", @"InfoPlist", nil)
                              otherButtonTitles:nil];
    mySheet.tag = LogoutActionSheet;
    [mySheet showInView:self.view];
}

- (void)excuteAfterClickLogoutButton
{
    CDINetClient *client = [CDINetClient client];
    void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
        self.view.userInteractionEnabled = YES;
        RPActivityIndictor * activityIndictor = [RPActivityIndictor sharedRPActivityIndictor];
        [activityIndictor stopWaitingTimer];
        
        if (succeeded) {
            [CDIUser updateCurrentUserID:@""];
            [NSNotificationCenter postDidChangeCurrentUserNotification];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [[RPActivityIndictor sharedRPActivityIndictor]excuteFailedinNotOverTimeStiution];
        }
    };
    [client loginOutCurrentUserWithSessionKey:self.currentUser.sessionKey completion:handleData];
}

- (IBAction)didClickBackButton:(UIButton *)sender
{
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didCoverButton:(UIButton *)sender
{
    [self resignFirstResponder];
}

- (IBAction)didClickChangeInfoButton:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel",@"InfoPlist" ,nil)
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:NSLocalizedStringFromTable(@"Camera",@"InfoPlist", nil),
                                  NSLocalizedStringFromTable(@"Photo Album",@"InfoPlist", nil), nil];
    actionSheet.tag = CameraActionSheet;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == CameraActionSheet) {
        if(buttonIndex == actionSheet.cancelButtonIndex)
            return;
        
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.delegate = self;
        ipc.allowsEditing = YES;
        
        if(buttonIndex == 1) {
            ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else if(buttonIndex == 0) {
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        
        [self presentViewController:ipc animated:YES completion:nil];
    }
    
    if (actionSheet.tag == LogoutActionSheet) {
        if (buttonIndex == 0) {
            self.view.userInteractionEnabled = NO;
            
            RPActivityIndictor * activityIndictor = [RPActivityIndictor sharedRPActivityIndictor];
            activityIndictor.delegate = self;
            [activityIndictor resetBasicData];
            [activityIndictor startWaitingAnimationInView:self.view];
            [activityIndictor setWaitingTimer];
            //    [self startWaitingAnimation];
            //    [self setWaitingTimer];
            [self performSelector:@selector(excuteAfterClickLogoutButton) withObject:nil afterDelay:1.0];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.view.userInteractionEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320, self.scrollViewContentHeight);
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.view.userInteractionEnabled = NO;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
    self.image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.image = [self.image imageScaledToFitSize:CGSizeMake(141, 140)];
    
    UIView * maskView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, 141.0, 140.0)];
    [maskView setBackgroundColor:[UIColor whiteColor]];
    maskView.layer.cornerRadius = 5;
    
    _avatorImageView.image = [self.image imageScaledToFitSize:CGSizeMake(141, 140)];
    [_avatorImageView.layer setMask:maskView.layer];
    
    
    CDINetClient *client = [CDINetClient client];
    void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
        if (succeeded) {
            if ([responseData isKindOfClass:[NSString class]]) {
                NSString *url = [NSString stringWithFormat:@"http://cdi.tongji.edu.cn/cdisoul/upload/user_avatars/%@", responseData];
                self.currentUser.avatarSmallURL = url;
                NSLog(@"self current user avatorSmallUlr is %@",self.currentUser.avatarSmallURL);
                [NSNotificationCenter postDidChangeCurrentUserNotification];
                [self performSelector:@selector(excuteAfterClickPickImageButton:) withObject:nil afterDelay:1.0];
            }
        }
        else {
            [self pickImageFailed];
        }
    };
    [client updateUserAvatarWithImage:self.image
                           sessionKey:self.currentUser.sessionKey
                           completion:handleData];
    
    [self dismissViewControllerAnimated:YES completion:^{
        RPActivityIndictor * activityIndiactor = [RPActivityIndictor sharedRPActivityIndictor];
        activityIndiactor.delegate = self;
        [activityIndiactor startWaitingAnimationInView:self.view];
        [activityIndiactor setWaitingTimer];
    }];
}

- (void)excuteAfterClickPickImageButton:(void (^)(void))completion
{
    CDINetClient *client = [CDINetClient client];
    void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
        self.view.userInteractionEnabled = YES;
        RPActivityIndictor * activityIndictor = [RPActivityIndictor sharedRPActivityIndictor];
        [activityIndictor stopWaitingTimer];
        
        if (succeeded) {
            if ([responseData isKindOfClass:[NSDictionary class]]) {
                [NSNotificationCenter postDidChangeCurrentUserNotification];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self pickImageFailed];
        }
    };
    
    [client updateUserWithUser:self.currentUser
                      password:self.currentUser.password
                    completion:handleData];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextfield = textField;
    self.currentTag = textField.tag;
    
    [self updateConfigView];
}

- (void)updateConfigView
{
    self.backwardButton.enabled = self.currentTag != kTextfieldTagBase;
    self.forwardButton.enabled = self.currentTag != kTextfieldTagTop;
}

- (void)adjustScrollViewPosition
{
    CGFloat originY = self.currentTextfield.frame.origin.y - self.scrollView.contentOffset.y;
    CGFloat offset = originY - self.textfieldTop + 130;
    CGPoint targetOffset = self.scrollView.contentOffset;
    targetOffset.y += offset;
    [self.scrollView setContentOffset:targetOffset animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self excuteAfterClickDoneButton:nil];
    [self hideKeyboard];
    return YES;
}

- (IBAction)didClickBackwardButton:(UIButton *)sender
{
    if (self.currentTag != 0) {
        self.currentTag--;
        self.currentTextfield = (UITextField *)[self.view viewWithTag:self.currentTag];
        [self.currentTextfield becomeFirstResponder];
        [self updateConfigView];
        [self adjustScrollViewPosition];
    }
}

- (IBAction)didClickForwardButton:(id)sender
{
    if (self.currentTag != 0) {
        self.currentTag++;
        self.currentTextfield = (UITextField *)[self.view viewWithTag:self.currentTag];
        [self.currentTextfield becomeFirstResponder];
        [self updateConfigView];
        [self adjustScrollViewPosition];
    }
}

- (IBAction)didClickHideKeyboardButton:(UIButton *)sender
{
    [self excuteAfterClickDoneButton:nil];
    [self hideKeyboard];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"contentOffset y is %f",self.scrollView.contentOffset.y);
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardBounds = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyboardHeight = keyboardBounds.size.height;
    self.textfieldTop = kCurrentScreenHeight - keyboardHeight;
    
    self.configView.userInteractionEnabled = YES;
    self.configView.alpha = 1.0;
    self.textfieldBottomSpaceConstraint.constant = keyboardHeight;
    
    double animationDuration;
    animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    NSLog(@"%f",animationDuration);
//    NSLog(@"%@",[[notification userInfo]objectForKey:UIKeyboardAnimationCurveUserInfoKey]);
    
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    [UIView animateWithDuration:animationDuration delay:0.0 options:(animationCurve << 16) animations:^{
//        self.configView.frame = CGRectMake(0.0, self.textfieldTop - 45.0, 320.0, 45.0);
//        self.configView.alpha = 1.0;
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished){
    }];
    
    [self adjustScrollViewPosition];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.textfieldBottomSpaceConstraint.constant = 0;
    self.configView.alpha = 0.0;
    double animationDuration;
    animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
//    NSLog(@"%@",[[notification userInfo]objectForKey:UIKeyboardAnimationCurveUserInfoKey]);
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    [UIView animateWithDuration:animationDuration delay:0.0 options:animationCurve << 16 animations:^{
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished){
    }];
    
//    self.configView.userInteractionEnabled = NO;
//    self.configView.alpha = 0.0;
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
    if (self.scrollView.contentOffset.y >= self.scrollViewContentHeight - self.scrollView.frame.size.height) {
            CGPoint offset = self.scrollView.contentOffset;
            offset.y = self.scrollViewContentHeight - self.scrollView.frame.size.height;
    
            [self.scrollView setContentOffset:offset animated:YES];
        }
        self.scrollView.contentSize = CGSizeMake(320, self.scrollViewContentHeight);
}

- (void)logoutFailed
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"Logout Failed", @"InfoPlist", nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedStringFromTable(@"Close", @"InfoPlist", nil) otherButtonTitles:nil];
    [alertView show];
    self.view.userInteractionEnabled = YES;
}

- (void)setUpInfoFailed
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"Setup Info Failed", @"InfoPlist", nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedStringFromTable(@"Close", @"InfoPlist", nil) otherButtonTitles:nil];
    [alertView show];
    self.view.userInteractionEnabled = YES;
}

- (void)pickImageFailed
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"Pick the Image Failed", @"InfoPlist", nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedStringFromTable(@"Close", @"InfoPlist", nil) otherButtonTitles:nil];
    [alertView show];
    self.view.userInteractionEnabled = YES;
}

#pragma mark - RPActivity Delegate
-(void)someThingAfterActivityIndicatorOverTimer
{
    if (isLogoutButtonPressed) {
        [self logoutFailed];
    }
    else {
        [self setUpInfoFailed];
    }
}

@end
