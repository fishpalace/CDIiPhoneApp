//
//  CDIApplication.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-31.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDIApplication : NSManagedObject

@property (nonatomic, retain) NSString * deviceID;
@property (nonatomic, retain) NSString * applicationInfo;
@property (nonatomic, retain) NSString * deviceStatus;
@property (nonatomic, retain) NSDate * borrowDate;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSDate * returnDate;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * projectID;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * projectName;
@property (nonatomic, retain) NSString * deviceName;
@property (nonatomic, retain) NSString * userRealName;

@end
