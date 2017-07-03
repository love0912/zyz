//
//  LetterCompanyDomain.h
//  zyz
//
//  Created by 郭界 on 17/1/12.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "BaseDomain.h"

@interface LetterCompanyDomain : BaseDomain

@property (strong, nonatomic) NSString *OId;

@property (strong, nonatomic) NSString *Name;


/**
 产品名称
 */
@property (strong, nonatomic) NSString *MainBiz;

/**
 经营类别
 */
@property (strong, nonatomic) NSDictionary *BusinessCategory;

/**
 重庆市
 */
@property (strong, nonatomic) NSString *RegionTitle;

/**
 金额
 */
@property (strong, nonatomic) NSString *LimitPrice;

/**
 费率
 */
@property (strong, nonatomic) NSString *FeeValue;

/**
 经营范围
 */
@property (strong, nonatomic) NSString *Scope;

/**
 联系人
 */
@property (strong, nonatomic) NSString *Contact;

@property (strong, nonatomic) NSString *Phone;

@property (strong, nonatomic) NSString *Address;

@property (strong, nonatomic) NSString *Url;

@property (strong, nonatomic) NSString *ShareUrl;

@property (strong, nonatomic) NSString *Description;

@property (strong, nonatomic) NSString *ImgUrls;


@end
