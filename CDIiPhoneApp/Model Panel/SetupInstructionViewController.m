//
//  SetupInstructionViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-8-1.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "SetupInstructionViewController.h"

@interface SetupInstructionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *setupButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;

@end

@implementation SetupInstructionViewController

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
    CDIUser *currentUser = [CDIUser currentUserInContext:self.managedObjectContext];
    _titleLabel.text = currentUser.realNameEn;
}

- (void)updateViewConstraints
{
  [super updateViewConstraints];
  self.bottomSpaceConstraint.constant = 11;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
