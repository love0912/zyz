//
//  ProductInfoDomain.m
//  自由找
//
//  Created by guojie on 16/8/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "ProductDetailsDomain.h"

@implementation ProductDetailsDomain

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"CommentTopItem"]) {
        EvaluateDomain *evaluate = [EvaluateDomain domainWithObject:value];
        self.CommentTopItem = evaluate;
    } else {
        [super setValue:value forKey:key];
    }
}

@end
