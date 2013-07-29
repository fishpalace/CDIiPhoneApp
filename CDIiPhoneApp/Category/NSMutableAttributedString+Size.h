//
//  NSMutableAttributedString+Size.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-29.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Size)

- (CGFloat)boundingWidthForHeight:(CGFloat)inHeight;

- (CGFloat)boundingHeightForWidth:(CGFloat)inWidth;

@end
