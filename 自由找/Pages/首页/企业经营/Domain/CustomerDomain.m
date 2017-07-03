//
//  CustomerDomain.m
//  自由找
//
//  Created by guojie on 16/7/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "CustomerDomain.h"

@implementation CustomerDomain

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([@"CustomerAptitudes" isEqualToString:key]) {
        NSArray *tmpArray = value;
        NSMutableArray *aps = [NSMutableArray arrayWithCapacity:tmpArray.count];
        for (NSDictionary *tmpDic in tmpArray) {
            KeyValueDomain *domain = [KeyValueDomain domainWithObject:tmpDic];
            [aps addObject:domain];
        }
        self.CustomerAptitudes = aps;
    } else {
        [super setValue:value forKey:key];
    }
}

@end
