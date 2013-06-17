//
//  CDIEvent.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-17.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDIUser;

@interface CDIEvent : NSManagedObject

@property (nonatomic, retain) NSNumber * abandoned;
@property (nonatomic, retain) NSString * accessKey;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * endValue;
@property (nonatomic, retain) NSString * eventID;
@property (nonatomic, retain) NSNumber * isPlaceHolder;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * passed;
@property (nonatomic, retain) NSString * relatedInfo;
@property (nonatomic, retain) NSNumber * roomID;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * startValue;
@property (nonatomic, retain) CDIUser *creator;

@end
