//
//  PayUtil.m
//  自由找
//
//  Created by guojie on 16/8/18.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "PayUtil.h"
#import <AlipaySDK/AlipaySDK.h>
#define APPSCHEME @"Ziyouzhao"

@implementation PayUtil

+ (void)alipayWithOrder:(NSString *)orderString fromScheme:(NSString *)appScheme callback:(void(^)(NSDictionary *resultDic))completionBlock {
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:APPSCHEME callback:^(NSDictionary *resultDic) {
        completionBlock(resultDic);
    }];
}

@end
