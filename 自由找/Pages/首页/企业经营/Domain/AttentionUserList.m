//
//  AttentionUserList.m
//  自由找
//
//  Created by guojie on 16/6/23.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "AttentionUserList.h"
#import "KeyDefine.h"

@implementation AttentionUserList

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:kJoinCount]) {
        CountDomain *count = [CountDomain domainWithObject:value];
        self.Count = count;
    } else if ([key isEqualToString:kJoinItems]) {
        NSArray *tmpArray = value;
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:tmpArray.count];
        for (NSDictionary *tmpDic in tmpArray) {
            AttentionUserDomain *attentionUser = [AttentionUserDomain domainWithObject:tmpDic];
            [items addObject:attentionUser];
        }
        self.Items = items;
    } else {
        [super setValue:value forKey:key];
    }
}

@end


@implementation CountDomain
@end

@implementation AttentionUserDomain
@end