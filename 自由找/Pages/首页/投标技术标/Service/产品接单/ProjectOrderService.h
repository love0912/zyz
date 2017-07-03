//
//  ProjectOrderService.h
//  自由找
//
//  Created by guojie on 16/8/12.
//  Copyright © 2016年 zyz. All rights reserved.
//

/**
 *  项目接单
 */

#import "BaseService.h"
#import "ProjectOrderDomain.h"
#import "ProjectOrderTypeDomain.h"
#import "OurProjectOrderDomain.h"
#import "SupplementDomain.h"

@interface ProjectOrderService : BaseService

/**
 *  获取接单列表
 *
 *  @param productType 1-技术   2-预算
 *  @param region      <#region description#>
 *  @param projectType <#projectType description#>
 *  @param page        <#page description#>
 *  @param result      <#result description#>
 */
- (void)getProjectOrderByProductType:(NSString *)productType region:(NSDictionary *)region projectType:(NSDictionary *)projectType page:(NSInteger)page result:(void(^)(NSInteger code, NSArray<ProjectOrderDomain *> *orders))result;

/**
 *  申请接单 -- 返回接单类别
 *
 *  @param projectID 项目ID
 *  @param result    <#result description#>
 */
- (void)applyReciveOrderByProjectID:(NSString *)projectID productType:(NSInteger)productType result:(void(^)(NSInteger code, NSArray<ProjectOrderTypeDomain *> *orderTypes))result;

/**
 获取接单订单类别列表
 
 @param projectID   <#projectID description#>
 @param productType <#productType description#>
 @param result      <#result description#>
 */
- (void)getProjectOrderTypeByProjectID:(NSString *)projectID productType:(NSInteger)productType result:(void(^)(NSInteger code, NSString *orderTypes))result;

/**
 *  确认接单 -- 确认支付
 *
 *  @param typeID   类型ID
 *  @param quantity 数量
 *  @param result   <#result description#>
 */
- (void)confirmOrderByOrderTypeID:(NSString *)typeID quantity:(NSString *)quantity payPass:(NSString *)payPass result:(void(^)(NSInteger code,NSString *msg))result;

/**
 *  获取我的接单
 *
 *  @param page   <#page description#>
 *  @param result <#result description#>
 */
- (void)getOurProjectOrderByPage:(NSInteger)page result:(void(^)(NSInteger code, NSArray<OurProjectOrderDomain *> *orders))result;

/**
 *  查看补遗
 *
 *  @param projectID 项目ID
 *  @param page      <#page description#>
 *  @param result    <#result description#>
 */
- (void)getProjectSupplementByProjectID:(NSString *)projectID page:(NSInteger)page result:(void(^)(NSInteger code, NSArray<SupplementDomain *> *supplements))result;

/**
 *  我的收藏 -- 接单项目
 *
 *  @param page   <#page description#>
 *  @param result <#result description#>
 */
- (void)getOurCollectionByPage:(NSInteger)page result:(void(^)(NSInteger code, NSArray *orders))result;
/**
 *  删除我的收藏 -- 接单项目
 *
 *  @param page   <#page description#>
 *  @param result <#result description#>
 */
- (void)deletecollectProjectByProjectID:(NSString *)projectID result:(void(^)(NSInteger code))result;

/**
 *  删除我的收藏 -- 新的接口
 *
 *  @param page   <#page description#>
 *  @param result <#result description#>
 */
- (void)deletecollectByID:(NSString *)ID productType:(NSString *)productType result:(void(^)(NSInteger code))result;

/**
 *  收藏项目
 *
 *  @param projectID 项目ID
 *  @param result    <#result description#>
 */
- (void)collectProjectByProjectID:(NSString *)projectID result:(void(^)(NSInteger code))result;

@end
