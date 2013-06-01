//
//  MPDragIndicatorView.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-7.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDragIndicatorViewHeight 32

@class MPDragIndicatorView;

@protocol MPDragIndicatorViewDelegate <NSObject>

- (void)dragIndicatorViewDidStrecth:(MPDragIndicatorView *)view;

@end

@interface MPDragIndicatorView : UIView

@property (nonatomic, assign) CGFloat stretchLimitHeight;
@property (nonatomic, assign) BOOL    readyForStretch;
@property (nonatomic, assign) BOOL    isReversed;
@property (nonatomic, weak) id<MPDragIndicatorViewDelegate> delegate;

- (void)configureScrollView:(UIScrollView *)scrollView;

@end
