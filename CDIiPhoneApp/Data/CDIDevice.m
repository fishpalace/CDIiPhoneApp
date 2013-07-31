//
//  CDIDevice.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-31.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CDIDevice.h"
#import "NSString+Dictionary.h"

@implementation CDIDevice

@dynamic deviceID;
@dynamic deviceName;
@dynamic deviceType;
@dynamic deviceStatus;
@dynamic available;

+ (CDIDevice *)insertDeviceInfoWithDict:(NSDictionary *)dict inManagedObjectContext:(NSManagedObjectContext *)context
{
  if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  NSString *deviceID = [NSString stringForDict:dict key:@"id"];
  
  if (!deviceID || [deviceID isEqualToString:@""]) {
    return nil;
  }
  
  CDIDevice *device = [CDIDevice deviceWithID:deviceID inManagedObjectContext:context];
  if (!device) {
    device = [NSEntityDescription insertNewObjectForEntityForName:@"CDIDevice" inManagedObjectContext:context];
  }
  
  device.deviceID = deviceID;
  device.deviceName = [NSString stringForDict:dict key:@"name"];
  NSString *status = [NSString stringForDict:dict key:@"status"];
  BOOL available = [status isEqualToString:@"AVALIABLE"];
  if (available) {
    device.deviceStatus = @"Available";
  } else if ([status isEqualToString:@"UNAVAILABLE"]) {
    device.deviceStatus = @"Unavailable";
  }
  device.available = @(available);
  
  NSString *deviceType = [NSString stringForDict:dict key:@"type"];
  if ([deviceType isEqualToString:@"DESKTOP_COMPUTER"]) {
    device.deviceType = @"Desktop Computer";
  } else if ([deviceType isEqualToString:@"LAPTOP"]) {
    device.deviceType = @"Laptop";
  } else if ([deviceType isEqualToString:@"MOBILE_DEVICE"]) {
    device.deviceType = @"Mobile Device";
  } else if ([deviceType isEqualToString:@"ELECTRONIC_COMPONENT"]) {
    device.deviceType = @"Electronic Component";
  } else if ([deviceType isEqualToString:@"ACCESSORY"]) {
    device.deviceType = @"Accessory";
  } else if ([deviceType isEqualToString:@"OTHER"]) {
    device.deviceType = @"Other";
  }
  
  return device;
}

+ (CDIDevice *)deviceWithID:(NSString *)newsID inManagedObjectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  
  [request setEntity:[NSEntityDescription entityForName:@"CDIDevice" inManagedObjectContext:context]];
  [request setPredicate:[NSPredicate predicateWithFormat:@"deviceID == %@ ", newsID]];
  
  NSArray *items = [context executeFetchRequest:request error:NULL];
  CDIDevice *res = [items lastObject];
  
  return res;
}

@end
