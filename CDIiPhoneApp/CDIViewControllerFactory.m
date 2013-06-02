//
//  CDIViewControllerFactory.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-2.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CDIViewControllerFactory.h"

static CDIViewControllerFactory *sharedFactory;

@implementation CDIViewControllerFactory

+ (CDIViewControllerFactory *)sharedFactory
{
  if (!sharedFactory) {
    sharedFactory = [[CDIViewControllerFactory alloc] init];
  }
  return sharedFactory;
}

+ (UIViewController *)instantiateViewControllerWithIdentifier:(NSString *)identifier {
  //TODO
  return nil;
}

@end
