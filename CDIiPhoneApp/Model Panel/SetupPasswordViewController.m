//
//  SetupPasswordViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-8-1.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "SetupPasswordViewController.h"
#import "UIView+Addition.h"
#import "SetupInfoViewController.h"
#import "NSString+Encrypt.h"

@interface SetupPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordNewTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTextfield;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIImageView *passwordConfirmErrorImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textfieldBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIView *configView;

@end

@implementation SetupPasswordViewController

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
	// Do any additional setup after loading the view.
  _passwordNewTextfield.delegate = self;
  _passwordConfirmTextfield.delegate = self;
  [_passwordNewTextfield becomeFirstResponder];
}

- (IBAction)didClickBackButton:(UIButton *)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  BOOL result = NO;
  if ([textField isEqual:self.passwordNewTextfield]) {
    if (self.passwordNewTextfield.text.length > 0) {
      result = YES;
      [self.passwordConfirmTextfield becomeFirstResponder];
    }
  } else if ([textField isEqual:self.passwordConfirmTextfield]) {
    if (self.passwordConfirmTextfield.text.length > 0) {
      if ([self.passwordNewTextfield.text isEqualToString:self.passwordConfirmTextfield.text]) {
        [self submitPasswordChange];
        result = YES;
      } else {
        [self.passwordConfirmErrorImageView blinkForRepeatCount:2 duration:0.3];
      }
    } else {
      [self.passwordConfirmErrorImageView blinkForRepeatCount:2 duration:0.3];
    }
  }
  return result;
}

- (void)submitPasswordChange
{
  [self performSegueWithIdentifier:@"SetupInfoSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  SetupInfoViewController *vc = segue.destinationViewController;
  vc.password = [self.passwordNewTextfield.text md5];
}

@end
