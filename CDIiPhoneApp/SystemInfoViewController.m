//
//  SystemInfoViewController.m
//  CDIiPhoneApp
//
//  Created by Emerson on 13-10-21.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "SystemInfoViewController.h"

@interface SystemInfoViewController ()

@end

@implementation SystemInfoViewController

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

#pragma mark - IBActions
- (IBAction)didClickBackButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickWebSiteButton:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:@"http://cdi.tongji.edu.cn"];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
