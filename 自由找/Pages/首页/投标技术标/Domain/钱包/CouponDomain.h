//
//  CouponDomain.h
//  自由找
//
//  Created by guojie on 16/8/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"

@interface CouponDomain : BaseDomain

/**
 *  (优惠券编号)
 */
@property (nonatomic, strong) NSString *SerialNo;

/**
 *  (面值
 */
@property (nonatomic, strong) NSString *Value;

/**
 *   1 冻结  0 未冻结
 */
@property (nonatomic, strong) NSString *IsFrozen;

/**
 *  过期时间
 */
@property (nonatomic, strong) NSString *ExpireTime;

@property (nonatomic, strong) NSString *Title;

/**
 *  “满3000减200|满1000减100” 分割符号
 */
@property (nonatomic, strong) NSString *Description;

@end
