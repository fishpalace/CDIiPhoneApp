//
//  CDIEvent.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-20.
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
@property (nonatomic, retain) NSString * eventStoreID;
@property (nonatomic, retain) NSNumber * isPlaceHolder;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * passed;
@property (nonatomic, retain) NSString * relatedInfo;
@property (nonatomic, retain) NSString * relatedDescription;
@property (nonatomic, retain) NSNumber * roomID;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * startValue;
@property (nonatomic, retain) NSNumber * occupiedByA;
@property (nonatomic, retain) NSNumber * occupiedByB;
@property (nonatomic, retain) NSNumber * occupiedByC;
@property (nonatomic, retain) NSNumber * occupiedByD;
@property (nonatomic, retain) NSDate * updateTime;
@property (nonatomic, retain) CDIUser *creator;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * previewImageURL;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * typeOrigin;


@property (nonatomic, readwrite) EventType eventType;

+ (CDIEvent *)sharedNewEvent;
+ (id)eventInstanceWithTitle:(NSString *)title;
- (id)eventCopy;
- (id)initWithDictionary:(NSDictionary *)dict;
+ (CDIEvent *)insertUserInfoWithDict:(NSDictionary *)dict
                          updateTime:(NSDate *)updateTime
              inManagedObjectContext:(NSManagedObjectContext *)context;
+ (CDIEvent *)eventWithID:(NSString *)eventID inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)updateEventStoreID:(NSString *)eventStoreID
            forEventWithID:(NSString *)eventID
    inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)removeEventsOlderThanUpdateDate:(NSDate *)updateDate
                 inManagedObjectContext:(NSManagedObjectContext *)context;

+ (void)removeAllEventInManagedObjectContext:(NSManagedObjectContext *)context;

@end
