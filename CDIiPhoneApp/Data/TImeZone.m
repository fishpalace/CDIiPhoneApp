//
//  TImeZone.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-2.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "TImeZone.h"

@implementation TimeZone

- (id)initWithStartingValue:(NSInteger)startingValue length:(NSInteger)length available:(BOOL)available
{
  self = [super init];
  if (self) {
    self.startingValue = startingValue;
    self.length = length;
    self.available = available;
  }
  return self;
}

- (id)initWithStartValue:(NSInteger)startingValue endValue:(NSInteger)endValue available:(BOOL)available
{
  self = [super init];
  if (self) {
    self.startingValue = startingValue;
    self.length = endValue - startingValue;
    self.available = available;
  }
  return self;
}

- (BOOL)containsZoneWithStartValue:(NSInteger)startingValue length:(NSInteger)length
{
  BOOL containsStart = startingValue > self.startingValue && startingValue < self.startingValue + self.length;
  BOOL containsEnd = startingValue + length > self.startingValue && startingValue + length < self.startingValue + self.length;
  BOOL beContained = startingValue <= self.startingValue && startingValue + length >= self.startingValue + self.length;
  return containsStart || containsEnd || beContained;
}

- (NSInteger)endValue
{
  return self.startingValue + self.length;
}

- (void)setEndValue:(NSInteger)endValue
{
  self.length = endValue - self.startingValue;
}

@end
