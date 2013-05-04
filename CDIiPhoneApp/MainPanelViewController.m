//
//  ViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-3.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "MainPanelViewController.h"

@interface MainPanelViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


@end

@implementation MainPanelViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self configureBasicViews];
}

#pragma mark - View Setup Methods
- (void)configureBasicViews
{
  UIImage *backgroundImage = [[UIImage imageNamed:@"mp_bg"] resizableImageWithCapInsets:UIEdgeInsetsZero];
  [self.backgroundImageView setImage:backgroundImage];
}

@end
