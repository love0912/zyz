//
//  WalletDomain.m
//  自由找
//
//  Created by guojie on 16/8/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "WalletDomain.h"

@implementation WalletDomain

+ (id)domainWithObject:(NSObject *)dataSource {
    WalletDomain *wallet = [super domainWithObject:dataSource];
    if (wallet) {
        if ([wallet.Balance integerValue] == 0 || wallet.FrozenBalance.integerValue == 0) {
            wallet.availableBalance = [NSString stringWithFormat:@"%@", wallet.Balance];
        } else {
            long long balance = wallet.Balance.longLongValue;
            long long frozen = wallet.FrozenBalance.longLongValue;
            long long available = balance - frozen;
            if (available < 0) {
                available = 0;
            }
            wallet.availableBalance = [NSString stringWithFormat:@"%lld", available];
        }
    }
    return wallet;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([@"Bank" isEqualToString:key]) {
        KeyValueDomain *bankInfo = [KeyValueDomain domainWithObject:value];
        self.Bank = bankInfo;
    } else {
        [super setValue:value forKey:key];
    }
}

@end
