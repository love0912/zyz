//
//  LetterService.h
//  自由找
//
//  Created by 郭界 on 16/10/19.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseService.h"
#import "LetterPerformDomain.h"
#import "BidLetterDomain.h"
#import "LetterPriceDomain.h"
#import "LetterOrderDomain.h"
#import "LetterOrderDetailDomain.h"
#import "LetterCompanyDomain.h"

@interface LetterService : BaseService


/**
 获取履约保函列表

 @param projectArea     区域dic
 @param projectCategory 类别dic
 @param page            页码
 @param result          <#result description#>
 */
- (void)getLetterPerformListByArea:(NSDictionary *)projectArea category:(NSDictionary *)projectCategory page:(NSInteger)page result:(void(^)(NSInteger code, NSArray<LetterPerformDomain *>* list))result;


/**
 发布履约保函

 @param letterPerform 履约保函内容
 @param result        <#result description#>
 */
- (void)releaseLetterPerformByLetterDomain:(LetterPerformDomain *)letterPerform result:(void(^)(NSInteger code))result;


/**
 编辑履约保函

 @param letterPerform 修改的履约保函
 @param result        <#result description#>
 */
- (void)editLetterPerformByLetterDomain:(LetterPerformDomain *)letterPerform result:(void(^)(NSInteger code))result;


/**
 删除履约保函

 @param letterID 履约保函编号
 @param result   <#result description#>
 */
- (void)deleteLetterPerformByID:(NSString *)letterID result:(void(^)(NSInteger code))result;

/**
 完成履约保函
 
 @param letterID 履约保函编号
 @param result   <#result description#>
 */
- (void)finishLetterPerformByID:(NSString *)letterID result:(void(^)(NSInteger code))result;

/**
 查询我的发布--- 包括招投标项目，履约保函
 通过  type 区分  Type : “1” –投标合作   “2”-履约保函

 @param page   <#page description#>
 @param result <#result description#>
 */
- (void)getOurPublishWityPage:(NSInteger)page result:(void(^)(NSInteger code, NSArray *list))result;


/**
 获取投标保函列表

 @param result <#result description#>
 */
- (void)getBidLetterListByRegion:(NSDictionary *)regionDic page:(NSInteger)page result:(void(^)(NSInteger code, NSArray<BidLetterDomain *> *list))result;

/**
 获取投标保函列表
 
 @param result <#result description#>
 */
- (void)getBidLetterListByRegion:(NSDictionary *)regionDic bank:(NSDictionary *)bankDic typeDic:(NSDictionary *)typeDic page:(NSInteger)page result:(void(^)(NSInteger code, NSArray<BidLetterDomain *> *list))result;

/**
 获取阶梯价列表

 @param ID     <#ID description#>
 @param result <#result description#>
 */
- (void)getLetterPriceListByID:(NSString *)ID result:(void(^)(NSInteger code, NSArray<LetterPriceDomain *> *list))result;


/**
 提交订单

 @param letterOrder 订单信息
 @param result      返回订单ID
 */
- (void)addLetterOrder:(LetterOrderDomain *)letterOrder result:(void(^)(NSInteger code, NSString *orderNo))result;


/**
 支付订单

 @param orderNo 订单编号
 @param payFee  支付金额
 @param OId     邮寄地址ID
 @param payPwd  密码
 @param result  <#result description#>
 */
- (void)payLetterOrderByOrderNo:(NSString *)orderNo payFee:(NSString *)payFee addressNo:(NSString *)OId payPwd:(NSString *)payPwd result:(void(^)(NSInteger code))result;


/**
 上传保函所需资料

 @param orderNo         订单ID
 @param imageUrls 上传图片的url.
 @param result          <#result description#>
 */
- (void)uploadLetterOrderInfoByOrderNo:(NSString *)orderNo imageUrls:(NSArray *)imageUrls result:(void(^)(NSInteger code))result;

/**
 上传保函所需资料
 
 @param orderNo         订单ID
 @param imageUrls 上传图片的url.
 @param result          <#result description#>
 */
- (void)uploadLetterOrderInfo:(LetterOrderDetailDomain *)letterDetail
                    imageUrls:(NSArray *)imageUrls
                       result:(void(^)(NSInteger code))result;


/**
 获取订单详情

 @param orderNo 订单ID
 @param result  <#result description#>
 */
- (void)getLetterOrderDetailByOrderNo:(NSString *)orderNo result:(void(^)(NSInteger code, LetterOrderDetailDomain *orderDetail))result;


/**
 删除投标保函订单

 @param ID     订单ID
 @param result <#result description#>
 */
- (void)deleteBidLetterOrderByID:(NSString *)ID result:(void(^)(NSInteger code))result;


/**
 收藏保函

 @param ID     <#ID description#>
 @param result <#result description#>
 */
- (void)collectionLetterPerformByID:(NSString *)ID result:(void(^)(NSInteger code))result;


/**
 获取保函类别

 @param result <#result description#>
 */
- (void)getLetterTypeToResult:(void(^)(NSInteger code, NSArray<KeyValueDomain *> *typeList))result;

/**
 获取担保公司类别
 
 @param result <#result description#>
 */
- (void)getLetterCompanyTypeToResult:(void(^)(NSInteger code, NSArray<KeyValueDomain *> *typeList))result;


/**
 获取银行类别

 @param result <#result description#>
 */
- (void)getBankTypeToResult:(void(^)(NSInteger code, NSArray<KeyValueDomain *> *bankList))result;

/**
 获取担保公司

 @param page <#page description#>
 @param result <#result description#>
 */
- (void)getLetterCompanyListByRegionOfDic:(NSDictionary *)regionDic typeOfDic:(NSDictionary *)typeDic page:(NSInteger)page result:(void(^)(NSArray<LetterCompanyDomain *> *companyList, NSInteger code))result;
@end
