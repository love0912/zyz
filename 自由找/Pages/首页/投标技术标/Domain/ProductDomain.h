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

@end
