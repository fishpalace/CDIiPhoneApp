//
//  MPDragIndicatorView.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-7.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDragIndicatorViewHeight 50

@class MPDragIndicatorView;

@protocol MPDragIndicatorViewDelegate <NSObject>

- (void)dragIndicatorViewDidStrecth:(MPDragIndicatorView *)view;
- (void)excuteAfterClickDragIndicatorMenuButton;
- (void)excuteAfterClickDragIndicatorRefreshButton;

@end

@interface MPDragIndicatorView : UIView

@property (nonatomic, assign) CGFloat stretchLimitHeight;
@property (nonatomic, assign) BOOL    readyForStretch;
@property (nonatomic, assign) BOOL    isReversed;
@property (strong,nonatomic) UIActivityIndicatorView * waitingView;
@property (nonatomic, weak) id<MPDragIndicatorViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton * menuButton;
@property (weak, nonatomic) IBOutlet UIButton * refreshButton;
@property (weak, nonatomic) IBOutlet UILabel * refreshLabel;
@property (weak, nonatomic) IBOutlet UILabel * menuLabel;

- (void)addMenuAndRefresheLabel;
- (void)drawLineOnTableCellView;
- (void)showMenuAndRefreshButton;
- (void)configureScrollView:(UIScrollView *)scrollView;
- (void)resetPositions;
@end
