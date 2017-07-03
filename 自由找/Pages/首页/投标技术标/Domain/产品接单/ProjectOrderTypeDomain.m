//
//  ProjectOrderTypeDomain.m
//  自由找
//
//  Created by guojie on 16/8/12.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "ProjectOrderTypeDomain.h"
#import "KeyDefine.h"
@implementation ProjectOrderTypeDomain
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:kBidRegion]) {
        KeyValueDomain *domain = [KeyValueDomain domainWithObject:value];
        self.Region = domain;
    }else if ([key isEqualToString:@"Product"]) {
        TakeOrderProductDomain *domain = [TakeOrderProductDomain domainWithObject:value];
        self.Product = domain;
    }  else {
        [super setValue:value forKey:key];
    }
}

@end
@implementation TakeOrderProductDomain
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"ProductLevel"]) {
        KeyValueDomain *domain = [KeyValueDomain domainWithObject:value];
        self.ProductLevel = domain;
    } else if ([key isEqualToString:@"ProductType"]) {
        KeyValueDomain *domain = [KeyValueDomain domainWithObject:value];
        self.ProductType = domain;
    }else {
        [super setValue:value forKey:key];
    }
}

@end

