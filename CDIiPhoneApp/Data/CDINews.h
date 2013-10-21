//
//  CDINews.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-17.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDIUser;

@interface CDINews : NSManagedObject

@property (nonatomic, retain) NSString * newsID;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) CDIUser *creator;

+ (CDINews *)insertNewsInfoWithDict:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)removeAllNewsInManagedObjectContext:(NSManagedObjectContext *)context;
@end
