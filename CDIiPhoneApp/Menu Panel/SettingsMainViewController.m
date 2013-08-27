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

@property (nonatomic, strong) UIImage *image;

@end

@implementation SettingsMainViewController

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
  
  _textfieldBottomSpaceConstraint.constant = -200;
  
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
  self.scrollViewContentHeight = 730;
  self.scrollView.contentSize = CGSizeMake(320, self.scrollViewContentHeight);
}

- (IBAction)didClickDoneButton:(UIButton *)sender
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
    if (succeeded) {
      if ([responseData isKindOfClass:[NSDictionary class]]) {
        [NSNotificationCenter postDidChangeCurrentUserNotification];
      }
      [self.navigationController popViewControllerAnimated:YES];
    }
  };
  
  [client updateUserWithUser:self.currentUser password:self.currentUser.password
                  completion:handleData];
  
}
- (IBAction)didClickLogoutButton:(UIButton *)sender
{
  CDINetClient *client = [CDINetClient client];
  void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
    [CDIUser updateCurrentUserID:@""];
    [NSNotificationCenter postDidChangeCurrentUserNotification];
    [self.navigationController popViewControllerAnimated:YES];
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
                                cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                destructiveButtonTitle:nil
                                otherButtonTitles:NSLocalizedString(@"Camera", nil), NSLocalizedString(@"Photo Album", nil), nil];
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

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
  self.scrollView.scrollEnabled = YES;
  self.scrollView.contentSize = CGSizeMake(320, self.scrollViewContentHeight);
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  self.image = [info objectForKey:UIImagePickerControllerEditedImage];
  self.image = [self.image imageScaledToFitSize:CGSizeMake(200, 200)];
  [self.changePhotoButton setImage:self.image forState:UIControlStateNormal];
  [self.changePhotoButton setImage:self.image forState:UIControlStateHighlighted];
  
  CDINetClient *client = [CDINetClient client];
  void (^handleData)(BOOL succeeded, id responseData) = ^(BOOL succeeded, id responseData){
    if (succeeded) {
      if ([responseData isKindOfClass:[NSString class]]) {
        NSString *url = [NSString stringWithFormat:@"http://cdi.tongji.edu.cn/cdisoul/upload/user_avatars/%@", responseData];
        self.currentUser.avatarSmallURL = url;
      }
    }
  };
  
  [client updateUserAvatarWithImage:self.image
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
  targetOffset.y += offset;
  [self.scrollView setContentOffset:targetOffset animated:YES];
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

- (void)keyboardWillShow:(NSNotification *)notification {
  NSDictionary *info = [notification userInfo];
  CGRect keyboardBounds = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  
  CGFloat keyboardHeight = keyboardBounds.size.height;
  self.textfieldTop = kCurrentScreenHeight - keyboardHeight;
  self.textfieldBottomSpaceConstraint.constant = keyboardHeight;
  [UIView animateWithDuration:0.2 animations:^{
    [self.view layoutIfNeeded];
  }];
  [self adjustScrollViewPosition];
}

- (void)keyboardWillHide:(NSNotification *)notification {
  self.textfieldBottomSpaceConstraint.constant = -200;
  [UIView animateWithDuration:0.2 animations:^{
    [self.view layoutIfNeeded];
  }];
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
@end
