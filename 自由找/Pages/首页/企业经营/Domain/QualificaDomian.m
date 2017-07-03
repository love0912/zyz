//
//  QualificaDomian.m
//  自由找
//
//  Created by xiaoqi on 16/7/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "QualificaDomian.h"

@implementation QualificaDomian
- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"Items"]) {
        NSArray *tmpArray = value;
        NSMutableArray *bids = [NSMutableArray arrayWithCapacity:tmpArray.count];
        for (NSDictionary *tmpDic in tmpArray) {
            QualificaListDomian *bidList = [QualificaListDomian domainWithObject:tmpDic];
            [bids addObject:bidList];
        }
        self.Items = bids;
    } else {
        [super setValue:value forKey:key];
    }
}

@end

@implementation QualificaListDomian

@end
@implementation CompanyListDomian

@end

