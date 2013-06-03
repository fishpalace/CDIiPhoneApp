//
//  SLDetailTableViewController.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-3.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "SLDetailTableViewController.h"
#import "UIApplication+Addition.h"
#import "UIView+Resize.h"


#define kSLDetailTableViewHeight  468
#define kSLDetailTableViewWidth   302

@interface SLDetailTableViewController ()

@end

@implementation SLDetailTableViewController

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
}

- (void)configureSubviews
{
  [self.view resetSize:CGSizeMake(kSLDetailTableViewWidth, [self tableViewHeight])];
}

- (CGFloat)tableViewHeight
{
  CGFloat offset = kIsiPhone5 ? 0 : -88;
  return kSLDetailTableViewHeight + offset;
}

@end
