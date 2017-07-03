//
//  ProjectOrderTypeDomain.h
//  自由找
//
//  Created by guojie on 16/8/12.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
#import "UserDomain.h"
@class TakeOrderProductDomain;
@interface ProjectOrderTypeDomain : BaseDomain

/**
 *  //类别编号 客服创建）
 */
@property (strong, nonatomic) NSString *SerialNo;

@property (strong, nonatomic) NSString *AvaliableQuantity;

/**
 *  (保证金
 */
@property (strong, nonatomic) NSString *DepositValue;

@property (strong, nonatomic) NSString *DisplayName;

@property (strong, nonatomic) NSString *DeliveryDt;

@property (strong, nonatomic) NSString *PricePer;

@property (strong, nonatomic) NSString *DeliveryEmail;

/**
 *  优
 */
@property (strong, nonatomic) NSString *QulifyType;
@property (strong, nonatomic) TakeOrderProductDomain *Product;
@property (strong, nonatomic) KeyValueDomain *Region;

@property (assign, nonatomic) NSInteger receiveCount;

@end
@interface TakeOrderProductDomain : BaseDomain
@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) KeyValueDomain *ProductLevel;
@property (strong, nonatomic) KeyValueDomain *ProductType;

@end
