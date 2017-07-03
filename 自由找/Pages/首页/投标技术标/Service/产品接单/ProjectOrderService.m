//
//  ProjectOrderService.m
//  自由找
//
//  Created by guojie on 16/8/12.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "ProjectOrderService.h"
#import "LetterPerformDomain.h"

@implementation ProjectOrderService

/**
 *  获取接单列表
 *
 *  @param productType 1-技术   2-预算
 *  @param region      <#region description#>
 *  @param projectType <#projectType description#>
 *  @param page        <#page description#>
 *  @param result      <#result description#>
 */
- (void)getProjectOrderByProductType:(NSString *)productType region:(NSDictionary *)region projectType:(NSDictionary *)projectType page:(NSInteger)page result:(void(^)(NSInteger code, NSArray<ProjectOrderDomain *> *orders))result {
    NSDictionary *paramDic = @{@"Region": region, @"ProductType": productType, @"ProjectType": projectType, kPage: @(page)};
//    [self backgroundRequestWithUrl:ACTION_PROJECT_ORDER_GETLIST parameters:paramDic success:^(id responseObject, NSInteger code) {
//        if (code == 1) {
//            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
//            NSMutableArray *arr_orders = [NSMutableArray arrayWithCapacity:tmpArray.count];
//            for (NSDictionary *tmpDic in tmpArray) {
//                ProjectOrderDomain *order = [ProjectOrderDomain domainWithObject:tmpDic];
//                [arr_orders addObject:order];
//            }
//            result(code, arr_orders);
//        } else {
//            result(code, nil);
//        }
//    } fail:^{
//        result(0, nil);
//    }];
    [self background2RequestWithUrl:ACTION_PROJECT_ORDER_GETLIST parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *arr_orders = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                ProjectOrderDomain *order = [ProjectOrderDomain domainWithObject:tmpDic];
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
 *  申请接单 -- 返回接单类别
 *
 *  @param projectID 项目ID
 *  @param result    <#result description#>
 */
- (void)applyReciveOrderByProjectID:(NSString *)projectID productType:(NSInteger)productType result:(void(^)(NSInteger code, NSArray<ProjectOrderTypeDomain *> *orderTypes))result {
    NSDictionary *paramDic = @{@"SerialNo": projectID, @"ProductType": @(productType)};
//    [self httpRequestWithUrl:ACTION_PROJECT_ORDER_APPLY parameters:paramDic success:^(id responseObject, NSInteger code) {
//        if (code == 1) {
//            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
//            NSMutableArray *arr_types = [NSMutableArray arrayWithCapacity:tmpArray.count];
//            for (NSDictionary *tmpDic in tmpArray) {
//                ProjectOrderTypeDomain *orderType = [ProjectOrderTypeDomain domainWithObject:tmpDic];
//                [arr_types addObject:orderType];
//            }
//            result(code, arr_types);
//        } else {
//            result(code, nil);
//        }
//    } fail:^{
//        result(0, nil);
//    }];
    [self http2RequestWithUrl:ACTION_PROJECT_ORDER_APPLY parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *arr_types = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                ProjectOrderTypeDomain *orderType = [ProjectOrderTypeDomain domainWithObject:tmpDic];
                [arr_types addObject:orderType];
            }
            result(code, arr_types);
        } else {
            result(code, nil);
        }

    } fail:^(id errorObject) {
        result(0, nil);
    }];
}


/**
 获取接单订单类别列表

 @param projectID   <#projectID description#>
 @param productType <#productType description#>
 @param result      <#result description#>
 */
- (void)getProjectOrderTypeByProjectID:(NSString *)projectID productType:(NSInteger)productType result:(void(^)(NSInteger code, NSString *orderTypes))result {
    NSDictionary *paramDic = @{@"SerialNo": projectID, @"ProductType": @(productType)};
    [self http2RequestWithUrl:ACTION_PROJECT_ORDER_GetType parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
//            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            result(code, [responseObject objectForKey:kResponseDatas]);
        } else {
            result(code, nil);
        }
        
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 *  确认接单 -- 确认支付
 *
 *  @param typeID   类型ID
 *  @param quantity 数量
 *  @param result   <#result description#>
 */
- (void)confirmOrderByOrderTypeID:(NSString *)typeID quantity:(NSString *)quantity payPass:(NSString *)payPass result:(void(^)(NSInteger code,NSString *msg))result {
    NSDictionary *paramDic = @{@"SerialNo": typeID, @"Quantity": quantity,@"PayPwd":[CommonUtil getMd5_32Bit:payPass]};
//    [self httpRequestWithUrl:ACTION_PROJECT_ORDER_CONFIRM parameters:paramDic success:^(id responseObject, NSInteger code) {
//        result(code);
//    } fail:^{
//        result(0);
//    }];
    [self http2RequestWithUrl:ACTION_PROJECT_ORDER_CONFIRM parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code,responseObject[kResponseMsg]);
    } fail:^(id errorObject) {
        result(0,nil);
    }];
}

/**
 *  获取我的接单
 *
 *  @param page   <#page description#>
 *  @param result <#result description#>
 */
- (void)getOurProjectOrderByPage:(NSInteger)page result:(void(^)(NSInteger code, NSArray<OurProjectOrderDomain *> *orders))result {
    NSDictionary *paramDic = @{kPage: @(page)};
//    [self backgroundRequestWithUrl:ACTION_PROJECT_ORDER_GET_OURS parameters:paramDic success:^(id responseObject, NSInteger code) {
//        if (code == 1) {
//            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
//            NSMutableArray *arr_orders = [NSMutableArray arrayWithCapacity:tmpArray.count];
//            for (NSDictionary *tmpDic in tmpArray) {
//                OurProjectOrderDomain *order = [OurProjectOrderDomain domainWithObject:tmpDic];
//                [arr_orders addObject:order];
//            }
//            result(code, arr_orders);
//        } else {
//            result(code, nil);
//        }
//    } fail:^{
//        result(0, nil);
//    }];
    [self background2RequestWithUrl:ACTION_PROJECT_ORDER_GET_OURS parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *arr_orders = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                OurProjectOrderDomain *order = [OurProjectOrderDomain domainWithObject:tmpDic];
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
 *  查看补遗
 *
 *  @param projectID 项目ID
 *  @param page      <#page description#>
 *  @param result    <#result description#>
 */
- (void)getProjectSupplementByProjectID:(NSString *)projectID page:(NSInteger)page result:(void(^)(NSInteger code, NSArray<SupplementDomain *> *supplements))result {
    NSDictionary *paramDic = @{@"SerialNo": projectID, kPage: @(page)};
//    [self httpRequestWithUrl:ACTION_PROJECT_ORDER_GET_SUPPLEMENT parameters:paramDic success:^(id responseObject, NSInteger code) {
//        if (code == 1) {
//            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
//            NSMutableArray *arr_supples = [NSMutableArray arrayWithCapacity:tmpArray.count];
//            for (NSDictionary *tmpDic in tmpArray) {
//                SupplementDomain *supplement = [SupplementDomain domainWithObject:tmpDic];
//                [arr_supples addObject:supplement];
//            }
//            result(code, arr_supples);
//        } else {
//            result(code, nil);
//        }
//    } fail:^{
//        result(0, nil);
//    }];
    [self http2RequestWithUrl:ACTION_PROJECT_ORDER_GET_SUPPLEMENT parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *arr_supples = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                SupplementDomain *supplement = [SupplementDomain domainWithObject:tmpDic];
                [arr_supples addObject:supplement];
            }
            result(code, arr_supples);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];
}

/**
 *  我的收藏 -- 接单项目
 *
 *  @param page   <#page description#>
 *  @param result <#result description#>
 */
- (void)getOurCollectionByPage:(NSInteger)page result:(void(^)(NSInteger code, NSArray *orders))result {
    NSDictionary *paramDic = @{kPage: @(page)};
//    [self httpRequestWithUrl:ACTION_PROJECT_ORDER_GET_OUR_COLLECTION parameters:paramDic success:^(id responseObject, NSInteger code) {
//        if (code == 1) {
//            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
//            NSMutableArray *arr_orders = [NSMutableArray arrayWithCapacity:tmpArray.count];
//            for (NSDictionary *tmpDic in tmpArray) {
//                ProjectOrderDomain *order = [ProjectOrderDomain domainWithObject:tmpDic];
//                [arr_orders addObject:order];
//            }
//            result(code, arr_orders);
//        } else {
//            result(code, nil);
//        }
//    } fail:^{
//        result(0, nil);
//    }];
    [self background3RequestWithUrl:ACTION_PROJECT_ORDER_GET_OUR_COLLECTION_NEW parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *arr_orders = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                
//                ProjectOrderDomain *order = [ProjectOrderDomain domainWithObject:tmpDic];
//                [arr_orders addObject:order];
                
                NSString *productType = tmpDic[@"ProductType"];
                if ([productType isEqualToString:@"3"]) {
                    LetterPerformDomain *letter = [LetterPerformDomain domainWithObject:tmpDic];
                    [arr_orders addObject:letter];
                } else {
                    ProjectOrderDomain *order = [ProjectOrderDomain domainWithObject:tmpDic];
                    [arr_orders addObject:order];
                }
            }
            result(code, arr_orders);
        } else {
            result(code, nil);
        }

    } fail:^(id errorObject) {
        result(0, nil);
    }];
}
/**
 *  删除我的收藏 -- 接单项目
 *
 *  @param page   <#page description#>
 *  @param result <#result description#>
 */
- (void)deletecollectProjectByProjectID:(NSString *)projectID result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"SummaryId":projectID};
//    [self httpRequestWithUrl:ACTION_PROJECT_ORDER_DELETE_OUR_COLLECTION parameters:paramDic success:^(id responseObject, NSInteger code) {
//        result(code);
//    } fail:^{
//        result(0);
//    }];
    [self http2RequestWithUrl:ACTION_PROJECT_ORDER_DELETE_OUR_COLLECTION parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}

/**
 *  删除我的收藏 -- 新的接口
 *
 *  @param page   <#page description#>
 *  @param result <#result description#>
 */
- (void)deletecollectByID:(NSString *)ID productType:(NSString *)productType result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"SerialNo":ID, @"ProductType": productType};
    //    [self httpRequestWithUrl:ACTION_PROJECT_ORDER_DELETE_OUR_COLLECTION parameters:paramDic success:^(id responseObject, NSInteger code) {
    //        result(code);
    //    } fail:^{
    //        result(0);
    //    }];
    [self http3RequestWithUrl:ACTION_PROJECT_ORDER_DELETE_OUR_COLLECTION_NEW parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}
/**
 *  收藏项目
 *
 *  @param projectID 项目ID
 *  @param result    <#result description#>
 */
- (void)collectProjectByProjectID:(NSString *)projectID result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"SummaryId": projectID};
//    [self httpRequestWithUrl:ACTION_PROJECT_ORDER_COLLECTION parameters:paramDic success:^(id responseObject, NSInteger code) {
//        result(code);
//    } fail:^{
//        result(0);
//    }];
    [self http2RequestWithUrl:ACTION_PROJECT_ORDER_COLLECTION parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}
@end
