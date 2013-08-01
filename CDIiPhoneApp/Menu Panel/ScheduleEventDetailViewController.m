//
//  ScheduleEventDetailViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-8-2.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "ScheduleEventDetailViewController.h"
#import "TTTAttributedLabel.h"
#import "UIImageView+Addition.h"
#import "CDIEvent.h"

#define kLineSpacing                      4

@interface ScheduleEventDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *titleContainerView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleContainerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeightConstraint;

@end

@implementation ScheduleEventDetailViewController

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
//  [_imageView loadImageFromURL:self.event. completion:^(BOOL succeeded) {
//    [_imageView fadeIn];
//  }];
  [_titleLabel setText:self.event.name];
//  [_typeLabel setText:self.event.e];
//  [_contentLabel setText:self.event.content];
  [_contentLabel setNumberOfLines:100000];
  
  NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:_contentLabel.attributedText];
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  [style setLineSpacing:kLineSpacing];
  [string addAttribute:NSParagraphStyleAttributeName
                 value:style
                 range:NSMakeRange(0, string.length)];
  [_contentLabel setAttributedText:string];
}

- (IBAction)didClickBackButton:(UIButton *)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

@end
