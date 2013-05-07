//
//  MPDragIndicatorView.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-7.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPDragIndicatorView;

@protocol MPDragIndicatorViewDelegate <NSObject>

- (void)dragIndicatorViewDidStrecth:(MPDragIndicatorView *)view;

@end

@interface MPDragIndicatorView : UIView

@property (nonatomic, assign) CGFloat stretchLimitHeight;
@property (nonatomic, assign) BOOL    readyForStretch;
@property (nonatomic, weak) id<MPDragIndicatorViewDelegate> delegate;

- (void)configureTableView:(UITableView *)tableView;

@end
