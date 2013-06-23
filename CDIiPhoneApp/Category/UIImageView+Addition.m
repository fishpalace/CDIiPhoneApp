//
//  UIImageViewAddition.m
//  PushBox
//
//  Created by Xie Hasky on 11-7-28.
//  Copyright 2011年 同济大学. All rights reserved.
//

#import "UIImageView+Addition.h"
#import "UIImageView+AFNetworking.h"

@implementation UIImageView (Addition)

- (void)loadImageFromURL:(NSString *)urlString
              completion:(void (^)(BOOL succeeded))completion
{
  NSURL *anImageURL = [NSURL URLWithString:urlString];
  BlockARCWeakSelf weakSelf = self;
  [self setImageWithURLRequest:[NSURLRequest requestWithURL:anImageURL] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    weakSelf.image = image;
    if (completion) {
      completion(YES);
    }
  } failure:nil];
}

@end
