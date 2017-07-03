//
//  OurProjectOrderDomain.m
//  自由找
//
//  Created by guojie on 16/8/12.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "OurProjectOrderDomain.h"

@implementation OurProjectOrderDomain

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([@"ProjectType" isEqualToString:key]) {
        KeyValueDomain *projectType = [KeyValueDomain domainWithObject:value];
        self.ProjectType = projectType;
    } else if ([@"Publisher" isEqualToString:key]) {
        PublisherDomain *publisher = [PublisherDomain domainWithObject:value];
        self.Publisher = publisher;
    }else if ([@"WalletRecord" isEqualToString:key]) {
        WalletRecordDomain *walletRecord = [WalletRecordDomain domainWithObject:value];
        self.WalletRecord = walletRecord;
    } else {
        [super setValue:value forKey:key];
    }
}

@end


@implementation PublisherDomain

@end
@implementation WalletRecordDomain

@end