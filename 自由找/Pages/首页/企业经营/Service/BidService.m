//
//  BidService.m
//  自由找
//
//  Created by guojie on 16/6/22.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BidService.h"

@implementation BidService

- (void)addBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result {
    [self httpRequestWithUrl:ACTION_BID_ADD parameters:parameters success:^(id responseObject, NSInteger code) {
        //发布成功
        result(code);
    } fail:^{
        result(0);
    }];
}

- (void)queryBidListWithParameters:(NSDictionary *)parameters result:(void (^)(ResponseBid *responseBid, NSInteger code))result {
    [self backgroundRequestWithUrl:ACTION_BID_LIST parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            ResponseBid *bid = [ResponseBid domainWithObject:responseObject[kResponseDatas]];
            result(bid, 1);
        } else {
            result(nil, code);
        }
        
    } fail:^{
        result(nil, 0);
    }];
}

- (void)queryBidListByID:(NSString *)Id result:(void (^)(BidListDomain *bidListInfo, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_BID_LIST_BYID parameters:@{kBidProjectID: Id} success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            BidListDomain *domain = [BidListDomain domainWithObject:responseObject[kResponseDatas]];
            result(domain, 1);
        } else {
            result(nil, code);
        }
        
    } fail:^{
        result(nil, 0);
    }];
}

- (void)queryBidDetailWithParameters:(NSDictionary *)parameters result:(void (^)(NSDictionary *bidDic, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_BID_DETAIL parameters:parameters success:^(id responseObject, NSInteger code) {
        
//        BidDomain *bid = [BidDomain domainWithObject:responseObject[kResponseDatas]];
        if (code == 1) {
            result(responseObject[kResponseDatas], 1);
        } else {
            result(nil, code);
        }
        
    } fail:^{
        result(nil, 0);
    }];
}

- (void)applyBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSDictionary *paramDic,  NSInteger code))result {
    [self httpRequestWithUrl:ACTION_BID_ATTENTION parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            result(responseObject, 1);
        } else {
            result(responseObject, code);
        }
    } fail:^(id errorObject) {
        result(nil, 0);
    }];
}

/**
 *  查看符合我项目的企业
 *
 *  @param parameters <#parameters description#>
 *  @param result     <#result description#>
 */
- (void)viewBidCompanyWithParameters:(NSDictionary *)parameters result:(void (^)(QualificaDomian *qualitifics, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_BID_VIEW_BIDCOMPANY parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            QualificaDomian *qualifica = [QualificaDomian domainWithObject:responseObject[kResponseDatas]];
            result(qualifica, 1);
        } else {
            result(nil, code);
        }
        
    } fail:^{
        result(nil, 0);
    }];
}

@end
