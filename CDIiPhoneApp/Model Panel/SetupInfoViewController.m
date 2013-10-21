//
//  SetupInfoViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-8-1.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "SetupInfoViewController.h"
#import "UIApplication+Addition.h"
#import "CDINetClient.h"
#import "CDIUser.h"
#import "UIImage+ProportionalFill.h"
#import "UIImageView+Addition.h"
#import "NSNotificationCenter+Addition.h"

#define kTextfieldTagBase 100
#define kTextfieldTagTop  106

@interface SetupInfoViewController ()

@property (weak, nonatomic) IBOutlet UIButton *changePhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextfield;
@property (weak, nonatomic) IBOutlet UITextField *weiboTextfield;
@property (weak, nonatomic) IBOutlet UITextField *twitterTextfield;
@property (weak, nonatomic) IBOutlet UITextField *linkedInTextfield;
@property (weak, nonatomic) IBOutlet UITextField *dribbleTextfield;
@property (weak, nonatomic) IBOutlet UITextField *homePageTextfield;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIImageView *emailErrorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mobileErrorImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textfieldBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIView *configView;
@property (weak, nonatomic) IBOutlet UIButton *backwardButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *hideKeyboardButton;

@property (nonatomic, readwrite) CGFloat textfieldTop;
@property (nonatomic, weak) UITextField *currentTextfield;
@property (nonatomic, readwrite) NSInteger currentTag;
@property (nonatomic, readwrite) CGFloat scrollViewContentHeight;

@end

@implementation SetupInfoViewController
{
    BOOL isFirstTimeAddIn;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.configView.translatesAutoresizingMaskIntoConstraints = NO;
    self.configView.userInteractionEnabled = NO;
    self.textfieldBottomSpaceConstraint.constant = 0;
    self.configView.alpha = 0.0;
    
    isFirstTimeAddIn = YES;
    
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
    
    [_changePhotoButton.imageView loadImageFromURL:self.currentUser.avatarSmallURL
                                        completion:^(BOOL succeeded) {
                                        }];
    _changePhotoButton.imageView.image = [_changePhotoButton.imageView.image imageScaledToFitSize:CGSizeMake(141, 141)];
    _changePhotoButton.imageView.layer.cornerRadius = 5;
    [_changePhotoButton setImage:_changePhotoButton.imageView.image forState:UIControlStateNormal];
    [_changePhotoButton setImage:_changePhotoButton.imageView.image forState:UIControlStateHighlighted];
    
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
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(320, self.homePageTextfield.frame.origin.y + 50);
    self.scrollViewContentHeight = self.scrollView.contentSize.height;
    NSLog(@"!!!contentSize is %f frame is %f",self.scrollView.contentSize.height,self.scrollView.frame.size.height);

}

- (IBAction)didClickDoneButton:(UIButton *)sender
{
    self.view.userInteractionEnabled = NO;
    RPActivityIndictor * activityIndiactor = [RPActivityIndictor sharedRPActivityIndictor];
    activityIndiactor.delegate = self;
    [activityIndiactor startWaitingAnimationInView:self.view];
    [activityIndiactor setWaitingTimer];
    [self performSelector:@selector(exuteAfterClickDoneButton) withObject:nil afterDelay:1.0];
}

- (void)exuteAfterClickDoneButton
{
    self.currentUser.password = self.password;
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
//                NSDictionary *dict = responseData;
//                NSLog(@"%@", dict);
                [NSNotificationCenter postDidChangeCurrentUserNotification];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self setUpInfoFailed];
        }
    };
    
    [client updateUserWithUser:self.currentUser
                      password:self.password
                    completion:handleData];
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
                                  cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel",@"InfoPlist",nil)
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:NSLocalizedStringFromTable(@"Camera",@"InfoPlist", nil), NSLocalizedStringFromTable(@"Photo Album", @"InfoPlist",nil), nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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

#pragma mark - UIImagePickerController delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
    UIImage *edittedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    edittedImage = [edittedImage imageScaledToFitSize:CGSizeMake(141, 141)];
    [self.changePhotoButton setImage:edittedImage forState:UIControlStateNormal];
    [self.changePhotoButton setImage:edittedImage forState:UIControlStateHighlighted];
    
    CDINetClient *client = [CDINetClient client];
    void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
        if (succeeded) {
            if ([responseData isKindOfClass:[NSString class]]) {
                NSString *url = [NSString stringWithFormat:@"http://cdi.tongji.edu.cn/cdisoul/upload/user_avatars/%@", responseData];
                self.currentUser.avatarSmallURL = url;
            }
        }
    };
    
    [client updateUserAvatarWithImage:edittedImage
                           sessionKey:self.currentUser.sessionKey
                           completion:handleData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
//    NSLog(@"orginY currentTextField is %f",originY);
//    NSLog(@"the textfield top is %f",self.textfieldTop);
//    NSLog(@"targetOffset is %f",self.scrollView.contentOffset.y);
    targetOffset.y += offset;
    if (isFirstTimeAddIn) {
        targetOffset.y = 0.0;
        isFirstTimeAddIn = NO;
    }
    
    [self.scrollView setContentOffset:targetOffset animated:YES];
    
//    CGFloat originY = self.currentTextfield.frame.origin.y;

//    CGFloat offset = originY - self.textfieldTop + 130;
//    CGPoint targetOffset = self.scrollView.contentOffset;
//    targetOffset.y = offset;
//    [self.scrollView setContentOffset:targetOffset animated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
    [self hideKeyboard];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"self scroll view y point is %f",self.scrollView.contentOffset.y);
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
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    [UIView animateWithDuration:animationDuration delay:0.0 options:(animationCurve << 16) animations:^{
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
}

- (void)hideKeyboard
{
    NSLog(@"contentSize is %f frame is %f",self.scrollView.contentSize.height,self.scrollView.frame.size.height);
    [self.view endEditing:YES];
    if (self.scrollView.contentOffset.y >= self.scrollViewContentHeight - self.scrollView.frame.size.height) {
        CGPoint offset = self.scrollView.contentOffset;
        offset.y = self.scrollViewContentHeight - self.scrollView.frame.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollView.contentOffset = offset;
        }];
    }
    self.scrollView.contentSize = CGSizeMake(320, self.homePageTextfield.frame.origin.y + 50);
}

- (void)setUpInfoFailed
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"Setup Info Failed", @"InfoPlist", nil)
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alertView show];
    self.view.userInteractionEnabled = YES;
}

#pragma mark - RPActivity Delegate
-(void)someThingAfterActivityIndicatorOverTimer
{
    [self setUpInfoFailed];
}
@end
