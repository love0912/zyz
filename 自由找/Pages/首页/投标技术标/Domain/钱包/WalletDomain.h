//
//  WalletDomain.h
//  自由找
//
//  Created by guojie on 16/8/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
#import "UserDomain.h"

@interface WalletDomain : BaseDomain

/**
 *  (余额)
 */
@property (strong, nonatomic) NSString *Balance;

/**
 *  冻结余额
 */
@property (strong, nonatomic) NSString *FrozenBalance;

/**
 *  冻结优惠券总额
 */
@property (strong, nonatomic) NSString *FrozenCoupon;


/**
 *  有效余额，可提现
 */
@property (strong, nonatomic) NSString *availableBalance;

/**
 *  每次最大提现数
 */
@property (strong, nonatomic) NSString *MaxOutpourPer;

/**
 *  每天最大提现数
 */
@property (strong, nonatomic) NSString *MaxOutpourDay;

/**
 *  1 可直接提现  0 没有银行信息，需要跳转完成银行信息
 */
@property (strong, nonatomic) NSString *IsCanOutpour;

/**
 *  Key –银行代码   Value—银行名称
 */
@property (strong, nonatomic) KeyValueDomain *Bank;

/**
 *  银行账号
 */
@property (strong, nonatomic) NSString *BankAccountNo;

/**
 *  开户姓名
 */
@property (strong, nonatomic) NSString *BankAccountName;



@end
