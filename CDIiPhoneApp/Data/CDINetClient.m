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
#import "CDIUser.h"
#import "CDIEventDAO.h"
#import "NSDate+Addition.h"

#define kBaseURLString @"http://cdi.tongji.edu.cn/cdisoul/"

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
    NSString *path = [NSString stringWithFormat:@"webservice/event/getEventListByRoomIdAndDateAndTypeAndStatus/%d/%@/%@/*/*/100/1", roomID, toDate, fromDate];
    [self getPath:path completion:completion];
}

- (void)getSpecialEventListByCount:(int)count
                        completion:(void (^)(BOOL succeeded, id responseData))completion

{
    NSString *path = [NSString stringWithFormat:@"webservice/event/getNewEvents/%d", count];
    [self getPath:path completion:completion];
}

- (void)getEventListfromDate:(NSString *)fromDate
                      toDate:(NSString *)toDate
                        type:(EventType)type
                  completion:(void (^)(BOOL succeeded, id responseData))completion

{
    NSString *typeString = @"*";
    if (type == EventTypeDiscussion) {
        typeString = @"DISCUSSION";
    } else if (type == EventTypeExhibition) {
        typeString = @"EXHIBITION";
    } else if (type == EventTypeWorkShop) {
        typeString = @"WORKSHOP";
    }
    NSString *path = [NSString stringWithFormat:@"webservice/event/getEventListWithRoomInfoByDateAndTypeAndStatus/%@/%@/%@/*/100/1", fromDate, toDate, typeString];
    [self getPath:path completion:completion];
}

- (void)getDepartmentListByRoomID:(NSInteger)roomID
                           completion:(void(^)(BOOL succeeded, id responseData))completion
{
    NSString *path = [NSString stringWithFormat:@"webservice/department/getDepartmentListByRoomId/%d", roomID];
    [self getPath:path completion:completion];
}

- (void)getReservationListOfUserID:(NSString *)userID withCompletion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSString *fromDate = [NSDate stringOfDateWithIntervalFromCurrentDate:0];
    NSString *toDate = [NSDate stringOfDateWithIntervalFromCurrentDate:3600 * 24 * 2];
    NSString *path = [NSString stringWithFormat:@"webservice/event/getEventListByCreatorIdAndDateAndTypeAndStatus/%@/%@/%@/*/*/10/1", userID, fromDate, toDate];
    [self getPath:path completion:completion];
}

- (void)getRoomInfoByRoomId:(int)roomID
                 completion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSString *path = [NSString stringWithFormat:@"webservice/room/getRoomById/%d", roomID];
    [self getPath:path completion:completion];
}

- (void)getAllRoomInfoCompletion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSString *path = [NSString stringWithFormat:@"webservice/room/getRoomListByStatus/*"];
    [self getPath:path completion:completion];
}

- (void)loginWithUserName:(NSString *)userName
                 passWord:(NSString *)password
               completion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSDictionary *dict = @{@"username" : userName,
                           @"password" : [password md5]};
    [self postPath:@"webservice/user/login" dictionary:dict completion:^(BOOL succeeded, id responseData) {
        if (completion) {
            completion(succeeded, responseData);
        }
    }];
}

- (void)createEvent:(CDIEventDAO *)event
         sessionKey:(NSString *)sessionKey
         completion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSDictionary *dict = @{@"title" : event.name,
                           @"description" : event.relatedInfo,
                           @"relatedInfo" : event.relatedDescription,
                           @"type" : @"DISCUSSION",
                           @"status" : @"INACTIVE",
                           @"startDate" : @(event.startDate.timeIntervalSince1970 * 1000),
                           @"endDate" : @(event.endDate.timeIntervalSince1970 * 1000),
                           @"firstRoomId" : event.roomID};
    NSString *path = [NSString stringWithFormat:@"webservice/event/addEvent/%@", sessionKey];
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
    NSString *path = [NSString stringWithFormat:@"webservice/event/activeEventByEventIdIdAndAccessKey/%@/%@",
                      eventID, accessKey];
    [self getPath:path completion:completion];
}

- (void)unregisterEventWithEventID:(NSString *)eventID
                         accessKey:(NSString *)accessKey
                        completion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSString *path = [NSString stringWithFormat:@"webservice/event/deleteEvent/%@/%@",
                      eventID, accessKey];
    [self deletePath:path dictionary:nil completion:completion];
}

- (void)checkEventCreationLegalWithSessionKey:(NSString *)sessionKey
                                         date:(NSString *)date
                                   completion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSString *path = [NSString stringWithFormat:@"webservice/event/checkIfUserStillCanCreateEventByDate/%@/%@",
                      sessionKey, date];
    [self getPath:path completion:completion];
}

- (void)getUserListWithCompletion:(void (^)(BOOL, id))completion
{
    NSString *path = [NSString stringWithFormat:@"webservice/user/getUserListByCategoryAndPriority/*/*/100/1"];
    [self getPath:path completion:completion];
}

- (void)getUserListWithWorkID:(NSString *)workID
                   completion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSString *path = [NSString stringWithFormat:@"webservice/user/getUserListByWorkId/%@", workID];
    [self getPath:path completion:completion];
}

- (void)getWorkListWithUserID:(NSString *)userID
                   completion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSString *path = [NSString stringWithFormat:@"webservice/work/getWorkListByUserIdAndStatusAndType/%@/*/*/100/1", userID];
    [self getPath:path completion:completion];
}

- (void)getWorkListcompletion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSString *path = [NSString stringWithFormat:@"webservice/work/getWorkListByUserIdAndStatusAndType/*/*/100/1"];
    [self getPath:path completion:completion];
}

- (void)getNewsListWithCompletion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSString *path = [NSString stringWithFormat:@"webservice/news/getNewsList/*/*/1000/1"];
    [self getPath:path completion:completion];
}

- (void)getProjectListWithCompletion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSString *path = [NSString stringWithFormat:@"webservice/work/getWorkListByTypeAndStatus/*/*/1000/1"];
    [self getPath:path completion:completion];
}

- (void)getDeviceListWithCompletion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSString *path = [NSString stringWithFormat:@"webservice/device/getDeviceListByTypeAndStatus/*/*/1000/1"];
    [self getPath:path completion:completion];
}

- (void)getDeviceApplicationListWithCurrentUserID:(NSString *)userID
                                       completion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSString *path = [NSString stringWithFormat:@"webservice/device/getDeviceApplicationListByUserIdAndTypeAndStatus/%@/*/*/1000/1", userID];
    [self getPath:path completion:completion];
}

- (void)getDeviceApplicationListWithDeviceID:(NSString *)deviceID
                                  completion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSString *path = [NSString stringWithFormat:@"webservice/device/getDeviceApplicationListByDeviceIdAndTypeAndStatus/%@/*/*/1000/1", deviceID];
    [self getPath:path completion:completion];
}

- (void)updateUserWithUser:(CDIUser *)user
                  password:(NSString *)password
                completion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSDictionary *dict = @{@"password" : [password md5],
                           @"id" : user.userID,
                           @"name" : user.name,
                           @"avatarSmallUrl" : user.avatarSmallURL,
                           @"avatarMiddleUrl" : user.avatarMidURL,
                           @"avatarLargeUrl" : user.avatarLargeURL,
                           @"realName" : user.realName,
                           @"realName_en" : user.realNameEn,
                           @"title" : user.title,
                           @"title_en" : user.titleEn,
                           @"emailAddress" : user.email,
                           @"mobilePhoneNumber" : user.mobile,
                           @"category" : user.category,
                           @"prority" : user.priority,
                           @"weiboId" : user.weiboURL,
                           @"twitterId" : user.twitterURL,
                           @"linkedInId" : user.linkedInURL,
                           @"dribbbleId" : user.dribbleURL,
                           @"personalSite" : user.homePageURL,
                           @"departmentId" : user.departmentID,
                           @"departmentName" : user.departmentName};
    NSString *path = [NSString stringWithFormat:@"webservice/user/updateUser/%@", user.sessionKey];
    [self putPath:path dictionary:dict completion:completion];
}

- (void)reserveDeviceWithSessionKey:(NSString *)sessionKey
                         borrowDate:(NSDate *)borrowDate
                            dueDate:(NSDate *)dueDate
                             userID:(NSString *)userID
                             workID:(NSString *)workID
                           deviceID:(NSString *)deviceID
                         completion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSDictionary *dict = @{@"userId" : userID,
                           @"workId" : workID,
                           @"deviceId" : deviceID,
                           @"shouldReturnDate" : @(dueDate.timeIntervalSince1970 * 1000),
                           @"borrowDate" : @(borrowDate.timeIntervalSince1970 * 1000)};
    NSString *path = [NSString stringWithFormat:@"webservice/device/applyDevice/%@", sessionKey];
    [self putPath:path dictionary:dict completion:completion];
}

- (void)updateUserAvatarWithImage:(UIImage *)image
                       sessionKey:(NSString *)sessionKey
                       completion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSDictionary *dict = @{@"sessionKey" : sessionKey};
    NSString *path = [NSString stringWithFormat:@"upload/useravatars"];
    [self postPath:path parameters:dict data:UIImageJPEGRepresentation(image, 1) completion:completion];
}

- (void)loginOutCurrentUserWithSessionKey:(NSString *)sessionKey
                               completion:(void (^)(BOOL succeeded, id responseData))completion
{
    NSString *path = [NSString stringWithFormat:@"webservice/user/logout/%@", sessionKey];
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

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
            data:(NSData*)data
      completion:(void (^)(BOOL succeeded, id responseData))completion
{
    BlockARCWeakSelf weakSelf = self;
    [self.afClient postPath:path
                 parameters:parameters
                       data:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    if ([responseData bytes] == 0) {
        if (completion) {
            completion(YES, self.responseData);
        }
        return;
    }
    JSONDecoder *decoder = [JSONDecoder decoder];
    if (responseData) {
        self.responseData = [decoder objectWithData:responseData];
    }
    
    if ([self.responseData isKindOfClass:[NSDictionary class]]) {
        NSString *errorCode = self.responseData[@"errorCode"];
        BOOL succeeded = [@"SUCCEED" isEqualToString:self.responseData[@"callStatus"]];
        if (completion) {
            completion(succeeded, self.responseData);
        }
        if (!succeeded) {
            NSString *errorMessage = [self errorMessageForErrorCode:errorCode];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:errorMessage
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    } else {
        NSString *responseString = [NSString stringWithUTF8String:[responseData bytes]];;
        self.responseData = responseString;
        if (completion) {
            completion(YES, self.responseData);
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
