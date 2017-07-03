//
//  ProducerService.m
//  自由找
//
//  Created by guojie on 16/8/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "ProducerService.h"

@implementation ProducerService

/**
 *  创建用户认证信息 -- 制作人员
 *
 *  @param producer
 *  @param result   <#result description#>
 */
- (void)createProducerWithDictionary:(NSDictionary *)producer result:(void(^)(NSInteger code))result {
//    [self httpRequestWithUrl:ACTION_PRODUCER_CREATE_AUTH_INFO parameters:producer success:^(id responseObject, NSInteger code) {
//        result(code);
//    } fail:^{
//        result(0);
//    }];
    [self http2RequestWithUrl:ACTION_PRODUCER_CREATE_AUTH_INFO parameters:producer success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];
}
/**
 *  修改用户认证信息 -- 制作人员
 *
 *  @param producer
 *  @param result   <#result description#>
 */
- (void)updateProducerWithDictionary:(NSDictionary *)producer result:(void(^)(NSInteger code))result{
//    [self httpRequestWithUrl:ACTION_PRODUCER_CREATE_AUTH_INFO parameters:producer success:^(id responseObject, NSInteger code) {
//        result(code);
//    } fail:^{
//        result(0);
//    }];
    [self http2RequestWithUrl:ACTION_PRODUCER_UPDATE_AUTH_INFO parameters:producer success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];

}

/**
 *  查看自己认证信息
 *
 *  @param result
 */
- (void)getSelfInfoToResult:(void(^)(NSInteger code, ProducerDomain *producer))result {
//    [self httpRequestWithUrl:ACTION_PRODUCER_GET_DETAIL success:^(id responseObject, NSInteger code) {
//        if (code == 1) {
//            ProducerDomain *producer = [ProducerDomain domainWithObject:responseObject[kResponseDatas]];
//            result(code, producer);
//        } else {
//            result(code, nil);
//        }
//    } fail:^{
//        result(0, nil);
//    }];
    [self background2RequestWithUrl:ACTION_PRODUCER_GET_DETAIL parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            ProducerDomain *producer = nil;
            if (![responseObject[kResponseDatas] isKindOfClass:[NSNull class]]) {
                producer =[ ProducerDomain domainWithObject:responseObject[kResponseDatas]];
            }
            result(code, producer);
        } else {
            result(code, nil);
        }
    } fail:^(id errorObject) {
        result(0, nil);
    }];

}

/**
 *  认证
 *
 *  @param fronUrlString 身份证前面urlstring
 *  @param backUrlString 身份证背面urlstring
 *  @param result
 */
- (void)authProducerWithIDFronUrlString:(NSString *)fronUrlString IDBackUrlString:(NSString *)backUrlString CertificateUrlString:(NSString *)certificateUrlString result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"IdentityFrontSideUrl": fronUrlString, @"IdentityBackSideUrl": backUrlString,@"CertificateUrl":certificateUrlString};
//    [self httpRequestWithUrl:ACTION_PRODUCER_AUTH parameters:paramDic success:^(id responseObject, NSInteger code) {
//        result(code);
//    } fail:^{
//        result(0);
//    }];
    [self http2RequestWithUrl:ACTION_PRODUCER_AUTH parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^(id errorObject) {
        result(0);
    }];

}
/**
 *  擅长领域
 *
 *  @param result
 */
- (void)goodFiledResult:(void(^)(NSArray<KeyValueDomain *>*goodFiledList,NSInteger code))result{
//    [self httpRequestWithUrl:ACTION_PRODUCER_FoodFiled  success:^(id responseObject, NSInteger code) {
//        if (code == 1) {
//            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
//            NSMutableArray *arr_region = [NSMutableArray arrayWithCapacity:tmpArray.count];
//            for (NSDictionary *tmpDic in tmpArray) {
//                KeyValueDomain *domain = [KeyValueDomain domainWithObject:tmpDic];
//                [arr_region addObject:domain];
//            }
//            result(arr_region, code);
//        } else {
//            result(nil, code);
//        }
//    } fail:^{
//        result(nil, 0);
//    }];
    [self http2RequestWithUrl:ACTION_PRODUCER_FoodFiled parameters:nil success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *arr_region = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                KeyValueDomain *domain = [KeyValueDomain domainWithObject:tmpDic];
                [arr_region addObject:domain];
            }
            result(arr_region, code);
        } else {
            result(nil, code);
        }
    } fail:^(id errorObject) {
        result(nil, 0);
    }];

}

@end
