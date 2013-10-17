//
//  NewsDetailViewController.h
//  CDIiPhoneApp
//
//  Created by Gabriel Yeah on 13-7-29.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import "CoreDataViewController.h"

@class CDINews;

@interface NewsDetailViewController : CoreDataViewController<UIScrollViewDelegate>

@property (nonatomic, weak) CDINews *news;

@end
