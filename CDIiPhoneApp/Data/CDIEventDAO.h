//
//  CDIEventDAO.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-20.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDIUser.h"
#import "CDIEvent.h"

@interface CDIEventDAO : NSObject

@property (nonatomic, strong) NSNumber * abandoned;
@property (nonatomic, strong) NSString * accessKey;
@property (nonatomic, strong) NSNumber * active;
@property (nonatomic, strong) NSDate * endDate;
@property (nonatomic, strong) NSNumber * endValue;
@property (nonatomic, strong) NSString * eventID;
@property (nonatomic, strong) NSString * eventStoreID;
@property (nonatomic, strong) NSNumber * isPlaceHolder;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * passed;
@property (nonatomic, strong) NSString * relatedInfo;
@property (nonatomic, strong) NSString * relatedDescription;
@property (nonatomic, strong) NSNumber * roomID;
@property (nonatomic, strong) NSDate * startDate;
@property (nonatomic, strong) NSNumber * startValue;
@property (nonatomic, strong) NSDate * updateTime;
@property (nonatomic, strong) CDIUser *creator;
@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic, strong) NSString * previewImageURL;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, retain) NSString * typeOrigin;

@property (nonatomic, readwrite) EventType eventType;

@property (nonatomic, readwrite) BOOL eventJustCreated;

+ (CDIEventDAO *)sharedNewEvent;
+ (void)updateSharedNewEvent:(CDIEventDAO *)event;
+ (id)eventDAOInstanceWithEvent:(CDIEvent *)event;
+ (id)eventInstanceWithTitle:(NSString *)title;
- (id)eventCopy;
- (id)initWithDictionary:(NSDictionary *)dict;

@end
