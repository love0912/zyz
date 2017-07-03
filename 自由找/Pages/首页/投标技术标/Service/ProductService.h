//
//  ProductService.h
//  自由找
//
//  Created by guojie on 16/8/10.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseService.h"
#import "ProductDomain.h"
#import "UserDomain.h"
#import "OrderInfoDomain.h"

@interface ProductService : BaseService

/**
 *  获取产品列表
 *
 *  @param type   1 -- 技术, 2 -- 预算
 *  @param result 
 */
- (void)getProductListWithType:(NSInteger)type result:(void (^)(NSInteger code, NSArray<ProductDomain *> *list))result;

/**
 *  获取区域
 *  @param result
 */
- (void)getProductRegionToResult:(void (^)(NSInteger code, NSArray<KeyValueDomain *> *list))result;


/**
 *  创建订单
 *
 *  @param productNo 产品编号
 *  @param region    区域{key, value}
 *  @param quantity  数量
 *  @param remark    留言
 *  @param contact   联系方式
 *  @param result    <#result description#>
 */
- (void)createOrderWithProductNo:(NSString *)productNo region:(NSDictionary *)region quantity:(NSString *)quantity remark:(NSString *)remark contact:(NSString *)contact result:(void (^)(NSInteger code, OrderInfoDomain *orderInfo))result;

/**
 *  获取订单详情
 *
 *  @param orderID 订单ID
 *  @param result  <#result description#>
 */
- (void)getOrderDetailByID:(NSString *)orderID result:(void (^)(NSInteger code, OrderInfoDomain *orderInfo))result;
@end
