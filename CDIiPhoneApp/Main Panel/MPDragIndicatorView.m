//
//  MPDragIndicatorView.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-5-7.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "MPDragIndicatorView.h"
#import "UIView+Resize.h"

#define kUpperBarOriginY  20
#define kMiddleBarOriginY 26
#define kLowerBarOriginY  32

@interface MPDragIndicatorView ()

@property (weak, nonatomic) IBOutlet UIImageView *upperBarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *middleBarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lowerBarImageView;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation MPDragIndicatorView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)configureTableView:(UITableView *)tableView
{
  self.tableView = tableView;
  [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
  [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([keyPath isEqualToString:@"contentOffset"]) {
    CGFloat offsetY = self.tableView.contentOffset.y;
    offsetY = offsetY < 0 ? offsetY : 0;

    [self.upperBarImageView resetOriginY:kUpperBarOriginY + offsetY];
    [self.middleBarImageView resetOriginY:kMiddleBarOriginY + offsetY * 2 / 3];
    [self.lowerBarImageView resetOriginY:kLowerBarOriginY + offsetY / 3];
  }
}


@end
