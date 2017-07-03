//
//  ExpendDomain.m
//  自由找
//
//  Created by guojie on 16/8/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "ExpendDomain.h"

@implementation ExpendDomain

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"DrawCashInfo"]) {
        DrawCashInfo *drawCashInfo = [DrawCashInfo domainWithObject:value];
        self.DrawCashInfo = drawCashInfo;
    } else {
        [super setValue:value forKey:key];
    }
}

@end

@implementation DrawCashInfo

@end