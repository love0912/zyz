//
//  LetterService.m
//  自由找
//
//  Created by 郭界 on 16/10/19.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "LetterService.h"

@implementation LetterService

/**
 获取履约保函列表
 
 @param projectArea     区域dic
 @param projectCategory 类别dic
 @param page            页码
 @param result          <#result description#>
 */
- (void)getLetterPerformListByArea:(NSDictionary *)projectArea category:(NSDictionary *)projectCategory page:(NSInteger)page result:(void(^)(NSInteger code, NSArray<LetterPerformDomain *>* list))result {
    NSDictionary *paramDic = @{kPage: @(page), @"ProjectArea": projectArea, @"ProjectCategory": projectCategory};
    [self background3RequestWithUrl:ACTION_GET_LETTERPERFORM_LIST parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *letterList = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                LetterPerformDomain *letterPerform = [LetterPerformDomain domainWithObject:tmpDic];
                [letterList addObject:letterPerform];
            }
            result(code, letterList);
        } else {
            result(code, nil);
        }
    } fail:^{
        result(0, nil);
    }];
}


/**
 发布履约保函
 
 @param letterPerform 履约保函内容
 @param result        <#result description#>
 */
- (void)releaseLetterPerformByLetterDomain:(LetterPerformDomain *)letterPerform result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = [letterPerform toDictionary];
    [self http3RequestWithUrl:ACTION_CREATE_LETTERPERORM parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 编辑履约保函
 
 @param letterPerform 修改的履约保函
 @param result        <#result description#>
 */
- (void)editLetterPerformByLetterDomain:(LetterPerformDomain *)letterPerform result:(void(^)(NSInteger code))result{
    NSDictionary *paramDic = [letterPerform toDictionary];
    [self http3RequestWithUrl:ACTION_LETTERFORM_EIDT parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 删除履约保函
 
 @param letterID 履约保函编号
 @param result   <#result description#>
 */
- (void)deleteLetterPerformByID:(NSString *)letterID result:(void(^)(NSInteger code))result{
    NSDictionary *paramDic = @{@"SerialNo": letterID};
    [self http3RequestWithUrl:ACTION_LETTERFORM_DELETE parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 完成履约保函
 
 @param letterID 履约保函编号
 @param result   <#result description#>
 */
- (void)finishLetterPerformByID:(NSString *)letterID result:(void(^)(NSInteger code))result{
    NSDictionary *paramDic = @{@"SerialNo": letterID};
    [self http3RequestWithUrl:ACTION_LETTERFORM_FINISH parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 查询我的发布--- 包括招投标项目，履约保函
 通过  type 区分  Type : “1” –投标合作   “2”-履约保函
 
 @param page   <#page description#>
 @param result <#result description#>
 */
- (void)getOurPublishWityPage:(NSInteger)page result:(void(^)(NSInteger code, NSArray *list))result {
    NSDictionary *paramDic = @{kPage: @(page)};
    [self background3RequestWithUrl:ACTION_LETTERPERFORM_GET_OURPUBLISH parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            result(code, responseObject[kResponseDatas]);
        } else {
            result(code, nil);
        }
    } fail:^{
        result(0, nil);
    }];
}

/**
 获取投标保函列表
 
 @param result <#result description#>
 */
- (void)getBidLetterListByRegion:(NSDictionary *)regionDic page:(NSInteger)page result:(void(^)(NSInteger code, NSArray<BidLetterDomain *> *list))result{
    NSDictionary *paramDic = @{kPage:@(page), @"Region":regionDic};
    [self background3RequestWithUrl:ACTION_BIDLETTER_GETLIST parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *arr_bidLetter = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *tmpDic in tmpArray) {
                BidLetterDomain *bidLetter = [BidLetterDomain domainWithObject:tmpDic];
                [arr_bidLetter addObject:bidLetter];
            }
            result(code, arr_bidLetter);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 获取投标保函列表
 
 @param result <#result description#>
 */
- (void)getBidLetterListByRegion:(NSDictionary *)regionDic bank:(NSDictionary *)bankDic typeDic:(NSDictionary *)typeDic page:(NSInteger)page result:(void(^)(NSInteger code, NSArray<BidLetterDomain *> *list))result {
    NSDictionary *paramDic = @{kPage:@(page), @"Region":regionDic, @"BankCategory": bankDic, @"Category": typeDic};
    [self background3RequestWithUrl:ACTION_BIDLETTER_GETLIST parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *arr_bidLetter = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *tmpDic in tmpArray) {
                BidLetterDomain *bidLetter = [BidLetterDomain domainWithObject:tmpDic];
                [arr_bidLetter addObject:bidLetter];
            }
            result(code, arr_bidLetter);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 获取阶梯价列表
 
 @param ID     <#ID description#>
 @param result <#result description#>
 */
- (void)getLetterPriceListByID:(NSString *)ID result:(void(^)(NSInteger code, NSArray<LetterPriceDomain *> *list))result{
    NSDictionary *paramDic = @{@"SerialNo": ID};
    [self http3RequestWithUrl:ACTION_BIDLETTER_PRICE_GETLIST parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *arr_letterPrice = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *tmpDic in tmpArray) {
                LetterPriceDomain *letterPrice = [LetterPriceDomain domainWithObject:tmpDic];
                [arr_letterPrice addObject:letterPrice];
            }
            result(code, arr_letterPrice);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 提交订单
 
 @param letterOrder 订单信息
 @param result      返回订单ID
 */
- (void)addLetterOrder:(LetterOrderDomain *)letterOrder result:(void(^)(NSInteger code, NSString *orderNo))result {
    NSDictionary *paramDic = [letterOrder toDictionary];
    [self http3RequestWithUrl:ACTION_BIDLETTERORDER_SUBMIT parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSString *orderId = [[responseObject objectForKey:kResponseDatas] objectForKey:@"OrderNo"];
            result(code, orderId);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 支付订单
 
 @param orderNo 订单编号
 @param payFee  支付金额
 @param OId     邮寄地址ID
 @param payPwd  密码
 @param result  <#result description#>
 */
- (void)payLetterOrderByOrderNo:(NSString *)orderNo payFee:(NSString *)payFee addressNo:(NSString *)OId payPwd:(NSString *)payPwd result:(void(^)(NSInteger code))result{
     NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:@{@"OrderNo": orderNo, @"PayFee": payFee, @"PayPwd": [CommonUtil getMd5_32Bit:payPwd]}];
    if (OId != nil && ![OId isEmptyString]) {
        [paramDic setObject:OId forKey:@"AddressInfoOId"];
    }
    [self http3RequestWithUrl:ACTION_BIDLETTERORDER_PAY parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 上传保函所需资料
 
 @param orderNo         订单ID
 @param imageUrls 上传图片的url.
 @param result          <#result description#>
 */
- (void)uploadLetterOrderInfoByOrderNo:(NSString *)orderNo imageUrls:(NSArray *)imageUrls result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"OrderNo": orderNo, @"MaterialList": imageUrls};
    [self http3RequestWithUrl:ACTION_BIDLETTERORDER_UPLOAD parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 上传保函所需资料
 
 @param orderNo         订单ID
 @param imageUrls 上传图片的url.
 @param result          <#result description#>
 */
- (void)uploadLetterOrderInfo:(LetterOrderDetailDomain *)letterDetail
                             imageUrls:(NSArray *)imageUrls
                                result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"OrderNo": letterDetail.OrderNo, @"MaterialList": imageUrls, @"ProjectOwner": letterDetail.ProjectOwner, @"ProjectCompany": letterDetail.ProjectCompany, @"ProjectTitle": letterDetail.ProjectTitle, @"MaterialDt": letterDetail.MaterialDt};
    [self http3RequestWithUrl:ACTION_BIDLETTERORDER_UPLOAD parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 获取订单详情
 
 @param orderNo 订单ID
 @param result  <#result description#>
 */
- (void)getLetterOrderDetailByOrderNo:(NSString *)orderNo result:(void(^)(NSInteger code, LetterOrderDetailDomain *orderDetail))result {
    NSDictionary *paramDic = @{@"OrderNo": orderNo};
    [self http3RequestWithUrl:ACTION_BIDLETTERORDER_GETDETAIL parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            LetterOrderDetailDomain *letterDetail = [LetterOrderDetailDomain domainWithObject:responseObject[kResponseDatas]];
            result(code, letterDetail);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 删除投标保函订单
 
 @param ID     订单ID
 @param result <#result description#>
 */
- (void)deleteBidLetterOrderByID:(NSString *)ID result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"OrderNo": ID, @"ProductType": @3};
    [self http3RequestWithUrl:ACTION_BIDLETTERORDER_DELETE parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 收藏保函
 
 @param ID     <#ID description#>
 @param result <#result description#>
 */
- (void)collectionLetterPerformByID:(NSString *)ID result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"SerialNo": ID};
    [self http3RequestWithUrl:ACTION_LETTERPERFORM_COLLECTION parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}


/**
 获取保函类别
 
 @param result <#result description#>
 */
- (void)getLetterTypeToResult:(void(^)(NSInteger code, NSArray<KeyValueDomain *> *typeList))result {
    [self http3RequestWithUrl:ACTION_BIDLETTER_TYPE parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *arr_type = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                KeyValueDomain *domain = [KeyValueDomain domainWithObject:tmpDic];
                [arr_type addObject:domain];
            }
            result(code, arr_type);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 获取担保公司类别
 
 @param result <#result description#>
 */
- (void)getLetterCompanyTypeToResult:(void(^)(NSInteger code, NSArray<KeyValueDomain *> *typeList))result {
    [self http3RequestWithUrl:ACTION_GET_LETTERCOMPANY_TYPE parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *arr_type = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                KeyValueDomain *domain = [KeyValueDomain domainWithObject:tmpDic];
                [arr_type addObject:domain];
            }
            result(code, arr_type);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 获取银行类别
 
 @param result <#result description#>
 */
- (void)getBankTypeToResult:(void(^)(NSInteger code, NSArray<KeyValueDomain *> *bankList))result{
    [self http3RequestWithUrl:ACTION_BANK_TYPE parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *arr_type = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                KeyValueDomain *domain = [KeyValueDomain domainWithObject:tmpDic];
                [arr_type addObject:domain];
            }
            result(code, arr_type);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 获取担保公司
 
 @param page <#page description#>
 @param result <#result description#>
 */
- (void)getLetterCompanyListByRegionOfDic:(NSDictionary *)regionDic typeOfDic:(NSDictionary *)typeDic page:(NSInteger)page result:(void(^)(NSArray<LetterCompanyDomain *> *companyList, NSInteger code))result {
    NSDictionary *paramDic = @{@"BizCategory": typeDic, @"Region": regionDic, kPage:@(page)};
    [self http3RequestWithUrl:ACTION_GET_LETTERCOMPANY_LIST parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *arr_company = [NSMutableArray arrayWithCapacity:tmpArray.count];
            [tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *tmpDic = obj;
                LetterCompanyDomain *company = [LetterCompanyDomain domainWithObject:tmpDic];
                [arr_company addObject:company];
            }];
            result(arr_company, code);
        } else {
            result(nil, code);
        }
    } fail:^(id errorObject) {
        result(nil, 0);
    }];
}
@end
