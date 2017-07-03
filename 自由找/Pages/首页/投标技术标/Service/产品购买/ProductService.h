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
#import "ProducerDomain.h"
#import "OrderRefundDomain.h"
#import "ProductDetailsDomain.h"
#import "EvaluateDomain.h"

@interface ProductService : BaseService

/**
 *  获取产品列表
 *
 *  @param type   1 -- 技术, 2 -- 预算
 *  @param result 
 */
- (void)getProductListWithType:(NSInteger)type result:(void (^)(NSInteger code, NSArray<ProductDomain *> *list))result;

/**
 *  获取产品列表
 *
 *  @param type   1 -- 技术, 2 -- 预算
 *  @param region 区域
 *  @param result
 */
- (void)getProductListWithRegion:(NSDictionary *)regionDic type:(NSInteger)type result:(void (^)(NSInteger code, NSArray<ProductDomain *> *list))result;

/**
 *  获取区域
 *  @param result
 */
- (void)getProductRegionToResult:(void (^)(NSInteger code, NSArray<KeyValueDomain *> *list))result;

/**
 *  获取项目类别
 *  @param result
 */
- (void)getProjectCatoryToResult:(void (^)(NSInteger code, NSArray<KeyValueDomain *> *list))result;

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
 *  我的订单
 *
 *  @param page
 *  @param result
 */
- (void)getMySelfOrderWithPage:(NSInteger)page result:(void (^)(NSInteger code, NSArray<OrderInfoDomain *> *mySelfs))result;


/**
 *  获取订单详情
 *
 *  @param orderID 订单ID
 *  @param result  <#result description#>
 */
- (void)getOrderDetailByID:(NSString *)orderID result:(void (^)(NSInteger code, OrderInfoDomain *orderInfo))result;

/**
 *  查看制作人员
 *
 *  @param orderID 订单ID
 *  @param result  <#result description#>
 */
- (void)getProducerByID:(NSString *)orderID result:(void (^)(NSInteger code, NSArray<ProducerDomain *> *producerInfo))result;

/**
 *  取消订单
 *
 *  @param orderID 订单ID
 *  @param reason  原因
 *  @param result  <#result description#>
 */
- (void)cancelOrderByID:(NSString *)orderID reason:(NSString *)reason result:(void (^)(NSInteger code))result;

/**
 *  支付订单
 *
 *  @param orderID 订单ID
 *  @param result
 */
- (void)payOrderByID:(NSString *)orderID password:(NSString *)password result:(void (^)(NSInteger code))result;

/**
 *  订单退款
 *
 *  @param orderID 订单ID
 *  @param result
 */
- (void)refundOrderByID:(NSString *)orderID reason:(NSString *)reason description:(NSString *)description result:(void (^)(NSInteger code))result;

/**
 *  获取退款原因
 *
 *  @param orderID 订单ID
 *  @param result
 */
- (void)getRefundReasonToResult:(void (^)(NSInteger code, NSArray<KeyValueDomain *> *reasons))result;
/**
 *  评价
 *
 *  @param orderID 订单ID
 *  @param result
 */
- (void)getCommentListToResult:(void (^)(NSInteger code, NSArray<KeyValueDomain *> *reasons))result;

/**
 *  查看退款结果
 *
 *  @param orderID 订单ID
 *  @param result
 */
- (void)getRefundResultWithID:(NSString *)orderID result:(void (^)(NSInteger code, OrderRefundDomain *refundResult))result;

/**
 *  查看产品详情
 *
 *  @param productID 产品ID
 *  @param region    区域
 *  @param result    <#result description#>
 */
- (void)getProductDetailsWithID:(NSString *)productID region:(NSDictionary *)region result:(void (^)(NSInteger code, ProductDetailsDomain *productInfo))result;

/**
 *  查看产品详情
 *
 *  @param productID 产品ID
 *  @param region    区域
 *  @param productType 3 -- 投标保函
 *  @param result    <#result description#>
 */
- (void)getProductDetailsWithID:(NSString *)productID productType:(NSInteger)productType region:(NSDictionary *)region result:(void (^)(NSInteger code, ProductDetailsDomain *productInfo))result;

/**
 *  查看产品评价
 *
 *  @param productID 产品ID
 *  @param page      分页页数
 *  @param result
 */
- (void)getProductEvaluateWithProductID:(NSString *)productID page:(NSInteger)page result:(void (^)(NSInteger code, NSArray<EvaluateDomain *> *evaluateInfo))result;

/**
 *  查看产品评价
 *
 *  @param productID 产品ID
 *  @param page      分页页数
 *  @param productType 3 -- 投标保函
 *  @param result
 */
- (void)getProductEvaluateWithProductID:(NSString *)productID productType:(NSInteger)type page:(NSInteger)page result:(void (^)(NSInteger code, NSArray<EvaluateDomain *> *evaluateInfo))result;

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
- (void)evaluateProductWithProductID:(NSString *)productID score:(NSString *)score reason:(NSString *)reason content:(NSString *)content isAnonymous:(NSString *)isAnonymous result:(void (^)(NSInteger code))result;

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
- (void)evaluateProductWithProductID:(NSString *)productID productType:(NSInteger)type score:(NSString *)score reason:(NSString *)reason content:(NSString *)content isAnonymous:(NSString *)isAnonymous result:(void (^)(NSInteger code))result;


/**
 删除订单

 @param ID     订单ID
 @param type   类型 1-技术   2-预算
 @param result <#result description#>
 */
- (void)deleteProductOrderByID:(NSString *)ID productType:(NSInteger)type result:(void (^)(NSInteger code))result;
@end
