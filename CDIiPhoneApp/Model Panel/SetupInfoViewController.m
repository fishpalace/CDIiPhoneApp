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
  self.scrollView.contentSize = CGSizeMake(320, self.homePageTextfield.frame.origin.y + 50);
  self.scrollViewContentHeight = self.scrollView.contentSize.height;
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
        NSDictionary *dict = responseData;
        NSLog(@"%@", dict);
      }
      [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *edittedImage = [info objectForKey:UIImagePickerControllerEditedImage];
//  edittedImage = [edittedImage imageScaledToFitSize:CROP_AVATAR_SIZE];
  
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  self.currentTextfield = textField;
  self.currentTag = textField.tag;
  
  [self updateConfigView];
//  [self adjustScrollViewPosition];
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
  [UIView animateWithDuration:0.3 animations:^{
    self.scrollView.contentOffset = targetOffset;
  }];
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
    [UIView animateWithDuration:0.3 animations:^{
      self.scrollView.contentOffset = offset;
    }];
  }
  self.scrollView.contentSize = CGSizeMake(320, self.homePageTextfield.frame.origin.y + 50);
}

@end
