//
//  CDIRoom.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-6-17.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDIRoom : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * roomID;
@property (nonatomic, retain) NSString * roomInfo;

@end
