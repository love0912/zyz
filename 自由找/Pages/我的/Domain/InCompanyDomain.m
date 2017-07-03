//
//  InCompanyDomain.m
//  自由找
//
//  Created by xiaoqi on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "InCompanyDomain.h"
#import "BaseConstants.h"
#import <objc/runtime.h>
@implementation InCompanyDomain
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self jx_encodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self jx_decodeWithCoder:aDecoder];
    }
    return self;
}
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:kCompanyAptitudes]) {
        NSMutableArray *companyAptitudesarr = [NSMutableArray array];
        NSArray *arr = (NSArray *)value;
        for (NSDictionary *dic in arr) {
            CompanyAptitudesDomain *companyAptitude = [CompanyAptitudesDomain domainWithObject:dic];
            [companyAptitudesarr addObject:companyAptitude];
        }
        self.CompanyAptitudes = companyAptitudesarr;
    }
    else {
        [super setValue:value forKey:key];
    }
}
@end
@implementation CompanyAptitudesDomain

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self jx_encodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self jx_decodeWithCoder:aDecoder];
    }
    return self;
}
@end
