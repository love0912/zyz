//
//  ExpendDomain.h
//  自由找
//
//  Created by guojie on 16/8/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"

@class DrawCashInfo;

@interface ExpendDomain : BaseDomain

@property (strong, nonatomic) NSString *CreateDt;

/**
 *  （某某项目）
 */
@property (strong, nonatomic) NSString *Summary;

/**
 *  (金额)  -300
 */
@property (strong, nonatomic) NSString *Value;

@property (strong, nonatomic) NSString *TradeNo;

@property (strong, nonatomic) NSString *TradeType;

@property (strong, nonatomic) NSString *PayType;

@property (strong, nonatomic) NSString *Remark;

@property (strong, nonatomic) DrawCashInfo *DrawCashInfo;

@end

@interface DrawCashInfo : BaseDomain

@property (strong, nonatomic) NSString *CartNo;

@property (strong, nonatomic) NSString *Name;

@end