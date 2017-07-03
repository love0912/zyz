//
//  QualificaService.m
//  自由找
//
//  Created by xiaoqi on 16/7/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "QualificaService.h"

@implementation QualificaService
-(void)queryQualificaListWithParameters:(NSDictionary *)parameters result:(void (^)(QualificaDomian *responseBid, NSInteger code))result{
    [self httpRequestWithUrl:ACTION_COMPANY_SHOW parameters:parameters success:^(id responseObject, NSInteger code) {
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

-(void)creditsettingWithParameters:(NSDictionary *)parameters result:(void (^)(NSArray<KeyValueDomain *> *responseBid, NSInteger code))result{
    [self httpRequestWithUrl:ACTION_COMMON_CREDIT parameters:parameters success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *bidList = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                KeyValueDomain *bid = [KeyValueDomain domainWithObject:tmpDic];
                [bidList addObject:bid];
            }
            result(bidList, 1);
        } else {
            result(nil, code);
        }

    } fail:^{
        result(nil, 0);
    }];
}
-(void)companyRegistresult:(void (^)(NSArray<CompanyListDomian *> *bidList, NSInteger code))result{
    [self  httpRequestWithUrl:ACTION_COMPANY_REGIST success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = [responseObject objectForKey:kResponseDatas];
            NSMutableArray *bidList = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                CompanyListDomian *bid = [CompanyListDomian domainWithObject:tmpDic];
                [bidList addObject:bid];
            }
            result(bidList, 1);
        } else {
            result(nil, code);
        }
    } fail:^{
        result(nil, 0);
    }];
}

/**
 *  获取积分类别
 *  type 0 查询、 1 编辑
 *  @param result <#result description#>
 */
- (void)getCreditTypeWithRegionCode:(NSString *)regionCode type:(NSInteger)type result:(void (^)(NSArray *creditTypes, NSInteger code))result {
    NSDictionary *paramDic = @{@"RegionCode": regionCode, @"Type":@(type)};
    [self httpRequestWithUrl:ACTION_COMMON_CREDIT_TYPE parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *creditType = [responseObject objectForKey:kResponseDatas][@"Items"];
            result(creditType, code);
        } else {
//            [ProgressHUD showInfo:responseObject[kResponseMsg] withSucc:NO withDismissDelay:2];
            result(nil, code);
        }
    } fail:^{
        result(nil, 0);
    }];
}
@end
