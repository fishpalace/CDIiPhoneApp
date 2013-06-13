//
//  Event.h
//  CDI_iPad_App
//
//  Created by Gabriel Yeah on 13-3-30.
//  Copyright (c) 2013年 Gabriel Yeah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDIEvent : NSObject

@property (nonatomic, strong) NSString  *eventID;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *relatedInfo;
@property (nonatomic, strong) NSDate  *startDate;
@property (nonatomic, strong) NSDate  *endDate;
@property (nonatomic, assign) BOOL    active;
@property (nonatomic, assign) BOOL    passed;
@property (nonatomic, assign) BOOL    isPlaceHolder;
@property (nonatomic, assign) BOOL    abandoned;
@property (nonatomic, assign) NSInteger startValue;
@property (nonatomic, assign) NSInteger endValue;
@property (nonatomic, strong) NSString *creatorSessionKey;
@property (nonatomic, strong) NSString *accessKey;
@property (nonatomic, assign) NSInteger roomID;

+ (CDIEvent *)sharedNewEvent;
+ (void)updateSharedNewEvent:(CDIEvent *)event;
+ (id)eventInstanceWithTitle:(NSString *)title;
- (id)eventCopy;
- (id)initWithDictionary:(NSDictionary *)dict;

//private Long id;
//private String name;
//private String name_en;
//
//private WorkStatusEnum status;
//private WorkTypeEnum type;
//
//private String imageUrl;
//private String videoUrl;
//private String linkUrl;
//
//private Long creatorId;
//
//private Date startDate;
//private Date estimatedEndDate;
//private Date endDate;
//
//private String description;
//private String description_en;
//
////----------------------------------
//private String previewImageUrl;

@end
