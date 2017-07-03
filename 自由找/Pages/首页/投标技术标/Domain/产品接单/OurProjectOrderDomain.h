//
//  OurProjectOrderDomain.h
//  自由找
//
//  Created by guojie on 16/8/12.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
#import "UserDomain.h"
@class PublisherDomain;
@class WalletRecordDomain;
@interface OurProjectOrderDomain : BaseDomain

/**
 *  (项目序号)
 */
@property (strong, nonatomic) NSString *SerialNo;

/**
 *  (来源项目，，有客服填写
 */
@property (strong, nonatomic) NSString *ProjectTitle;

@property (strong, nonatomic) KeyValueDomain *ProjectType;

@property (strong, nonatomic) NSString *DeliveryDt;

@property (strong, nonatomic) PublisherDomain *Publisher;

/**
 *  是否有新的补遗   1  有  0 无
 */
@property (strong, nonatomic) NSString *IsNewAdditional;

/**
 *  新的未读消息   1  有  0 无
 */
@property (strong, nonatomic) NSString *IsNewMsg;
@property (strong, nonatomic) NSString *Url;
@property (strong, nonatomic) WalletRecordDomain *WalletRecord;

/**
 *  1 -- 技术标, 2 -- 预算
 */
@property (strong, nonatomic) NSString *ProductType;

/**
 *  接单数量
 */
@property (strong, nonatomic) NSString *Quantity;

@property (strong, nonatomic) NSString *ProjectName;

@property (strong, nonatomic) NSString *ProjectCode;

@property (strong, nonatomic) KeyValueDomain *ProjectRegion;

@property (strong, nonatomic) NSString *ProjectMaterial;

@property (strong, nonatomic) NSString *MaterialAccessCode;

@property (strong, nonatomic) NSString *Phone;

@property (strong, nonatomic) NSString *QQ;

@property (strong, nonatomic) NSString *WeChat;

//我接单的类别
@property (strong, nonatomic) NSString *TakeOrderSnapData;


@end





@interface PublisherDomain : BaseDomain

/**
 *  手机号码
 */
@property (strong, nonatomic) NSString *Contact1;

/**
 *  聊天ID
 */
@property (strong, nonatomic) NSString *Contact2;
@end
@interface WalletRecordDomain : BaseDomain

/**
 *   //3 --扣费      5--收款
 */
@property (strong, nonatomic) NSString *RecordType;

/**
 *  Amount金额
 */
@property (strong, nonatomic) NSString *Amount;

/**
 *  说明
 */
@property (strong, nonatomic) NSString *Description;
/**
 *  说明
 */
@property (strong, nonatomic) NSString *CreateDt;
@end
