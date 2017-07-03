//
//  ProductDomain.h
//  自由找
//
//  Created by guojie on 16/8/10.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"

@interface ProductDomain : BaseDomain

@property (strong, nonatomic) NSString *SerialNo;

@property (strong, nonatomic) NSString *Name;

@property (strong, nonatomic) NSString *Description;

@property (strong, nonatomic) NSString *StandardPrice;

@property (strong, nonatomic) NSString *DiscountPrice;

@property (strong, nonatomic) NSString *SalesCount;

@property (strong, nonatomic) NSString *LogoUrl;

@property (strong, nonatomic) NSString *Url;

@property (strong, nonatomic) NSString *BizDescription;

@property (strong, nonatomic) NSString *FullName;

@property (strong, nonatomic) NSString *Standard;

@property (strong, nonatomic) NSString *Remark;

@property (strong, nonatomic) NSString *PerPrice;

@property (strong, nonatomic) NSString *Phone;

@property (strong, nonatomic) NSString *WeChat;

@property (strong, nonatomic) NSString *QQ;

@end
