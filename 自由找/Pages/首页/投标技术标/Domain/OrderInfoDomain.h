//
//  OrderInfoDomain.h
//  自由找
//
//  Created by guojie on 16/8/10.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
@class ContactInfo, DownloadInfo;


@interface OrderInfoDomain : BaseDomain

/**
 *  订单编号
 */
@property (strong, nonatomic) NSString *SerialNo;

#pragma mark - 用于生成订单的返回

/**
 *  订单金额
 */
@property (strong, nonatomic) NSString *POAmount;

/**
 *  优惠券金额
 */
@property (strong, nonatomic) NSString *CouponAmount;


#pragma mark - 用于订单详情

/**
 *  产品名称
 */
@property (strong, nonatomic) NSString *ProductName;

/**
 *  项目名称
 */
@property (strong, nonatomic) NSString *ProjectName;

/**
 *  订单状态 -- ： 1 待付款， 2处理中，3取消(后台动作) ， 4执行中，5完成 （完成后下载，完成后扣钱
 */
@property (strong, nonatomic) NSString *Status;

/**
 *  退款状态 -- 0 –默认，1申请退款中， 2退款失败，3退款成功
 */
@property (strong, nonatomic) NSString *RefundStatus;

/**
 *  退款时间
 */
@property (strong, nonatomic) NSString *RefundDt;


/**
 *  描述
 */
@property (strong, nonatomic) NSString *ProductDescription;

/**
 *  购买单价
 */
@property (strong, nonatomic) NSString *Price;

/**
 *  数量
 */
@property (strong, nonatomic) NSString *Quantity;

/**
 *  产品图标
 */
@property (strong, nonatomic) NSString *LogoUrl;

/**
 *  负责人联系方式
 */
@property (strong, nonatomic) ContactInfo *ContactInfo;

/**
 *  下载信息
 */
@property (strong, nonatomic) DownloadInfo *DownLoad;


@end

@interface ContactInfo : BaseDomain

@property (strong, nonatomic) NSString *Phone;

@property (strong, nonatomic) NSString *Name;

@end
@implementation ContactInfo
@end

@interface DownloadInfo : BaseDomain

@property (strong, nonatomic) NSString *Url;

/**
 *  提取码
 */
@property (strong, nonatomic) NSString *AccessCode;

@end
