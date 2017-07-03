//
//  CustomerService.h
//  自由找
//
//  Created by xiaoqi on 16/6/27.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseService.h"
#import "CustomerDomain.h"

@interface CustomerService : BaseService
/**
 *  客户管理--新增(3.0)
 */
-(void)addCustomerUserWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

/**
 *  查看合作企业列表
 *
 *  @param parameters <#parameters description#>
 *  @param result     <#result description#>
 */
- (void)queryCustomerWithParameters:(NSDictionary *)parameters result:(void (^)(NSArray<CustomerDomain *> *arr_custom, NSInteger count, NSInteger code))result;

/**
 *  获取合作企业详情
 *
 *  @param customerId <#customerId description#>
 *  @param result     <#result description#>
 */
- (void)queryCustomerDetailWithCustomerID:(NSString *)customerId result:(void (^)(NSDictionary *custemerInfo, NSInteger code))result;

/**
 *  编辑合作企业
 *
 *  @param parameters <#parameters description#>
 *  @param result     <#result description#>
 */
- (void)editCustomerWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

/**
 *  删除合作企业
 *
 *  @param customerId <#customerId description#>
 *  @param result     <#result description#>
 */
- (void)deleteCustomerDetailWithCustomerID:(NSString *)customerId result:(void (^)(NSInteger code))result;
@end
