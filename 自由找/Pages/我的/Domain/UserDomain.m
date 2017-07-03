//
//  UserDomain.m
//  自由找
//
//  Created by guojie on 16/6/13.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "UserDomain.h"
#import "BaseConstants.h"
#import <objc/runtime.h>

@implementation UserDomain

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
    if ([key isEqualToString:kRegistSites]) {
        NSMutableArray *sites = [NSMutableArray array];
        NSArray *arr = (NSArray *)value;
        for (NSDictionary *dic in arr) {
            SiteDomain *site = [SiteDomain domainWithObject:dic];
            [sites addObject:site];
        }
        self.Sites = sites;
    }
    else {
        [super setValue:value forKey:key];
    }
}

@end

@implementation SiteDomain

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
    if ([key isEqualToString:kRegistContact]) {
        ContactDomain *contact = [ContactDomain domainWithObject:value];
        self.Contact = contact;
    } else if ([key isEqualToString:kRegistLocation]) {
        KeyValueDomain *location = [KeyValueDomain domainWithObject:value];
        self.Location = location;
    } else if ([key isEqualToString:kSiteEnterprise]) {
        EnterpriseDomain *domain = [EnterpriseDomain domainWithObject:value];
        self.Enterprise = domain;
    } else {
        [super setValue:value forKey:key];
    }
}

@end

@implementation EnterpriseDomain

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
        NSArray *tmpArray = value;
        NSMutableArray *aps = [NSMutableArray arrayWithCapacity:tmpArray.count];
        for (NSDictionary *tmpDic in tmpArray) {
            AptitudesDomain *domain = [AptitudesDomain domainWithObject:tmpDic];
            [aps addObject:domain];
        }
        self.CompanyAptitudes = aps;
    } else {
        [super setValue:value forKey:key];
    }
}

@end

@implementation ContactDomain

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

@implementation AptitudesDomain

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

@implementation KeyValueDomain

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