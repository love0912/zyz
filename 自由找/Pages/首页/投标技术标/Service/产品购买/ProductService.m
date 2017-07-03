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
    [self http2RequestWithUrl:ACTION_PRODUCT_GETLIST parameters:paramDic success:^(id responseObject, NSInteger code) {
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
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 *  获取产品列表
 *
 *  @param type   1 -- 技术, 2 -- 预算
 *  @param region 区域
 *  @param result
 */
- (void)getProductListWithRegion:(NSDictionary *)regionDic type:(NSInteger)type result:(void (^)(NSInteger code, NSArray<ProductDomain *> *list))result {
    NSDictionary *paramDic = @{@"ProductType": @(type), @"Region": regionDic};
    [self http2RequestWithUrl:ACTION_PRODUCT_GETLIST parameters:paramDic success:^(id responseObject, NSInteger code) {
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
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 *  获取区域
 *  @param result
 */
- (void)getProductRegionToResult:(void (^)(NSInteger code, NSArray<KeyValueDomain *> *list))result {
    [self http2RequestWithUrl:ACTION_PRODUCT_REGION parameters:nil success:^(id responseObject, NSInteger code) {
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
    } fail:^(id errorObject) {
        result(0, nil);
    }];
    
//    [self httpRequestWithUrl:ACTION_PRODUCT_REGION success:^(id responseObject, NSInteger code) {
//        if (code == 1) {
//            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
//            NSMutableArray *arr_region = [NSMutableArray arrayWithCapacity:tmpArray.count];
//            for (NSDictionary *tmpDic in tmpArray) {
//                KeyValueDomain *region = [KeyValueDomain domainWithObject:tmpDic];
//                [arr_region addObject:region];
//            }
//            result(code, arr_region);
//        } else {
//            result(code, nil);
//        }
//    } fail:^{
//        result(0, nil);
//    }];
}
/**
 *  获取项目类别
 *  @param result
 */
- (void)getProjectCatoryToResult:(void (^)(NSInteger code, NSArray<KeyValueDomain *> *list))result{
    [self http2RequestWithUrl:ACTION_ProjectCategory parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *arr_projectCatory = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                KeyValueDomain *projectCatory = [KeyValueDomain domainWithObject:tmpDic];
                [arr_projectCatory addObject:projectCatory];
            }
            result(code, arr_projectCatory);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
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
    [self http2RequestWithUrl:ACTION_PRODUCT_CREATE_ORDER parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            OrderInfoDomain *orderInfo = [OrderInfoDomain domainWithObject:responseObject[kResponseDatas]];
            result(code, orderInfo);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject){
        result(0, nil);
    }];
}

/**
 *  我的订单
 *
 *  @param page
 *  @param result
 */
- (void)getMySelfOrderWithPage:(NSInteger)page result:(void (^)(NSInteger code, NSArray<OrderInfoDomain *> *mySelfs))result {
    NSDictionary *paramDic = @{kPage: @(page)};
    [self background3RequestWithUrl:ACTION_PRODUCT_GET_OURSELF_ORDER_NEW parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *arr_orders = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                OrderInfoDomain *order = [OrderInfoDomain domainWithObject:tmpDic];
                [arr_orders addObject:order];
            }
            result(code, arr_orders);
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
    [self http2RequestWithUrl:ACTION_PRODUCT_ORDER_DETAIL parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            OrderInfoDomain *orderInfo = [OrderInfoDomain domainWithObject:responseObject[kResponseDatas]];
            result(code, orderInfo);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}


/**
 *  查看制作人员
 *
 *  @param orderID 订单ID
 *  @param result  <#result description#>
 */
- (void)getProducerByID:(NSString *)orderID result:(void (^)(NSInteger code, NSArray<ProducerDomain *> *producerInfo))result {
    NSDictionary *paramDic = @{@"SerialNo": orderID};
    [self background2RequestWithUrl:ACTION_PRODUCT_VIEW_PRODUCER parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray;
            if ([responseObject[kResponseDatas] isKindOfClass:[NSNull class]]) {
                tmpArray = [NSArray array];
            } else {
                tmpArray = [NSArray arrayWithArray:responseObject[kResponseDatas]];
            }
            NSMutableArray *arr_producer = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                ProducerDomain *producer = [ProducerDomain domainWithObject:tmpDic];
                [arr_producer addObject:producer];
            }
            result(code, arr_producer);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject){
        result(0, nil);
    }];
}

/**
 *  取消订单
 *
 *  @param orderID 订单ID
 *  @param reason  原因
 *  @param result  <#result description#>
 */
- (void)cancelOrderByID:(NSString *)orderID reason:(NSString *)reason result:(void (^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"SerialNo": orderID, @"Reason": reason};
    [self http2RequestWithUrl:ACTION_PRODUCT_CANCEL_ORDER parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 *  支付订单
 *
 *  @param orderID 订单ID
 *  @param result
 */
- (void)payOrderByID:(NSString *)orderID password:(NSString *)password result:(void (^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"SerialNo": orderID, @"PayPwd": [CommonUtil getMd5_32Bit:password]};
    [self http2RequestWithUrl:ACTION_PRODUCT_ORDER_PAY parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 *  订单退款
 *
 *  @param orderID 订单ID
 *  @param result
 */
- (void)refundOrderByID:(NSString *)orderID reason:(NSString *)reason description:(NSString *)description result:(void (^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"SerialNo": orderID, @"Reason": reason, @"Description": description};
    [self http2RequestWithUrl:ACTION_PRODUCT_ORDER_REFUND parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 *  获取退款原因
 *
 *  @param orderID 订单ID
 *  @param result
 */
- (void)getRefundReasonToResult:(void (^)(NSInteger code, NSArray<KeyValueDomain *> *reasons))result {
    [self http2RequestWithUrl:ACTION_PRODUCT_ORDER_REFUNDREASON parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *arr_reason = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                KeyValueDomain *reason = [KeyValueDomain domainWithObject:tmpDic];
                [arr_reason addObject:reason];
            }
            result(code, arr_reason);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
    
}
/**
 *  评价
 *
 *  @param orderID 订单ID
 *  @param result
 */
- (void)getCommentListToResult:(void (^)(NSInteger code, NSArray<KeyValueDomain *> *reasons))result{
    [self http2RequestWithUrl:ACTION_PRODUCT_ORDER_Comment parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *arr_reason = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                KeyValueDomain *reason = [KeyValueDomain domainWithObject:tmpDic];
                [arr_reason addObject:reason];
            }
            result(code, arr_reason);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];

}
/**
 *  查看退款结果
 *
 *  @param orderID 订单ID
 *  @param result
 */
- (void)getRefundResultWithID:(NSString *)orderID result:(void (^)(NSInteger code, OrderRefundDomain *refundResult))result {
    NSDictionary *paramDic = @{@"SerialNo": orderID};
    [self http2RequestWithUrl:ACTION_PRODUCT_ORDER_REFUNDRESULT parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            OrderRefundDomain *orderResult = [OrderRefundDomain domainWithObject:responseObject[kResponseDatas]];
            result(code, orderResult);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 *  查看产品详情
 *
 *  @param productID 产品ID
 *  @param region    区域
 *  @param result    <#result description#>
 */
- (void)getProductDetailsWithID:(NSString *)productID region:(NSDictionary *)region result:(void (^)(NSInteger code, ProductDetailsDomain *productInfo))result {
    NSDictionary *paramDic = @{@"SerialNo": productID, @"Region": region};
    [self http2RequestWithUrl:ACTION_PRODUCT_GET_DETAILS parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            ProductDetailsDomain *productDetail = [ProductDetailsDomain domainWithObject:responseObject[kResponseDatas]];
            result(code, productDetail);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
    
//    [self httpRequestWithUrl:ACTION_PRODUCT_GET_DETAILS parameters:paramDic success:^(id responseObject, NSInteger code) {
//        if (code == 1) {
//            ProductDetailsDomain *productDetail = [ProductDetailsDomain domainWithObject:responseObject[kResponseDatas]];
//            result(code, productDetail);
//        } else {
//            result(code, nil);
//        }
//    } fail:^{
//        result(0, nil);
//    }];
}

/**
 *  查看产品详情
 *
 *  @param productID 产品ID
 *  @param region    区域
 *  @param productType 3 -- 投标保函
 *  @param result    <#result description#>
 */
- (void)getProductDetailsWithID:(NSString *)productID productType:(NSInteger)productType region:(NSDictionary *)region result:(void (^)(NSInteger code, ProductDetailsDomain *productInfo))result {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:@{@"SerialNo": productID,@"ProductType": @(productType)}];
    if (region != nil) {
        [paramDic setObject:region forKey:@"Region"];
    }
    [self http3RequestWithUrl:ACTION_PRODUCT_GET_DETAILS parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            ProductDetailsDomain *productDetail = [ProductDetailsDomain domainWithObject:responseObject[kResponseDatas]];
            result(code, productDetail);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
    
    //    [self httpRequestWithUrl:ACTION_PRODUCT_GET_DETAILS parameters:paramDic success:^(id responseObject, NSInteger code) {
    //        if (code == 1) {
    //            ProductDetailsDomain *productDetail = [ProductDetailsDomain domainWithObject:responseObject[kResponseDatas]];
    //            result(code, productDetail);
    //        } else {
    //            result(code, nil);
    //        }
    //    } fail:^{
    //        result(0, nil);
    //    }];
}

/**
 *  查看产品评价
 *
 *  @param productID 产品ID
 *  @param page      分页页数
 *  @param result
 */
- (void)getProductEvaluateWithProductID:(NSString *)productID page:(NSInteger)page result:(void (^)(NSInteger code, NSArray<EvaluateDomain *> *evaluateInfo))result {
    NSDictionary *paramDic = @{@"SerialNo": productID, kPage: @(page)};
    [self background2RequestWithUrl:ACTION_PRODUCT_GET_EVALUATE parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *arr_evaluate = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                EvaluateDomain *evaluate = [EvaluateDomain domainWithObject:tmpDic];
                [arr_evaluate addObject:evaluate];
            }
            result(code, arr_evaluate);
        } else {
            result(code, nil);
        }
    } fail:^{
        result(0, nil);
    }];
}

/**
 *  查看产品评价
 *
 *  @param productID 产品ID
 *  @param page      分页页数
 *  @param productType 3 -- 投标保函
 *  @param result
 */
- (void)getProductEvaluateWithProductID:(NSString *)productID productType:(NSInteger)type page:(NSInteger)page result:(void (^)(NSInteger code, NSArray<EvaluateDomain *> *evaluateInfo))result{
    NSDictionary *paramDic = @{@"SerialNo": productID, kPage: @(page), @"ProductType": @(type)};
    [self background3RequestWithUrl:ACTION_PRODUCT_GET_EVALUATE parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *arr_evaluate = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                EvaluateDomain *evaluate = [EvaluateDomain domainWithObject:tmpDic];
                [arr_evaluate addObject:evaluate];
            }
            result(code, arr_evaluate);
        } else {
            result(code, nil);
        }
    } fail:^{
        result(0, nil);
    }];
}

/**
 *  评价产品
 *
 *  @param productID   产品ID
 *  @param score       分数
 *  @param reason      原因
 *  @param content     描述
 *  @param isAnonymous “1”匿名   “0”实名
 *  @param result
 */
- (void)evaluateProductWithProductID:(NSString *)productID score:(NSString *)score reason:(NSString *)reason content:(NSString *)content isAnonymous:(NSString *)isAnonymous result:(void (^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"SerialNo": productID, @"Score": score, @"Reason": reason, @"Content": content, @"IsAnonymous": isAnonymous};
    [self http2RequestWithUrl:ACTION_PRODUCT_EVALUATE parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 *  评价产品
 *
 *  @param productID   产品ID
 *  @param type 3 -- 投标保函
 *  @param score       分数
 *  @param reason      原因
 *  @param content     描述
 *  @param isAnonymous “1”匿名   “0”实名
 *  @param result
 */
- (void)evaluateProductWithProductID:(NSString *)productID productType:(NSInteger)type score:(NSString *)score reason:(NSString *)reason content:(NSString *)content isAnonymous:(NSString *)isAnonymous result:(void (^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"SerialNo": productID, @"Score": score, @"Reason": reason, @"Content": content, @"IsAnonymous": isAnonymous, @"ProductType": @(type)};
    [self http3RequestWithUrl:ACTION_PRODUCT_EVALUATE parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 删除订单
 
 @param ID     订单ID
 @param type   类型 1-技术   2-预算
 @param result <#result description#>
 */
- (void)deleteProductOrderByID:(NSString *)ID productType:(NSInteger)type result:(void (^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"OrderNo": ID, @"ProductType": @(type)};
    [self http3RequestWithUrl:ACTION_BIDLETTERORDER_DELETE parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

@end
