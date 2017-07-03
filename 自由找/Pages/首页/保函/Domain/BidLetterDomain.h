//
//  BidLetterDomain.h
//  自由找
//
//  Created by 郭界 on 16/9/27.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
#import "UserDomain.h"

@interface BidLetterDomain : BaseDomain


/**
 产品编号
 */
@property (strong, nonatomic) NSString *SerialNo;

@property (strong, nonatomic) NSString *Name;

@property (strong, nonatomic) NSString *CategoryName;

@property (strong, nonatomic) NSString *Bank;

/**
 石家庄分行
 */
@property (strong, nonatomic) NSString *SubBank;

@property (strong, nonatomic) NSString *Description;

@property (strong, nonatomic) NSString *Remark;

@property (strong, nonatomic) NSString *Phone;

@property (strong, nonatomic) NSString *LogoUrl;

@property (strong, nonatomic) NSString *Url;


/**
 “1” –费率  “2”—阶梯价
 */
@property (strong, nonatomic) NSString *PayMode;

/**
 是否推荐 1(是), 0
 */
@property (strong, nonatomic) NSString *IsRecommented;


/**
 “0.4”  “1000”
 */
@property (strong, nonatomic) NSString *PayParameter;
@property (strong, nonatomic) NSString *PayParameterMax;


/**
 原费率，原价
 */
@property (strong, nonatomic) NSString *PayParameterOrginal;


/**
 月售100笔
 */
@property (strong, nonatomic) NSString *PerSalesCount;


/**
 费率的保底价格
 */
@property (strong, nonatomic) NSString *SafePayParameter;


/**
 区域
 */
@property (strong, nonatomic) KeyValueDomain *Region;


/**
 描述数组，最多三条
 */
@property (strong, nonatomic) NSArray *SummaryLines;

/**
 描述数组，新版 -- 返回的是对象
 */
//@property (strong, nonatomic) NSArray *SummaryLines_1;

/**
 描述数组，新版 -- 返回的是对象
 */
@property (strong, nonatomic) NSArray *SummaryLines_2;

/**
 背景图url
 */
@property (strong, nonatomic) NSString *LogoBackgroundUrl;


/**
 今日特价
 */
@property (strong, nonatomic) NSString *BizDescription;


/**
 网页里面的保函图片
 */
@property (strong, nonatomic) NSString *NormalUrl;


@end
