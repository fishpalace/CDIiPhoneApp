//
//  TImeZone.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-2.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeZone : NSObject

@property (nonatomic, assign) NSInteger startingValue;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) NSInteger endValue;
@property (nonatomic, assign) BOOL      available;

- (id)initWithStartingValue:(NSInteger)startingValue length:(NSInteger)length available:(BOOL)available;
- (id)initWithStartValue:(NSInteger)startingValue endValue:(NSInteger)endValue available:(BOOL)available;
- (BOOL)containsZoneWithStartValue:(NSInteger)startingValue length:(NSInteger)length;
- (NSInteger)endValue;

@end