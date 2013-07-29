//
//  ProjectDetailViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-29.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "ProjectDetailViewController.h"
#import "TTTAttributedLabel.h"
#import "CDIWork.h"
#import "UIImageView+Addition.h"
#import "UIView+Addition.h"

#define kLineSpacing 4

@interface ProjectDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *projectInfoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectInfoLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ProjectDetailViewController

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
  [_projectImageView loadImageFromURL:self.work.imgURL completion:^(BOOL succeeded) {
    [_projectImageView fadeIn];
  }];
  [_projectNameLabel setText:self.work.name];
  [_projectStatusLabel setText:self.work.workStatus];
  [_projectTypeLabel setText:self.work.workType];
  [_projectNameLabel setText:self.work.name];
  
  [_projectInfoLabel setText:self.work.workInfo];
  NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:_projectInfoLabel.attributedText];
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  [style setLineSpacing:kLineSpacing];
  [string addAttribute:NSParagraphStyleAttributeName
                 value:style
                 range:NSMakeRange(0, string.length)];
  [_projectInfoLabel setAttributedText:string];
}

- (void)viewDidAppear:(BOOL)animated
{
  [self.scrollView setContentSize:CGSizeMake(320, self.projectInfoLabel.frame.origin.y + self.projectInfoLabel.frame.size.height)];
}

- (void)updateViewConstraints
{
  [super updateViewConstraints];
  [self.projectInfoLabelHeightConstraint setConstant:[self heightForContentLabel]];
}

- (CGFloat)heightForContentLabel
{
  CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)self.projectInfoLabel.attributedText);
  CFRange fitRange;
  CFRange textRange = CFRangeMake(0, self.projectInfoLabel.attributedText.length);
  
  CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, textRange, NULL, CGSizeMake(290, CGFLOAT_MAX), &fitRange);
  
  CFRelease(framesetter);
  return frameSize.height + 50;
}


- (IBAction)didClickBackButton:(UIButton *)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

@end
