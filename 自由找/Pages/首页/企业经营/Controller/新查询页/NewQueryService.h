//
//  NewQueryService.h
//  zyz
//
//  Created by 郭界 on 17/1/5.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "BaseService.h"
#import "PerformanceDoamin.h"
#import "QualificaDomian.h"
#import "BuyQueryDomain.h"

@interface NewQueryService : BaseService

/**
 *  获取地区
 *
 *  @param result 所有地区列表key-value
 */
- (void)getAlisRegionToResult:(void (^)(NSArray<KeyValueDomain *> *regionList, NSInteger code))result;

/**
 *  获取工程类别
 */
- (void)getNewQueryProjectTypeToResult:(void (^)(NSArray<KeyValueDomain *> *projectTypeList, NSInteger code))result;

/**
 *  获取工程用途
 */
- (void)getNewQueryProjectApplicationToResult:(void (^)(NSArray<KeyValueDomain *> *projectApplicationList, NSInteger code))result;


/**
 *  获取单位
 */
- (void)getNewQueryUnitWithType:(NSInteger)type result:(void (^)(NSArray<KeyValueDomain *> *unitList, NSInteger code))result;


/**
 获取人员类型

 @param type 1 -- 注册类  2 -- 职称类  4 -- 现场管理类
 @param result <#result description#>
 */
- (void)getMemberTypeWityType:(NSInteger)type result:(void (^)(NSArray * typeArray, NSInteger code))result;

/**
 *  获取技术人员数量
 */
- (void)getMemberTypeCountWithTypeKey:(NSString *)key result:(void (^)(NSArray<KeyValueDomain *> *countList, NSInteger code))result;


/**
 查询业绩

 @param type 0—建造师  1 ---项目名称
 @param name 关键字
 @param oId 企业业绩使用 -- 企业ID
 @param page 页码
 @param sign 签名
 @param result <#result description#>
 */
- (void)getProjectPerformanceWithSearchType:(NSInteger)type name:(NSString *)name companyOId:(NSString *)oId page:(NSInteger)page result:(void (^)(NSArray<PerformanceDoamin *> *performList, NSInteger code))result;


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
                  result:(void(^)(QualificaDomian *responseBid, NSInteger code))result;



/**
 获取查询服务列表

 @param result <#result description#>
 */
- (void)getQueryServiceListResult:(void(^)(NSArray<BuyQueryDomain *> *list, NSInteger code))result;


/**
 购买查询服务

 @param serviceOId <#serviceOId description#>
 @param password <#password description#>
 @param result <#result description#>
 */
- (void)buyQueryServiceByOId:(NSString *)serviceOId password:(NSString *)password result:(void(^)(NSInteger code))result;

/**
 获取人员类型的区域

 @param result <#result description#>
 */
- (void)getMembersResult:(void(^)(NSArray *resultArray, NSInteger code))result;
@end
