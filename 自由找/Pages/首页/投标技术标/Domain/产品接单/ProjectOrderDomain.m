//
//  ProjectOrderDomain.m
//  自由找
//
//  Created by guojie on 16/8/12.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "ProjectOrderDomain.h"

@implementation ProjectOrderDomain

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([@"ProjectType" isEqualToString:key]) {
        KeyValueDomain *projectType = [KeyValueDomain domainWithObject:value];
        self.ProjectType = projectType;
    } else if ([@"ProjectRegion" isEqualToString:key]) {
        KeyValueDomain *projectRegion = [KeyValueDomain domainWithObject:value];
        self.ProjectRegion = projectRegion;
    }else {
        [super setValue:value forKey:key];
    }
}

@end
