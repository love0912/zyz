//
//  QualityDomain.m
//  自由找
//
//  Created by guojie on 16/6/28.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "QualityDomain.h"

@implementation QualityDomain

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:kQualitySubCollection]) {
        NSArray *tmpArray = (NSArray *)value;
        NSMutableArray *subs = [NSMutableArray arrayWithCapacity:tmpArray.count];
        for (NSDictionary *tmpDic in tmpArray) {
            KeyValueDomain *domain = [KeyValueDomain domainWithObject:tmpDic];
            [subs addObject:domain];
        }
        self.SubCollection = subs;
    }
}

@end
