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

+ (void)unregister:(id)target
{
  [[NSNotificationCenter defaultCenter] removeObserver:target];
}

@end
