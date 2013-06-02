//
//  CDIEventDataSource.h
//  CDI_iPad_App
//
//  Created by Gabriel Yeah on 13-3-31.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDIDataSource : NSObject

+ (void)fetchDataWithCompletion:(void (^)(BOOL succeeded, id responseData))completion;

+ (NSArray *)todayEvents;

+ (NSArray *)tomorrowEvents;

+ (NSInteger)futureEventCount;

+ (NSString *)currentRoomName;

@end
