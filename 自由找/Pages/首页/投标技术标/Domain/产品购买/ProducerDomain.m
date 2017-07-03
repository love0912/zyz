//
//  ProducerDomain.m
//  自由找
//
//  Created by guojie on 16/8/10.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "ProducerDomain.h"

@implementation ProducerDomain

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"WorkExperiences"]) {
        NSArray *tmpArray = value;
        NSMutableArray *arr_work = [NSMutableArray arrayWithCapacity:tmpArray.count];
        for (NSDictionary *tmpDic in tmpArray) {
            WorkExperienceDomain *work = [WorkExperienceDomain domainWithObject:tmpDic];
            [arr_work addObject:work];
        }
        self.WorkExperiences = arr_work;
    } else if ([key isEqualToString:@"ProjectExperiences"]) {
        NSArray *tmpArray = value;
        NSMutableArray *arr_project = [NSMutableArray arrayWithCapacity:tmpArray.count];
        for (NSDictionary *tmpDic in tmpArray) {
            ProjectExperienceDomain *project = [ProjectExperienceDomain domainWithObject:tmpDic];
            [arr_project addObject:project];
        }
        self.ProjectExperiences = arr_project;
    } else if ([key isEqualToString:@"Region"]) {
        KeyValueDomain *region = [KeyValueDomain domainWithObject:value];
        self.Region = region;
    }else if ([key isEqualToString:@"ProductLevel"]) {
        KeyValueDomain *productLevel = [KeyValueDomain domainWithObject:value];
        self.ProductLevel = productLevel;
    }else if ([key isEqualToString:@"MaxQuantity"]) {
        NSArray *tmpArray = value;
        NSMutableArray *arr_MaxQuantity = [NSMutableArray arrayWithCapacity:tmpArray.count];
        for (NSDictionary *tmpDic in tmpArray) {
            MaxQuantityDomain *maxQuantityDomain = [MaxQuantityDomain domainWithObject:tmpDic];
            [arr_MaxQuantity addObject:maxQuantityDomain];
        }
        self.MaxQuantity =arr_MaxQuantity ;
    }
    else {
        [super setValue:value forKey:key];
    }
}

@end

@implementation WorkExperienceDomain
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

@implementation ProjectExperienceDomain
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
@implementation MaxQuantityDomain
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"ProductLevel"]) {
        KeyValueDomain *productLevel = [KeyValueDomain domainWithObject:value];
        self.ProductLevel = productLevel;
    }else {
        [super setValue:value forKey:key];
    }
}

@end