//
//  AttentionUserList.h
//  自由找
//
//  Created by guojie on 16/6/23.
//  Copyright © 2016年 zyz. All rights reserved.
//  查看我的发布里关注用户列表返回数据

#import "BaseDomain.h"
@class CountDomain;
@class AttentionUserDomain;

@interface AttentionUserList : BaseDomain

@property (strong, nonatomic) CountDomain *Count;

@property (strong, nonatomic) NSArray <AttentionUserDomain *> *Items;

@end

@interface CountDomain : BaseDomain

@property (strong, nonatomic) NSString *CountStop;

@property (strong, nonatomic) NSString *CountAgree;

@property (strong, nonatomic) NSString *CountDisAgree;

@property (strong, nonatomic) NSString *CountLastest;

@end

@interface AttentionUserDomain : BaseDomain

@property (strong, nonatomic) NSString *ProjectId;

/**
 *  关注id
 */
@property (strong, nonatomic) NSString *AttentionId;

@property (strong, nonatomic) NSString *CompanyName;

@property (strong, nonatomic) NSString *Phone;

@property (strong, nonatomic) NSString *Contact;

@property (strong, nonatomic) NSString *Credit;

/**
 *  评价，Null为未评价
 */
@property (strong, nonatomic) NSString *PublishRank;

/**
 *  0/1/2/4/8   不同意 ，同意 ，最新，撤回/退回
 */
@property (assign, nonatomic) NSInteger Marker;

@property (strong, nonatomic) NSString *Url;

@end