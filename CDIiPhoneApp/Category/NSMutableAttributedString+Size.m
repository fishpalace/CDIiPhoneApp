//
//  NSMutableAttributedString+Size.m
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-29.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "NSMutableAttributedString+Size.h"
@import CoreText;

@implementation NSMutableAttributedString (Size)

- (CGFloat)boundingWidthForHeight:(CGFloat)inHeight
{
  CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)self);
  CFRange fitRange;
  CFRange textRange = CFRangeMake(0, self.length);
  
  CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, textRange, NULL, CGSizeMake(CGFLOAT_MAX, inHeight), &fitRange);
  
  CFRelease(framesetter);
  return frameSize.width;
}

- (CGFloat)boundingHeightForWidth:(CGFloat)inWidth
{
  CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)self);
  CFRange fitRange;
  CFRange textRange = CFRangeMake(0, self.length);
  
  CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, textRange, NULL, CGSizeMake(inWidth, CGFLOAT_MAX), &fitRange);
  
  CFRelease(framesetter);
  return frameSize.height;
}

@end
