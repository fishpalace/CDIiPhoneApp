//
//  NSNotification+Addition.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-1.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (Addition)

+ (void)postShouldBounceDownNotification;
+ (void)postShouldBounceUpNotification;

+ (void)registerShouldBounceDownNotificationWithSelector:(SEL)aSelector target:(id)aTarget;
+ (void)registerShouldBounceUpNotificationWithSelector:(SEL)aSelector target:(id)aTarget;

+ (void)unregister:(id)target;
@end
