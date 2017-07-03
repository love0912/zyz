//
//  PayService.h
//  自由找
//
//  Created by guojie on 16/8/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseService.h"
#import "WalletDomain.h"
#import "ExpendDomain.h"
#import "CouponDomain.h"

@interface PayService : BaseService

/**
 *  获取钱包验证码
 *
 *  @param phone
 *  @param type   3 -- 注册钱包
 *  @param result
 */
- (void)getPayCodeByPhone:(NSString *)phone Type:(NSString *)type result:(void(^)(NSInteger code, NSString *identifiyCode))result;

/**
 *  创建钱包
 *
 *  @param phone    电话号码
 *  @param password 支付密码
 *  @param code     验证码
 *  @param result
 */
- (void)createWalletWithPhone:(NSString *)phone password:(NSString *)password identifyCode:(NSString *)code result:(void(^)(NSInteger code))result;

/**
 *  修改支付密码
 *
 *  @param oriPass 原始密码
 *  @param newPass 新密码
 *  @param result
 */
- (void)modifyPayPasswordWithOriPass:(NSString *)oriPass newPass:(NSString *)newPass result:(void(^)(NSInteger code))result;

/**
 *  获取钱包概况
 *
 *  @param result
 */
- (void)getWalletInfoToResult:(void(^)(NSInteger code, WalletDomain *wallet))result;

/**
 *  获取收支详情
 *
 *  @param type   (1/2/3  收入/支出/全部  )
 *  @param page   分页信息
 *  @param result
 */
- (void)getPayExpendByType:(NSString *)type page:(NSInteger)page result:(void(^)(NSInteger code, NSArray<ExpendDomain *> *expend))result;

/**
 *  获取我的优惠券
 *
 *  @param result
 */
- (void)getCouponsPage:(NSInteger)page reult:(void(^)(NSInteger code, NSArray<CouponDomain *> *coupon))result;

/**
 *  选择支付方式，请求获取支付参数
 *
 *  @param money  <#money description#>
 *  @param type   <#type description#>
 *  @param result <#result description#>
 */
- (void)requestPayWayByMoney:(NSString *)money thirdPartyType:(NSString *)type result:(void(^)(NSInteger code, NSDictionary *payInfoDic))result;

/**
 *  检查支付是否成功
 *
 *  @param tradeNo   自由找平台交易号
 *  @param money     金额
 *  @param type      支付平台类型
 *  @param payResult 支付平台返回结果
 *  @param result    <#result description#>
 */
- (void)checkTradeSuccessByTradeNo:(NSString *)tradeNo amount:(NSString *)money thirdPartyType:(NSString *)type payResult:(NSString *)payResult result:(void(^)(NSInteger code))result;

/**
 *  获取银行类型列表
 *
 *  @param result <#result description#>
 */
- (void)getBackTypeListToResult:(void(^)(NSInteger code, NSArray<KeyValueDomain *> *bankList))result;

/**
 *  提现 -- 手机验证
 *
 *  @param phone  <#phone description#>
 *  @param idCode <#idCode description#>
 *  @param result <#result description#>
 */
- (void)withdrawalVerifyByPhone:(NSString *)phone code:(NSString *)idCode result:(void(^)(NSInteger code))result;

/**
 *  提现
 *
 *  @param money     <#money description#>
 *  @param password  <#password description#>
 *  @param bankDic   <#bankDic description#>
 *  @param accountNo <#accountNo description#>
 *  @param name      <#name description#>
 *  @param result    <#result description#>
 */
- (void)withdrawWithAmount:(NSString *)money password:(NSString *)password bankDic:(NSDictionary *)bankDic bankAccountNo:(NSString *)accountNo backAccountName:(NSString *)name result:(void(^)(NSInteger code))result;

@end
