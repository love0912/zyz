//
//  BuyQueryDomain.h
//  zyz
//
//  Created by 郭界 on 17/1/11.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "BaseDomain.h"

@interface BuyQueryDomain : BaseDomain

@property (strong, nonatomic) NSString *ServiceOId;

@property (strong, nonatomic) NSString *ServiceName;

@property (strong, nonatomic) NSString *ValidPeriod;

@property (strong, nonatomic) NSString *Price;

@property (strong, nonatomic) NSString *Description;

@end
