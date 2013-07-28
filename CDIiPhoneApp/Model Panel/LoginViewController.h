//
//  LoginViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-23.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LoginPanelCallback)(void);

@interface LoginViewController : CoreDataViewController <UITextFieldDelegate>

@property (nonatomic, strong) LoginPanelCallback callBack;

+ (void)displayLoginPanelWithCallBack:(LoginPanelCallback)callBack;

@end
