//
//  AttentionBidDomain.h
//  自由找
//
//  Created by guojie on 16/6/23.
//  Copyright © 2016年 zyz. All rights reserved.
//
//我的报名--招投标
#import "BaseDomain.h"

@interface AttentionBidDomain : BaseDomain

@property (strong, nonatomic) NSString *AttentionId;

@property (strong, nonatomic) NSString *ProjectId;

@property (strong, nonatomic) NSString *RegionName;

@property (strong, nonatomic) NSString *ProjectNo;

@property (strong, nonatomic) NSString *ProjectName;

@property (strong, nonatomic) NSString *CreateDate;

/**
 *  0/1   0 等待沟通  1 已沟通
 */
@property (assign, nonatomic) NSInteger CMarker;

/**
 *  （int） 1 公开， 0 不公开
 */
@property (assign, nonatomic) NSInteger IsOpenPhone;

@property (strong, nonatomic) NSString *Phone;

/**
 *   1/2/4，进行中/已完成/已退撤回
 */
@property (assign, nonatomic) NSInteger Status;
/**
 *  “已退回”/已撤回”
 */
@property (strong, nonatomic) NSString *StatusDesc;

@property (strong, nonatomic) NSString *Url;

/**
 *  评分，未评分为null
 */
@property (strong, nonatomic) NSString *ApplyRank;

@end
