//
//  CDIUser.h
//  CDI_iPad_App
//
//  Created by Gabriel Yeah on 13-4-1.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDIUser : NSObject

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userRealName;
@property (nonatomic, strong) NSString *avatarLargeURL;
@property (nonatomic, strong) NSString *avatarMidURL;
@property (nonatomic, strong) NSString *avatarSmallURL;
@property (nonatomic, strong) NSString *sessionKey;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *title;

+ (CDIUser *)currentUser;
+ (void)updateCurrentUserWithDictionary:(NSDictionary *)dict
                             sessionKey:(NSString *)sessionKey;
- (id)initWithName:(NSString *)name title:(NSString *)title position:(NSString *)position;

@end
