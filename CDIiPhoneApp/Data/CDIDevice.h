//
//  CDIDevice.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-31.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDIDevice : NSManagedObject

@property (nonatomic, retain) NSString * deviceID;
@property (nonatomic, retain) NSString * deviceName;
@property (nonatomic, retain) NSString * deviceType;
@property (nonatomic, retain) NSString * deviceStatus;
@property (nonatomic, retain) NSNumber * available;

+ (CDIDevice *)insertDeviceInfoWithDict:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context;

@end
