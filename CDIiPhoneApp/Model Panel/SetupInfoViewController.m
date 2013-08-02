//
//  SetupInfoViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-8-1.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "SetupInfoViewController.h"

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



@property (nonatomic, weak) UITextField *currentTextfield;

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
}

- (IBAction)didClickDoneButton:(UIButton *)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
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
  
}

- (IBAction)didClickBackwardButton:(UIButton *)sender
{
  
}

- (IBAction)didClickForwardButton:(id)sender
{
  
}

- (IBAction)didClickHideKeyboardButton:(UIButton *)sender
{
  [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification {
  NSDictionary *info = [notification userInfo];
  CGRect keyboardBounds = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  
  CGFloat keyboardHeight;
  keyboardHeight = keyboardBounds.size.height;
  self.textfieldBottomSpaceConstraint.constant = keyboardHeight;
  [UIView animateWithDuration:0.3 animations:^{
    [self.configView layoutIfNeeded];
  }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
  self.textfieldBottomSpaceConstraint.constant = -200;
  [UIView animateWithDuration:0.3 animations:^{
    [self.configView layoutIfNeeded];
  }];
}

@end
