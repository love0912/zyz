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
    if ([key isEqualToString:@"WorkExperience"]) {
        NSArray *tmpArray = value;
        NSMutableArray *arr_work = [NSMutableArray arrayWithCapacity:tmpArray.count];
        for (NSDictionary *tmpDic in tmpArray) {
            WorkExperienceDomain *work = [WorkExperienceDomain domainWithObject:tmpDic];
            [arr_work addObject:work];
        }
        self.WorkExperience = arr_work;
    } else if ([key isEqualToString:@"ProjectExperience"]) {
        NSArray *tmpArray = value;
        NSMutableArray *arr_project = [NSMutableArray arrayWithCapacity:tmpArray.count];
        for (NSDictionary *tmpDic in tmpArray) {
            ProjectExperienceDomain *project = [ProjectExperienceDomain domainWithObject:tmpDic];
            [arr_project addObject:project];
        }
        self.ProjectExperience = arr_project;
    } else {
        [super setValue:value forKey:key];
    }
}

@end
