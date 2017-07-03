//
//  PayService.m
//  自由找
//
//  Created by guojie on 16/8/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "PayService.h"

@implementation PayService

/**
 *  获取钱包验证码
 *
 *  @param phone
 *  @param type   3 -- 注册钱包
 *  @param result
 */
- (void)getPayCodeByPhone:(NSString *)phone Type:(NSString *)type result:(void(^)(NSInteger code, NSString *identifiyCode))result {
    NSDictionary *paramDic = @{@"Phone": phone, @"Type": type};
//    [self httpRequestWithUrl:ACTION_PAY_WALLET_GET_IDENTIFYCODE parameters:paramDic success:^(id responseObject, NSInteger code) {
//        if (code == 1) {
//            NSString *identifyCode = responseObject[kResponseDatas][@"Code"];
//            result(code, identifyCode);
//        } else {
//            result(code, nil);
//        }
//    } fail:^{
//        result(0, nil);
//    }];
    [self http2RequestWithUrl:ACTION_PAY_WALLET_GET_IDENTIFYCODE parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSString *identifyCode =responseObject[kResponseDatas];
            result(code, identifyCode);
        } else {
            result(code, nil);
        }
        
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 *  创建钱包
 *
 *  @param phone    电话号码
 *  @param password 支付密码
 *  @param code     验证码
 *  @param result
 */
- (void)createWalletWithPhone:(NSString *)phone password:(NSString *)password identifyCode:(NSString *)code result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"Phone": phone, @"Password": [CommonUtil getMd5_32Bit:password], @"IdentifyCode": code};
//    [self httpRequestWithUrl:ACTION_PAY_CREATE_WALLET parameters:paramDic success:^(id responseObject, NSInteger code) {
//        result(code);
//    } fail:^{
//        result(0);
//    }];
    [self http2RequestWithUrl:ACTION_PAY_CREATE_WALLET parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 *  修改支付密码
 *
 *  @param oriPass 原始密码
 *  @param newPass 新密码
 *  @param result
 */
- (void)modifyPayPasswordWithOriPass:(NSString *)oriPass newPass:(NSString *)newPass result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"OriginalPassword": [CommonUtil getMd5_32Bit:oriPass], @"Password": [CommonUtil getMd5_32Bit:newPass]};
//    [self httpRequestWithUrl:ACTION_PAY_WALLET_MODIFYPASSWORD parameters:paramDic success:^(id responseObject, NSInteger code) {
//        result(code);
//    } fail:^{
//        result(0);
//    }];
    [self http2RequestWithUrl:ACTION_PAY_WALLET_MODIFYPASSWORD parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 *  获取钱包概况
 *
 *  @param result
 */
- (void)getWalletInfoToResult:(void(^)(NSInteger code, WalletDomain *wallet))result {
//    [self httpRequestWithUrl:ACTION_PAY_WALLET_INFO success:^(id responseObject, NSInteger code) {
//        if (code == 1) {
//            WalletDomain *wallet = [WalletDomain domainWithObject:responseObject[kResponseDatas]];
//            result(code, wallet);
//        } else {
//            result(code, nil);
//        }
//    } fail:^{
//        result(0, nil);
//    }];
    [self http2RequestWithUrl:ACTION_PAY_WALLET_INFO parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            WalletDomain *wallet = [WalletDomain domainWithObject:responseObject[kResponseDatas]];
            result(code, wallet);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}


/**
 *  获取收支详情
 *
 *  @param type   (1/2/3  收入/支出/全部  )
 *  @param page   分页信息
 *  @param result
 */
- (void)getPayExpendByType:(NSString *)type page:(NSInteger)page result:(void(^)(NSInteger code, NSArray<ExpendDomain *> *expend))result {
    NSDictionary *paramDic = @{kPage:@(page), @"TradeType": type};
//    [self backgroundRequestWithUrl:ACTION_PAY_INOUT_DETAIL parameters:paramDic success:^(id responseObject, NSInteger code) {
//        if (code == 1) {
//            NSArray *tmpArray = responseObject[kResponseDatas];
//            NSMutableArray *arr_expend = [NSMutableArray arrayWithCapacity:tmpArray.count];
//            for (NSDictionary *tmpDic in tmpArray) {
//                ExpendDomain *expend = [ExpendDomain domainWithObject:tmpDic];
//                [arr_expend addObject:expend];
//            }
//            result(code, arr_expend);
//        } else {
//            result(code, nil);
//        }
//    } fail:^{
//        result(0, nil);
//    }];
    [self background2RequestWithUrl:ACTION_PAY_INOUT_DETAIL parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *arr_expend = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                ExpendDomain *expend = [ExpendDomain domainWithObject:tmpDic];
                [arr_expend addObject:expend];
            }
            result(code, arr_expend);
        } else {
            result(code, nil);
        }
    } fail:^{
        result(0, nil);
    }];
    
}

/**
 *  获取我的优惠券
 *
 *  @param result
 */
- (void)getCouponsPage:(NSInteger)page reult:(void(^)(NSInteger code, NSArray<CouponDomain *> *coupon))result {
//    [self httpRequestWithUrl:ACTION_PAY_WALLET_COUPON parameters:nil success:^(id responseObject, NSInteger code) {
//        if (code == 1) {
//            NSArray *tmpArray = responseObject[kResponseDatas];
//            NSMutableArray *arr_coupon = [NSMutableArray arrayWithCapacity:tmpArray.count];
//            for (NSDictionary *tmpDic in tmpArray) {
//                CouponDomain *coupon = [CouponDomain domainWithObject:tmpDic];
//                [arr_coupon addObject:coupon];
//            }
//            result(code, arr_coupon);
//        } else {
//            result(code, nil);
//        }
//    } fail:^{
//        result(0, nil);
//    }];
    NSDictionary *paramDic = @{kPage:@(page)};
    [self background2RequestWithUrl:ACTION_PAY_WALLET_COUPON parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *arr_coupon = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                CouponDomain *coupon = [CouponDomain domainWithObject:tmpDic];
                [arr_coupon addObject:coupon];
            }
            result(code, arr_coupon);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 *  选择支付方式，请求获取支付参数
 *
 *  @param money  <#money description#>
 *  @param type   <#type description#>
 *  @param result <#result description#>
 */
- (void)requestPayWayByMoney:(NSString *)money thirdPartyType:(NSString *)type result:(void(^)(NSInteger code, NSDictionary *payInfoDic))result {
    NSDictionary *paramDic = @{@"Amount": money, @"ThirdParty": type};
//    [self httpRequestWithUrl:ACTION_PAY_REQUEST_PAYINFO parameters:paramDic success:^(id responseObject, NSInteger code) {
//        if (code == 1) {
//            result(code, responseObject[kResponseDatas]);
//        } else {
//            result(code, nil);
//        }
//    } fail:^{
//        result(0, nil);
//    }];
    [self http2RequestWithUrl:ACTION_PAY_REQUEST_PAYINFO parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            result(code, responseObject[kResponseDatas]);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 *  检查支付是否成功
 *
 *  @param tradeNo   自由找平台交易号
 *  @param money     金额
 *  @param type      支付平台类型
 *  @param payResult 支付平台返回结果
 *  @param result    <#result description#>
 */
- (void)checkTradeSuccessByTradeNo:(NSString *)tradeNo amount:(NSString *)money thirdPartyType:(NSString *)type payResult:(NSString *)payResult result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"Amount": money, @"ThirdParty": type, @"TradeNo":tradeNo, @"PayResult": payResult};
//    [self httpRequestWithUrl:ACTION_PAY_CHECK_TRADE_SUCCESS parameters:paramDic success:^(id responseObject, NSInteger code) {
//        result(code);
//    } fail:^{
//        result(0);
//    }];
    [self http2RequestWithUrl:ACTION_PAY_CHECK_TRADE_SUCCESS parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 *  获取银行类型列表
 *
 *  @param result <#result description#>
 */
- (void)getBackTypeListToResult:(void(^)(NSInteger code, NSArray<KeyValueDomain *> *bankList))result {
    [self http2RequestWithUrl:ACTION_PAY_OUTPOUR_BANKLIST parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *arr_bank = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                KeyValueDomain *bank = [KeyValueDomain domainWithObject:tmpDic];
                [arr_bank addObject:bank];
            }
            result(code, arr_bank);
            
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 *  提现 -- 手机验证
 *
 *  @param phone  <#phone description#>
 *  @param idCode <#idCode description#>
 *  @param result <#result description#>
 */
- (void)withdrawalVerifyByPhone:(NSString *)phone code:(NSString *)idCode result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"Phone": phone, @"IdentifyCode": idCode};
    [self http2RequestWithUrl:ACTION_PAY_OUTPOUR_VETIFY parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

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
- (void)withdrawWithAmount:(NSString *)money password:(NSString *)password bankDic:(NSDictionary *)bankDic bankAccountNo:(NSString *)accountNo backAccountName:(NSString *)name result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"Amount": money, @"Password": [CommonUtil getMd5_32Bit:password], @"Bank": bankDic, @"BankAccountNo": accountNo, @"BankAccountName": name};
    [self http2RequestWithUrl:ACTION_PAY_OUTPOUR parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}
@end
