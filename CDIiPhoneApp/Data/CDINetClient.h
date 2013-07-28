//
//  CDINetClient.h
//  CDI_iPad_App
//
//  Created by Gabriel Yeah on 13-3-30.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDIEventDAO;

@interface CDINetClient : NSObject

+ (CDINetClient *)client;

- (void)loginWithUserName:(NSString *)userName
                 passWord:(NSString *)password
               completion:(void (^)(BOOL succeeded, id responseData))completion;

- (void)getEventListByRoomId:(int)roomID
                    fromDate:(NSString *)fromDate
                      toDate:(NSString *)toDate
                  completion:(void (^)(BOOL succeeded, id responseData))completion;

- (void)getEventListfromDate:(NSString *)fromDate
                      toDate:(NSString *)toDate
                  completion:(void (^)(BOOL succeeded, id responseData))completion;

- (void)getRoomInfoByRoomId:(int)roomID
                 completion:(void (^)(BOOL succeeded, id responseData))completion;

- (void)getAllRoomInfoCompletion:(void (^)(BOOL succeeded, id responseData))completion;

- (void)createEvent:(CDIEventDAO *)event
         sessionKey:(NSString *)sessionKey
         completion:(void (^)(BOOL succeeded, id responseData))completion;

- (void)ensureEventWithEventID:(NSString *)eventID
                     accessKey:(NSString *)accessKey
                    completion:(void (^)(BOOL succeeded, id responseData))completion;

- (void)unregisterEventWithEventID:(NSString *)eventID
                         accessKey:(NSString *)accessKey
                        completion:(void (^)(BOOL succeeded, id responseData))completion;

- (void)checkEventCreationLegalWithSessionKey:(NSString *)sessionKey
                                         date:(NSString *)date
                                   completion:(void (^)(BOOL succeeded, id responseData))completion;

- (void)getUserListWithCompletion:(void (^)(BOOL succeeded, id responseData))completion;

- (void)getWorkListWithUserID:(NSString *)userID
                   completion:(void (^)(BOOL succeeded, id responseData))completion;


- (void)loginOutCurrentUserWithID:(NSString *)userID
                       completion:(void (^)(BOOL succeeded, id responseData))completion;

@end
