//
//  RPActivityIndictor.m
//  CDIiPhoneApp
//
//  Created by Emerson on 13-10-18.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "RPActivityIndictor.h"

static RPActivityIndictor *sharedRPActivityIndictor;

@implementation RPActivityIndictor
{
    NSTimer * waitingTimer;
    float waitingTime;
    BOOL isOverTime;
}

+ (RPActivityIndictor *)sharedRPActivityIndictor
{
    if (!sharedRPActivityIndictor) {
        sharedRPActivityIndictor = [[RPActivityIndictor alloc]init];
    }
    return sharedRPActivityIndictor;
}

- (void)resetBasicData
{
    waitingTime = 0.0;
    isOverTime = NO;
}

- (void)startWaitingAnimationInView:(UIView *)view
{
    _waitingView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width / 2 - 32.0,
                                                                            [[UIScreen mainScreen]bounds].size.height / 2 - 32.0,
                                                                            64.0,
                                                                            64.0)];
    _waitingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    _waitingView.hidesWhenStopped = YES;
    _waitingView.backgroundColor = [UIColor blackColor];
    _waitingView.layer.cornerRadius = 6;
    _waitingView.layer.masksToBounds = YES;
    [view addSubview:_waitingView];
    [_waitingView startAnimating];
}

- (void)setWaitingTimer
{
    waitingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(overTime:) userInfo:nil repeats:YES];
}

- (void)stopWaitingTimer
{
    [_waitingView stopAnimating];
    [waitingTimer invalidate];
}

- (void)overTime:(NSTimer*)timer
{
    waitingTime += 1.0;
    if (waitingTime >= 10) {
        waitingTime = 0.0;
        isOverTime = YES;
        [timer invalidate];
        [_waitingView stopAnimating];
        [self.delegate someThingAfterActivityIndicatorOverTimer];
    }
}

- (void)excuteFailedinNotOverTimeStiution
{
    if (!isOverTime) {
        [self.delegate someThingAfterActivityIndicatorOverTimer];
    }
}

@end
