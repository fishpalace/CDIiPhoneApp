//
//  CDIUser.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-17.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDIEvent, CDINews, CDIWork;

@interface CDIUser : NSManagedObject

@property (nonatomic, retain) NSString * avatarLargeURL;
@property (nonatomic, retain) NSString * avatarMidURL;
@property (nonatomic, retain) NSString * avatarSmallURL;
@property (nonatomic, retain) NSString * dribbleURL;
@property (nonatomic, retain) NSString * homePageURL;
@property (nonatomic, retain) NSString * linkedInURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * realName;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * twitterURL;
@property (nonatomic, retain) NSString * weiboURL;
@property (nonatomic, retain) NSString * sessionKey;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *news;
@property (nonatomic, retain) NSSet *relatedWork;
@property (nonatomic, retain) NSSet *work;

+ (CDIUser *)currentUser;
+ (void)updateCurrentUserWithDictionary:(NSDictionary *)dict
                             sessionKey:(NSString *)sessionKey;
- (id)initWithName:(NSString *)name title:(NSString *)title position:(NSString *)position;
+ (CDIUser *)insertUserInfoWithDict:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;

@end

@interface CDIUser (CoreDataGeneratedAccessors)

- (void)addEventsObject:(CDIEvent *)value;
- (void)removeEventsObject:(CDIEvent *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addNewsObject:(CDINews *)value;
- (void)removeNewsObject:(CDINews *)value;
- (void)addNews:(NSSet *)values;
- (void)removeNews:(NSSet *)values;

- (void)addRelatedWorkObject:(CDIWork *)value;
- (void)removeRelatedWorkObject:(CDIWork *)value;
- (void)addRelatedWork:(NSSet *)values;
- (void)removeRelatedWork:(NSSet *)values;

- (void)addWorkObject:(CDIWork *)value;
- (void)removeWorkObject:(CDIWork *)value;
- (void)addWork:(NSSet *)values;
- (void)removeWork:(NSSet *)values;

@end
