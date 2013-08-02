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
+ (void)postDidFetchNewEventsNotification;
+ (void)postDidChangeCurrentUserNotification;
+ (void)postShouldChangeLocalDatasourceNotification;
+ (void)postDidFetchNewDataNotification;

+ (void)registerShouldBounceDownNotificationWithSelector:(SEL)aSelector target:(id)aTarget;
+ (void)registerShouldBounceUpNotificationWithSelector:(SEL)aSelector target:(id)aTarget;
+ (void)registerDidFetchNewEventsNotificationWithSelector:(SEL)aSelector target:(id)aTarget;
+ (void)registerDidChangeCurrentUserNotificationWithSelector:(SEL)aSelector target:(id)aTarget;
+ (void)registerShouldChangeLocalDatasourceNotificationWithSelector:(SEL)aSelector target:(id)aTarget;
+ (void)registerDidFetchNewDataNotificationWithSelector:(SEL)aSelector target:(id)aTarget;

+ (void)unregister:(id)target;
@end
