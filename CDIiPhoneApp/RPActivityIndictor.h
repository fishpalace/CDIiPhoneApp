//
//  RPActivityIndictor.h
//  CDIiPhoneApp
//
//  Created by Emerson on 13-10-18.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RPActivityIndictorDelegate <NSObject>

- (void)someThingAfterActivityIndicatorOverTimer;

@end

@interface RPActivityIndictor : NSObject

@property (strong,nonatomic) UIActivityIndicatorView * waitingView;
@property (nonatomic,weak) id<RPActivityIndictorDelegate> delegate;

+ (RPActivityIndictor *)sharedRPActivityIndictor;
- (void)resetBasicData;
- (void)startWaitingAnimationInView:(UIView *)view;
- (void)setWaitingTimer;
- (void)stopWaitingTimer;
- (void)overTime:(NSTimer*)timer;
- (void)excuteFailedinNotOverTimeStiution;
@end
