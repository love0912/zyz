//
//  LetterOrderDomain.h
//  zyz
//
//  Created by 郭界 on 16/10/24.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"

@interface LetterOrderDomain : BaseDomain


/**
 产品编号
 */
@property (strong, nonatomic) NSString *SerialNo;

/**
 每份金额
 */
@property (strong, nonatomic) NSString *PerAmount;

/**
 份数
 */
@property (strong, nonatomic) NSString *Quantity;

/**
 总的费用
 */
@property (strong, nonatomic) NSString *PayFee;

/**
 “0”—标准   “1”—自己上传  //保函格式
 */
@property (strong, nonatomic) NSString *BaoHanStyle;

/**
 “1” –费率  “2”—阶梯价    （可以不填写，如果填写，服务端将做检查）
 */
@property (strong, nonatomic) NSString *PayMode;

/**
 “0.4”  “1000”  （可以不填写，如果填写，服务端将做检查）
 */
@property (strong, nonatomic) NSString *PayParameter;

/**
  //如果是费率模式，这里不传
 */
@property (strong, nonatomic) NSString *SegmentId;

/**
 “0”-否  “1”-是
 */
@property (strong, nonatomic) NSString *IsChangeBank;

@property (strong, nonatomic) NSString *Remark;

#pragma mark - 新增属性

/**
 //招标人
 */
@property (strong, nonatomic) NSString *ProjectOwner;

/**
 施工单位
 */
@property (strong, nonatomic) NSString *ProjectCompany;

/**
 项目
 */
@property (strong, nonatomic) NSString *ProjectTitle;


/**
 平台最迟提交保函时间
 */
@property (strong, nonatomic) NSString *MaterialDt;


/**
 快递地址唯一ID
 */
@property (strong, nonatomic) NSString *AddressInfoOId;
@end
