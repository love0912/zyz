//
//  ProjectOrderDomain.h
//  自由找
//
//  Created by guojie on 16/8/12.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
#import "UserDomain.h"

@interface ProjectOrderDomain : BaseDomain

/**
 *  用于收藏
 */
@property (strong, nonatomic) NSString *SummaryId;

/**
 *  (项目序号)
 */
@property (strong, nonatomic) NSString *SerialNo;

/**
 *  (来源项目，，有客服填写
 */
@property (strong, nonatomic) NSString *ProjectTitle;

@property (strong, nonatomic) KeyValueDomain *ProjectType;

@property (strong, nonatomic) NSString *MinSalesPrice;

@property (strong, nonatomic) NSString *MaxSalesPrice;

@property (strong, nonatomic) NSString *StartDeliveryDt;

@property (strong, nonatomic) NSString *EndDeliveryDt;

@property (strong, nonatomic)NSString *IsFavorited;
/**
 *  1满员  0 不满员
 */
@property (strong, nonatomic) NSString *IsLimited;

@property (strong, nonatomic) NSString *Url;

/**
 *  订单类别 1--技术, 2--预算
 */
@property (strong, nonatomic) NSString *ProductType;

@property (strong, nonatomic) NSString *ProjectName;

@property (strong, nonatomic) NSString *ProjectCode;

@property (strong, nonatomic) KeyValueDomain *ProjectRegion;

@property (strong, nonatomic) NSString *ProjectMaterial;

@property (strong, nonatomic) NSString *MaterialAccessCode;

@property (strong, nonatomic) NSString *Phone;

@property (strong, nonatomic) NSString *QQ;

@property (strong, nonatomic) NSString *WeChat;

@end
