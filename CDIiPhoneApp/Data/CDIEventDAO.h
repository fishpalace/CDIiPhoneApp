//
//  CDIEventDAO.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-20.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDIUser.h"

@interface CDIEventDAO : NSObject

@property (nonatomic, strong) NSNumber * abandoned;
@property (nonatomic, strong) NSString * accessKey;
@property (nonatomic, strong) NSNumber * active;
@property (nonatomic, strong) NSDate * endDate;
@property (nonatomic, strong) NSNumber * endValue;
@property (nonatomic, strong) NSString * eventID;
@property (nonatomic, strong) NSNumber * isPlaceHolder;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * passed;
@property (nonatomic, strong) NSString * relatedInfo;
@property (nonatomic, strong) NSNumber * roomID;
@property (nonatomic, strong) NSDate * startDate;
@property (nonatomic, strong) NSNumber * startValue;
@property (nonatomic, strong) CDIUser *creator;

+ (CDIEventDAO *)sharedNewEvent;
+ (id)eventDAOInstanceWithEvent:(CDIEvent *)event;
+ (id)eventInstanceWithTitle:(NSString *)title;
- (id)eventCopy;
- (id)initWithDictionary:(NSDictionary *)dict;

@end
