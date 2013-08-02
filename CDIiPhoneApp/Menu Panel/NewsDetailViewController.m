//
//  NewsDetailViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-29.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "UIImageView+Addition.h"
#import "UIView+Addition.h"
#import "CDINews.h"
#import "NSDate+Addition.h"
#import "TTTAttributedLabel.h"
#import "NSAttributedString+Size.h"

#define kTitleContainerViewStandardHeight 70
#define kTitleContainerSingleLineHeight   17
#define kContentSingleLineHeight          21
#define kLineSpacing                      4

@interface NewsDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *titleContainerView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleContainerViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeightConstraint;

@end

@implementation NewsDetailViewController

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
  [_imageView loadImageFromURL:self.news.imageURL completion:^(BOOL succeeded) {
    [_imageView fadeIn];
  }];
  [_titleLabel setText:self.news.title];
  [_dateLabel setText:[NSDate stringOfDate:self.news.date includingYear:YES]];
  [_contentLabel setText:self.news.content];
  [_contentLabel setNumberOfLines:100000];
  
  NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:_contentLabel.attributedText];
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  [style setLineSpacing:kLineSpacing];
  [string addAttribute:NSParagraphStyleAttributeName
                 value:style
                 range:NSMakeRange(0, string.length)];
  [_contentLabel setAttributedText:string];
}

- (void)updateViewConstraints
{
  [super updateViewConstraints];
  self.titleContainerViewHeightConstraint.constant = [self heightForTitleContainerView];
  self.contentLabelHeightConstraint.constant = [self heightForContentLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
  CGFloat height = self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height;
  height = height < self.scrollView.frame.size.height ? self.scrollView.frame.size.height + 1 : height;
  [self.scrollView setContentSize:CGSizeMake(320, height)];
}

- (CGFloat)heightForTitleContainerView
{
  CGFloat height = kTitleContainerViewStandardHeight;
  CGSize size = [self.news.title sizeWithFont:kRLightFontWithSize(14)
                            constrainedToSize:CGSizeMake(290, 1000)
                                lineBreakMode:NSLineBreakByCharWrapping];
  height = kTitleContainerViewStandardHeight + size.height - kTitleContainerSingleLineHeight;
  return height;
}

- (CGFloat)heightForContentLabel
{
  CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)self.contentLabel.attributedText);
  CFRange fitRange;
  CFRange textRange = CFRangeMake(0, self.contentLabel.attributedText.length);
  
  CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, textRange, NULL, CGSizeMake(290, CGFLOAT_MAX), &fitRange);
  
  CFRelease(framesetter);
  return frameSize.height + 25;
}

- (IBAction)didClickBackButton:(UIButton *)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

@end
