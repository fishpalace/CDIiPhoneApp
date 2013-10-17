//
//  SetupInfoViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-8-1.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CoreDataViewController.h"
#import "RPActivityIndictor.h"

@interface SetupInfoViewController : CoreDataViewController <UITextFieldDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,RPActivityIndictorDelegate>

@property (nonatomic, strong) NSString *password;

@end
