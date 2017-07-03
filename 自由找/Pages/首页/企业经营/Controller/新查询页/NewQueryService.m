//
//  NewQueryService.m
//  zyz
//
//  Created by 郭界 on 17/1/5.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "NewQueryService.h"

@implementation NewQueryService

/**
 *  获取地区
 *
 *  @param result 所有地区列表key-value
 */
- (void)getAlisRegionToResult:(void (^)(NSArray<KeyValueDomain *> *regionList, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_COMMON_GET_REGION_Alias  parameters:nil success:^(id responseObject, NSInteger code) {
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
        
    } fail:^(id errorObject){
        result(nil, 0);
    }];
}

/**
 *  获取工程类别
 */
- (void)getNewQueryProjectTypeToResult:(void (^)(NSArray<KeyValueDomain *> *projectTypeList, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_NEWQUERY_GET_PROJECT_TYPE  parameters:nil success:^(id responseObject, NSInteger code) {
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
        
    } fail:^(id errorObject){
        result(nil, 0);
    }];
}

/**
 *  获取工程用途
 */
- (void)getNewQueryProjectApplicationToResult:(void (^)(NSArray<KeyValueDomain *> *projectApplicationList, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_NEWQUERY_GET_PROJECT_APPLICATION parameters:nil success:^(id responseObject, NSInteger code) {
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
        
    } fail:^(id errorObject){
        result(nil, 0);
    }];
}

/**
 *  获取单位
 */
- (void)getNewQueryUnitWithType:(NSInteger)type result:(void (^)(NSArray<KeyValueDomain *> *unitList, NSInteger code))result {
    NSDictionary *paramDic = @{@"Type": @(type)};
    [self httpRequestWithUrl:ACTINO_NEWQUERY_GET_UNIT parameters:paramDic success:^(id responseObject, NSInteger code) {
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

/**
 获取人员类型
 
 @param type 1 -- 注册类  2 -- 职称类  4 -- 现场管理类
 @param result <#result description#>
 */
- (void)getMemberTypeWityType:(NSInteger)type result:(void (^)(NSArray * typeArray, NSInteger code))result {
    NSDictionary *paramDic = @{@"MemberType": @(type)};
    [self httpRequestWithUrl:ACTINO_NEWQUERY_GET_MEMBER_TYPE parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSMutableArray *arr_type = [NSMutableArray arrayWithCapacity:0];
            NSArray *tmpArray = responseObject[kResponseDatas];
            for (NSDictionary *tmpDic in tmpArray) {
                KeyValueDomain *domain = [[KeyValueDomain alloc] init];
                domain.Key = tmpDic[kCommonKey];
                domain.Value = tmpDic[kCommonValue];
                NSArray *tmpArray2 = tmpDic[kQualitySubCollection];
                NSMutableArray *subArray = [NSMutableArray arrayWithCapacity:tmpArray2.count];
                for (NSDictionary *tmpDic2 in tmpArray2) {
                    KeyValueDomain *domain2 = [KeyValueDomain domainWithObject:tmpDic2];
                    [subArray addObject:domain2];
                }
                domain.SubCollection = subArray;
                [arr_type addObject:domain];
            }
            result(arr_type, code);
        } else {
            result(nil, code);
        }
    } fail:^(id errorObject) {
        result(nil, 0);
    }];
}

/**
 *  获取技术人员数量
 */
- (void)getMemberTypeCountWithTypeKey:(NSString *)key result:(void (^)(NSArray<KeyValueDomain *> *countList, NSInteger code))result {
    NSDictionary *paramDic = @{@"CategoryKey": key};
    [self httpRequestWithUrl:ACTINO_NEWQUERY_GET_MEMBER_TYPE_COUNT parameters:paramDic success:^(id responseObject, NSInteger code) {
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

/**
 查询业绩
 
 @param type 0—建造师  1 ---项目名称
 @param name 关键字
 @param oId 企业业绩使用 -- 企业ID
 @param page 页码
 @param sign 签名
 @param result <#result description#>
 */
- (void)getProjectPerformanceWithSearchType:(NSInteger)type name:(NSString *)name companyOId:(NSString *)oId page:(NSInteger)page result:(void (^)(NSArray<PerformanceDoamin *> *performList, NSInteger code))result {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (oId == nil) {
        [paramDic setObject:@(type) forKey:@"QueryType"];
        [paramDic setObject:name forKey:@"Name"];
    } else {
        [paramDic setObject:oId forKey:@"CompanyOId"];
    }
    [paramDic setObject:@(page) forKey:kPage];
    [self httpRequestWithUrl:ACTION_NEWQUERY_GET_PERFORMLIST parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *arr_perform = [NSMutableArray arrayWithCapacity:tmpArray.count];
            for (NSDictionary *tmpDic in tmpArray) {
                PerformanceDoamin *perform = [PerformanceDoamin domainWithObject:tmpDic];
                [arr_perform addObject:perform];
            }
            result(arr_perform, code);
        } else {
            result(nil, code);
        }
    } fail:^(id errorObject) {
        result(nil, 0);
    }];
    
}

/**
 资质查询 -- 新
 
 @param name 企业名称
 @param regionKey 省市key
 @param regionType 企业要求
 @param apArray 资质条件
 @param performanceDic 业绩条件
 @param memberDic 人员条件
 @param creditsDic 诚信得分条件
 @param page 页数
 @param result <#result description#>
 */
- (void)getCompanyByName:(NSString *)name
               regionKey:(NSString *)regionKey
              regionType:(NSInteger)regionType
     aptitudeFilterOfDic:(NSDictionary *)apDic
  performanceFilterOfDic:(NSDictionary *)performanceDic
       memberFilterOfDic:(NSDictionary *)memberDic
            creditsOfDic:(NSDictionary *)creditsDic
            pageOfNumber:(NSInteger)page
                  result:(void(^)(QualificaDomian *responseBid, NSInteger code))result {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObject:@(page) forKey:kPage];
    if ([name isNotEmptyString]) {
        [paramDic setObject:name forKey:@"CompanyName"];
    }
    if ([regionKey isNotEmptyString]) {
        [paramDic setObject:regionKey forKey:@"RegionCode"];
        [paramDic setObject:@(regionType) forKey:@"RegionType"];
    }
    if (apDic != nil && apDic.count > 0) {
        [paramDic setObject:apDic forKey:@"AptitudeFilters"];
    }
    if (performanceDic != nil && performanceDic.count > 0) {
        [paramDic setObject:performanceDic forKey:@"PerformanceFilters"];
    }
    if (memberDic != nil && memberDic.count > 0) {
        [paramDic setObject:memberDic forKey:@"MemberFilters"];
    }
    if (creditsDic != nil && creditsDic.count > 0) {
        [paramDic setObject:creditsDic forKey:@"Credits"];
    }
    [self httpRequestWithUrl:ACTION_NEWQUERY_GET_COMPANY parameters:paramDic success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            QualificaDomian *qualifica = [QualificaDomian domainWithObject:responseObject[kResponseDatas]];
            result(qualifica, 1);
        } else {
            result(nil, code);
        }
    } fail:^(id errorObject) {
        result(nil, 0);
    }];
}

/**
 获取查询服务列表
 
 @param result <#result description#>
 */
- (void)getQueryServiceListResult:(void(^)(NSArray<BuyQueryDomain *> *list, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_NEWQUERY_GET_QUERYSERVICE_LIST success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            NSArray *tmpArray = responseObject[kResponseDatas];
            NSMutableArray *serviceList = [NSMutableArray arrayWithCapacity:tmpArray.count];
            [tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *tmpDic = obj;
                BuyQueryDomain *queryService = [BuyQueryDomain domainWithObject:tmpDic];
                [serviceList addObject:queryService];
            }];
            result(serviceList, code);
        } else {
            result(nil, code);
        }
    } fail:^{
        result(nil, 0);
    }];
}

/**
 购买查询服务
 
 @param serviceOId <#serviceOId description#>
 @param password <#password description#>
 @param result <#result description#>
 */
- (void)buyQueryServiceByOId:(NSString *)serviceOId password:(NSString *)password result:(void(^)(NSInteger code))result {
    NSDictionary *paramDic = @{@"ServiceOId": serviceOId, @"PayPwd": [CommonUtil getMd5_32Bit:password]};
    [self httpRequestWithUrl:ACTION_BUY_QUERYSERVICE parameters:paramDic success:^(id responseObject, NSInteger code) {
        result(code);
    } fail:^{
        result(0);
    }];
}

/**
 获取人员类型的区域
 
 @param result <#result description#>
 */
- (void)getMembersResult:(void(^)(NSArray *resultArray, NSInteger code))result {
    [self httpRequestWithUrl:ACTION_GET_MEMBER_REGION success:^(id responseObject, NSInteger code) {
        if (code == 1) {
            result(responseObject[kResponseDatas], code);
        } else {
            result(nil, code);
        }
    } fail:^{
        result(nil, 0);
    }];
}
@end
