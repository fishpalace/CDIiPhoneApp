//
//  NSNotification+Addition.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-1.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "NSNotificationCenter+Addition.h"

#define kShouldBounceDown     @"kShouldBounceDown"
#define kShouldBounceUp       @"kShouldBounceUp"
#define kDidFetchNewEvents    @"kDidFetchNewEvents"
#define kDidChangeCurrentUser @"kDidChangeCurrentUser"
#define kShouldChangeLocalDatasource @"kShouldChangeLocalDatasource"
#define kDidFetchNewDataNotification @"kDidFetchNewDataNotification"

@implementation NSNotificationCenter (Addition)

+ (void)postShouldBounceDownNotification
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kShouldBounceDown object:nil userInfo:nil];
}

+ (void)postShouldBounceUpNotification
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kShouldBounceUp object:nil userInfo:nil];
}

+ (void)postDidFetchNewEventsNotification
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kDidFetchNewEvents object:nil userInfo:nil];
}

+ (void)postDidChangeCurrentUserNotification
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kDidChangeCurrentUser object:nil userInfo:nil];
}

+ (void)postShouldChangeLocalDatasourceNotification
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kShouldChangeLocalDatasource object:nil userInfo:nil];
}

+ (void)postDidFetchNewDataNotification
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kDidFetchNewDataNotification object:nil userInfo:nil];
}

+ (void)registerShouldBounceDownNotificationWithSelector:(SEL)aSelector target:(id)aTarget
{
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  [center addObserver:aTarget selector:aSelector
                 name:kShouldBounceDown
               object:nil];
}

+ (void)registerShouldBounceUpNotificationWithSelector:(SEL)aSelector target:(id)aTarget
{
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  [center addObserver:aTarget selector:aSelector
                 name:kShouldBounceUp
               object:nil];
}

+ (void)registerDidFetchNewEventsNotificationWithSelector:(SEL)aSelector target:(id)aTarget
{
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  [center addObserver:aTarget selector:aSelector
                 name:kDidFetchNewEvents
               object:nil];
}

+ (void)registerDidChangeCurrentUserNotificationWithSelector:(SEL)aSelector target:(id)aTarget
{
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  [center addObserver:aTarget selector:aSelector
                 name:kDidChangeCurrentUser
               object:nil];
}

+ (void)registerShouldChangeLocalDatasourceNotificationWithSelector:(SEL)aSelector target:(id)aTarget
{
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  [center addObserver:aTarget selector:aSelector
                 name:kShouldChangeLocalDatasource
               object:nil];
}

+ (void)registerDidFetchNewDataNotificationWithSelector:(SEL)aSelector target:(id)aTarget
{
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  [center addObserver:aTarget selector:aSelector
                 name:kDidFetchNewDataNotification
               object:nil];
}

+ (void)unregister:(id)target
{
  [[NSNotificationCenter defaultCenter] removeObserver:target];
}

@end
