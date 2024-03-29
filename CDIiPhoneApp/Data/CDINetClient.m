//
//  CDINetClient.m
//  CDI_iPad_App
//
//  Created by Gabriel Yeah on 13-3-30.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CDINetClient.h"
#import "AFHTTPClient.h"
#import "JSONKit.h"
#import "NSString+Encrypt.h"
#import "CDIEvent.h"

#define kBaseURLString @"http://cdi.tongji.edu.cn/cdisoul/webservice/"

static CDINetClient *sharedClient;

@interface CDINetClient ()

@property (nonatomic, strong) AFHTTPClient *afClient;
@property (nonatomic, strong) id responseData;

@end

@implementation CDINetClient

+ (CDINetClient *)client {
  if(!sharedClient) {
    sharedClient = [[CDINetClient alloc] init];
  }
  return sharedClient;
}

#pragma mark - Fetch Data Methods
- (void)getEventListByRoomId:(int)roomID
                    fromDate:(NSString *)fromDate
                      toDate:(NSString *)toDate
                  completion:(void (^)(BOOL succeeded, id responseData))completion

{
  NSString *path = [NSString stringWithFormat:@"event/getEventListByRoomIdAndDateAndTypeAndStatus/%d/%@/%@/*/*/100/1", roomID, toDate, fromDate];
  [self getPath:path completion:completion];
}

- (void)getRoomInfoByRoomId:(int)roomID
                 completion:(void (^)(BOOL succeeded, id responseData))completion
{
  NSString *path = [NSString stringWithFormat:@"room/getRoomById/%d", roomID];
  [self getPath:path completion:completion];
}

- (void)getAllRoomInfoCompletion:(void (^)(BOOL succeeded, id responseData))completion
{
  NSString *path = [NSString stringWithFormat:@"room/getRoomListByStatus/*"];
  [self getPath:path completion:completion];
}

- (void)loginWithUserName:(NSString *)userName
                 passWord:(NSString *)password
               completion:(void (^)(BOOL succeeded, id responseData))completion
{
  NSDictionary *dict = @{@"username" : userName,
                         @"password" : [password md5]};
  [self postPath:@"user/login" dictionary:dict completion:^(BOOL succeeded, id responseData) {
    if (completion) {
      completion(succeeded, responseData);
    }
  }];
}

- (void)createEvent:(CDIEvent *)event
         completion:(void (^)(BOOL succeeded, id responseData))completion
{
  NSDictionary *dict = @{@"title" : event.title,
                         @"relatedInfo" : event.relatedInfo,
                         @"type" : @"DISCUSSION",
                         @"status" : @"INACTIVE",
                         @"startDate" : @(event.startDate.timeIntervalSince1970 * 1000),
                         @"endDate" : @(event.endDate.timeIntervalSince1970 * 1000),
                         @"firstRoomId" : @"1"};
  NSString *path = [NSString stringWithFormat:@"event/addEvent/%@", event.creatorSessionKey];
  [self putPath:path dictionary:dict completion:^(BOOL succeeded, id responseData) {
    if (completion) {
      completion(succeeded, responseData);
    }
  }];
}

- (void)ensureEventWithEventID:(NSString *)eventID
                     accessKey:(NSString *)accessKey
                    completion:(void (^)(BOOL succeeded, id responseData))completion
{
  NSString *path = [NSString stringWithFormat:@"event/activeEventByEventIdIdAndAccessKey/%@/%@",
                                                eventID, accessKey];
  [self getPath:path completion:completion];
}

- (void)unregisterEventWithEventID:(NSString *)eventID
                         accessKey:(NSString *)accessKey
                        completion:(void (^)(BOOL succeeded, id responseData))completion
{
  NSString *path = [NSString stringWithFormat:@"event/deleteEvent/%@/%@",
                    eventID, accessKey];
  [self deletePath:path dictionary:nil completion:completion];
}

- (void)checkEventCreationLegalWithSessionKey:(NSString *)sessionKey
                                         date:(NSString *)date
                                   completion:(void (^)(BOOL succeeded, id responseData))completion
{
  NSString *path = [NSString stringWithFormat:@"event/checkIfUserStillCanCreateEventByDate/%@/%@",
                    sessionKey, date];
  [self getPath:path completion:completion];
}

#pragma mark - Basic Methods
- (void)getPath:(NSString *)path
     completion:(void (^)(BOOL succeeded, id responseData))completion
{
  BlockARCWeakSelf weakSelf = self;
  [self.afClient getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    [weakSelf handleResponseData:responseObject withCompletion:completion];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (completion) {
      completion(NO, nil);
    }
  }];
}

- (void)postPath:(NSString *)path
      dictionary:(NSDictionary *)dict
      completion:(void (^)(BOOL succeeded, id responseData))completion
{
  BlockARCWeakSelf weakSelf = self;
  [self.afClient postPath:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
    [weakSelf handleResponseData:responseObject withCompletion:completion];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (completion) {
      completion(NO, nil);
    }
  }];
}

- (void)putPath:(NSString *)path
     dictionary:(NSDictionary *)dict
     completion:(void (^)(BOOL succeeded, id responseData))completion
{
  BlockARCWeakSelf weakSelf = self;
  [self.afClient putPath:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
    [weakSelf handleResponseData:responseObject withCompletion:completion];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (completion) {
      completion(NO, nil);
    }
  }];
}

- (void)deletePath:(NSString *)path
        dictionary:(NSDictionary *)dict
        completion:(void (^)(BOOL succeeded, id responseData))completion
{
  BlockARCWeakSelf weakSelf = self;
  [self.afClient deletePath:path parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
    [weakSelf handleResponseData:responseObject withCompletion:completion];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (completion) {
      completion(NO, nil);
    }
  }];
}

- (void)handleResponseData:(id)responseData
            withCompletion:(void (^)(BOOL succeeded, id responseData))completion
{
  JSONDecoder *decoder = [JSONDecoder decoder];
  self.responseData = [decoder objectWithData:responseData];
  if ([self.responseData isKindOfClass:[NSDictionary class]]) {
//    NSString *errorCode = self.responseData[@"errorCode"];
    BOOL succeeded = [@"SUCCEED" isEqualToString:self.responseData[@"callStatus"]];
    if (completion) {
      completion(succeeded, self.responseData);
    }
    if (!succeeded) {
//      NSString *errorMessage = [self errorMessageForErrorCode:errorCode];
      //TODO 报错
    }
  }
}

- (NSString *)errorMessageForErrorCode:(NSString *)errorCode
{
  NSString *errorMessage = nil;
  
  if ([errorCode isEqualToString:@"DB_OP_Error"]) {
    errorMessage = @"服务器内部错误";
  } else if ([errorCode isEqualToString:@"Session_Do_Not_Exist"]) {
    errorMessage = @"请重新登录";
  } else if ([errorCode isEqualToString:@"UserName_Do_Not_Exist"]) {
    errorMessage = @"用户名或密码错误";
  } else if ([errorCode isEqualToString:@"Password_Not_Correct"]) {
    errorMessage = @"用户名或密码错误";
  } else {
    errorMessage = @"服务器错误";
  }
  
  return errorMessage;
}

#pragma mark - Properties
- (AFHTTPClient *)afClient
{
  if (!_afClient) {
//    NSURL *baseURL = [NSURL URLWithString:@"http://10.11.48.66/webservice/"];
    NSURL *baseURL = [NSURL URLWithString:kBaseURLString];
    _afClient = [AFHTTPClient clientWithBaseURL:baseURL];
    _afClient.parameterEncoding = AFJSONParameterEncoding;
  }
  return _afClient;
}

@end
