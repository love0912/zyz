//
//  ProductService.m
//  自由找
//
//  Created by guojie on 16/8/10.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "ProductService.h"

@implementation ProductService

/**
 *  获取产品列表
 *
 *  @param type   1 -- 技术, 2 -- 预算
 *  @param result
 */
- (void)getProductListWithType:(NSInteger)type result:(void (^)(NSInteger code, NSArray<ProductDomain *> *list))result {
    NSDictionary *paramDic = @{@"ProductType": @(type)};
    [self httpRequestWithUrl:ACTION_PRODUCT_GETLIST parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *arr_product = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                ProductDomain *product = [ProductDomain domainWithObject:tmpDic];
                [arr_product addObject:product];
            }
            result(code, arr_product);
        } else {
            result(code, nil);
        }
    } fail:^{
        result(0, nil);
    }];
}

/**
 *  获取区域
 *  @param result
 */
- (void)getProductRegionToResult:(void (^)(NSInteger code, NSArray<KeyValueDomain *> *list))result {
    [self httpRequestWithUrl:ACTION_PRODUCT_REGION success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *arr_region = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                KeyValueDomain *region = [KeyValueDomain domainWithObject:tmpDic];
                [arr_region addObject:region];
            }
            result(code, arr_region);
        } else {
            result(code, nil);
        }
    } fail:^{
        result(0, nil);
    }];
}

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
- (void)createOrderWithProductNo:(NSString *)productNo region:(NSDictionary *)region quantity:(NSString *)quantity remark:(NSString *)remark contact:(NSString *)contact result:(void (^)(NSInteger code, OrderInfoDomain *orderInfo))result {
    NSDictionary *paramDic = @{
                               @"SerialNo": productNo,
                               @"Region": region,
                               @"Quantity": quantity,
                               @"Remark": remark,
                               @"ContactInfo": contact
                               };
    [self httpRequestWithUrl:ACTION_PRODUCT_CREATE_ORDER parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            OrderInfoDomain *orderInfo = [OrderInfoDomain domainWithObject:responseObject[kResponseDatas]];
            result(code, orderInfo);
        } else {
            result(code, nil);
        }
    } fail:^{
        result(0, nil);
    }];
}

/**
 *  获取订单详情
 *
 *  @param orderID 订单ID
 *  @param result  <#result description#>
 */
- (void)getOrderDetailByID:(NSString *)orderID result:(void (^)(NSInteger code, OrderInfoDomain *orderInfo))result {
    NSDictionary *paramDic = @{@"SerialNo": orderID};
    [self httpRequestWithUrl:ACTION_PRODUCT_ORDER_DETAIL parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            OrderInfoDomain *orderInfo = [OrderInfoDomain domainWithObject:responseObject[kResponseDatas]];
            result(code, orderInfo);
        } else {
            result(code, nil);
        }
    } fail:^{
        result(0, nil);
    }];
}

@end
