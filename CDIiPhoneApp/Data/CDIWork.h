//
//  CDIWork.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-17.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDIUser;

@interface CDIWork : NSManagedObject

@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSDate * estimatedEndDate;
@property (nonatomic, retain) NSString * imgURL;
@property (nonatomic, retain) NSString * linkURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nameEn;
@property (nonatomic, retain) NSString * previewImageURL;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * videoURL;
@property (nonatomic, retain) NSString * workInfo;
@property (nonatomic, retain) NSString * workInfoEn;
@property (nonatomic, retain) NSString * workStatus;
@property (nonatomic, retain) NSString * workType;
@property (nonatomic, retain) CDIUser *creator;
@property (nonatomic, retain) NSSet *involvedUser;
@end

@interface CDIWork (CoreDataGeneratedAccessors)

- (void)addInvolvedUserObject:(CDIUser *)value;
- (void)removeInvolvedUserObject:(CDIUser *)value;
- (void)addInvolvedUser:(NSSet *)values;
- (void)removeInvolvedUser:(NSSet *)values;

@end
