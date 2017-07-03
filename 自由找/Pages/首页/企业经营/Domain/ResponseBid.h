//
//  ResponseBid.h
//  自由找
//
//  Created by guojie on 16/6/22.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
@class BidListDomain;

@interface ResponseBid : BaseDomain

@property (strong, nonatomic) NSString *RegionKey;

@property (strong, nonatomic) NSArray<BidListDomain *> *Items;

@end

@interface BidListDomain : BaseDomain

@property (strong, nonatomic) NSString *ProjectId;

@property (strong, nonatomic) NSString *ProjectNo;

@property (strong, nonatomic) NSString *ProjectName;

@property (strong, nonatomic) NSString *CreateDate;

@property (strong, nonatomic) NSString *Deadline;

@property (strong, nonatomic) NSString *Url;

@property (strong, nonatomic) NSDictionary *Region;

@property (strong, nonatomic) NSString *RegionValue;

/**
 *  0 ---  已报名  1 ---可以报名
 */
@property (assign, nonatomic) NSInteger IsCanEnroll;

/**
 *  0 --不公开   1--公开
 */
@property (assign, nonatomic) NSInteger IsOpenPhone;

/**
 *  0 --过期   1 有效 （未过期）
 */
@property (assign, nonatomic) NSInteger IsActived;

/**
 *  项目发布者ID。
 */
@property (strong, nonatomic) NSString *Tenderee;

/**
 *  新增报名用户未读数.
 */
@property (assign, nonatomic) NSInteger SignUpUnread;

/**
 *  null/”0”/”1”    /不是自己发布的/自己发布的
 */
@property (nonatomic, strong) NSString *IsSelfPublished;

@end