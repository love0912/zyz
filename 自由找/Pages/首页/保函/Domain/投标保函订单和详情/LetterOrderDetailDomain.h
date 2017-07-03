//
//  LetterOrderDetailDomain.h
//  zyz
//
//  Created by 郭界 on 16/10/25.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
#import "OrderInfoDomain.h"
#import "UserDomain.h"

@class Tracking;

@interface LetterOrderDetailDomain : BaseDomain


/**
 //订单编号
 */
@property (strong, nonatomic) NSString *OrderNo;

/**
 <#Description#>
 */
@property (strong, nonatomic) NSString *ProjectName;

/**
 <#Description#>
 */
@property (strong, nonatomic) NSString *ProductName;

/**
 * 1 待付款， 6 待上传资料 , 2处理中，3取消(后台动作) ， 4执行中，5完成
 */
@property (strong, nonatomic) NSString *Status;

/**
 “1” –费率  “2”—阶梯价
 */
@property (strong, nonatomic) NSString *PayMode;

/**
 “0.4”  “1000
 */
@property (strong, nonatomic) NSString *PayParameter;

/**
 */
@property (strong, nonatomic) NSString *Quantity;


/**
 保函金额
 */
@property (strong, nonatomic) NSString *PerAmount;

/**
 /总的费用
 */
@property (strong, nonatomic) NSString *PayFee;

/**
 <#Description#>
 */
@property (strong, nonatomic) NSString *LogoUrl;

/**
 背景图url
 */
@property (strong, nonatomic) NSString *LogoBackgroundUrl;

/**
 区域
 */
@property (strong, nonatomic) KeyValueDomain *Region;

/**
 银行分行名称
 */
@property (strong, nonatomic) NSString *SubBank;

/**
  { Phone:  Name :   } (此处联系人为客服人员，使用自由找头像)
 */
@property (strong, nonatomic) ContactInfo *ContactInfo;

/**
 (客服取消原因)
 */
@property (strong, nonatomic) NSString *CancelRemark;


/**
  { No: ““  Carrier: “EMS”  }  //status = ‘完成’后可以查看快递信息
 */
@property (strong, nonatomic) Tracking *Tracking;

/**
 “1” 已经评价
 */
@property (strong, nonatomic) NSString *IsRecommend;

/**
 “1” –技术  2-预算  3—投标保函
 */
@property (strong, nonatomic) NSString *ProductType;


@property (strong, nonatomic) NSString *IsChangeBank;

/**
 “0”—标准   “1”—自己上传  //保函格式
 */
@property (strong, nonatomic) NSString *BaoHanStyle;

/**
 招标人单位名称
 */
@property (strong, nonatomic) NSString *ProjectOwner;

/**
 施工企业名称
 */
@property (strong, nonatomic) NSString *ProjectCompany;

/**
 项目名称
 */
@property (strong, nonatomic) NSString *ProjectTitle;

/**
 图片的url
 */
@property (strong, nonatomic) NSArray *MaterialList;

/**
 备注
 */
@property (strong, nonatomic) NSString *Remark;


/**
 自由找最迟提交保函时间
 */
@property (strong, nonatomic) NSString *MaterialDt;


/**
 地址信息
 */
@property (strong, nonatomic) NSDictionary *AddressInfo;

@end

@interface Tracking : BaseDomain

@property (strong, nonatomic) NSString *No;

@property (strong, nonatomic) NSString *Carrier;

@end
