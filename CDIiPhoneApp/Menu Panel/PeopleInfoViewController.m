//
//  PeopleInfoViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-4.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "PeopleInfoViewController.h"
#import "CDIUser.h"

@interface PeopleInfoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPositionLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoHomepageButton;
@property (weak, nonatomic) IBOutlet UIButton *infoDribbleButton;
@property (weak, nonatomic) IBOutlet UIButton *infoWeiboButton;
@property (weak, nonatomic) IBOutlet UIButton *infoLinkedinButton;
@property (weak, nonatomic) IBOutlet UIButton *infoTwitterButton;
@property (weak, nonatomic) IBOutlet UIImageView *upperBGImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lowerBGImageView;

@end

@implementation PeopleInfoViewController

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
  _userNameLabel.text = self.user.userName;
  _userPositionLabel.text = self.user.position;
  _userTitleLabel.text = self.user.title;
  _avatarImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"test_avatar_%d", self.index + 1]];
}

- (void)viewDidAppear:(BOOL)animated
{
  self.upperBGImageView.image = [[UIImage imageNamed:@"tableview_bg_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 20, 10) resizingMode:UIImageResizingModeTile];
  
  self.lowerBGImageView.image = [[UIImage imageNamed:@"tableview_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 20, 10) resizingMode:UIImageResizingModeTile];
}

@end
