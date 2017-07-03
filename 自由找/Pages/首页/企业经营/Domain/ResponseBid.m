//
//  ResponseBid.m
//  自由找
//
//  Created by guojie on 16/6/22.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "ResponseBid.h"

@implementation ResponseBid

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"Items"]) {
        NSArray *tmpArray = value;
        NSMutableArray *bids = [NSMutableArray arrayWithCapacity:tmpArray.count];
        for (NSDictionary *tmpDic in tmpArray) {
            BidListDomain *bidList = [BidListDomain domainWithObject:tmpDic];
            [bids addObject:bidList];
        }
        self.Items = bids;
    } else {
        [super setValue:value forKey:key];
    }
}

@end

@implementation BidListDomain

@end