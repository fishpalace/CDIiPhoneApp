//
//  SetupInfoViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-8-1.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CoreDataViewController.h"

@interface SetupInfoViewController : CoreDataViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSString *password;

@end
