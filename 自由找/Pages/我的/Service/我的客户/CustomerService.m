//
//  CustomerService.m
//  自由找
//
//  Created by xiaoqi on 16/6/27.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "CustomerService.h"

@implementation CustomerService
-(void)addCustomerUserWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result{
    [self httpRequestWithUrl:ACTION_CUSTOMER_ADD parameters:parameters success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}

- (void)queryCustomerWithParameters:(NSDictionary *)parameters result:(void (^)(NSArray<CustomerDomain*> *arr_custom, NSInteger count, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_CUSTOMER_LIST parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSInteger count = [[[responseObject objectForKey:kResponseDatas] objectForKey:kJoinCount] integerValue];
            NSArray *tmpArray = [[responseObject objectForKey:kResponseDatas] objectForKey:kJoinItems];
            NSMutableArray *customers = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                CustomerDomain *customer = [CustomerDomain domainWithObject:tmpDic];
                [customers addObject:customer];
            }
            result(customers, count, 1);
        } else {
            result(nil, 0, code);
        }
        
    } fail:^{
        result(nil, 0, 0);
    }];
}

/**
 *  获取合作企业详情
 *
 *  @param customerId <#customerId description#>
 *  @param result     <#result description#>
 */
- (void)queryCustomerDetailWithCustomerID:(NSString *)customerId result:(void (^)(NSDictionary *custemerInfo, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_CUSTOMER_DETAILS parameters:@{kCustomerId: customerId} success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            result(responseObject[kResponseDatas], 1);
        } else {
            result(nil, code);
        }
    } fail:^{
        result(nil, 0);
    }];
}

/**
 *  编辑合作企业
 *
 *  @param parameters <#parameters description#>
 *  @param result     <#result description#>
 */
- (void)editCustomerWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_CUSTOMER_EDIT parameters:parameters success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}

/**
 *  删除合作企业
 *
 *  @param customerId <#customerId description#>
 *  @param result     <#result description#>
 */
- (void)deleteCustomerDetailWithCustomerID:(NSString *)customerId result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_CUSTOMER_DELETE parameters:@{kCustomerId: customerId} success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}

@end
