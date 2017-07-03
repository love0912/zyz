//
//  MineService.h
//  自由找
//
//  Created by guojie on 16/6/20.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseService.h"
#import "ScoreDomain.h"

@interface MineService : BaseService

/**
 *  注册
 *
 *  @param parameters <#parameters description#>
 *  @param result     回调返回
 */
- (void)registUserWithParameters:(NSDictionary *)parameters result:(void (^)(UserDomain *user, NSInteger code))result;

/**
 *  登录
 *
 *  @param parameters <#parameters description#>
 *  @param result     <#result description#>
 */
- (void)loginWithParameters:(NSDictionary *)parameters result:(void (^)(UserDomain *user, NSInteger code))result;

/**
 *  自动登录验证
 *
 *  @param version <#version description#>
 *  @param result  <#result description#>
 */
- (void)autoLoginToresult:(void (^)(UserDomain *user, NSInteger code))result;

/**
 *  修改用户资料
 *
 *  @param parameters <#parameters description#>
 *  @param result     返回用户对象
 */
- (void)modifyUserInfoWithParameters:(NSDictionary *)parameters result:(void (^)(UserDomain *user, NSInteger code))result;

/**
 *  重置密码
 *
 *  @param parameters
 *  @param result
 */
- (void)resetPasswordWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

/**
 *  退出登录
 *
 *  @param result <#result description#>
 */
- (void)logoutToResult:(void (^)(NSInteger code))result;

/**
 *  绑定企业
 *
 *  @param parameters <#parameters description#>
 *  @param result     <#result description#>
 */
- (void)bindCompanyWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

/**
 *  解除绑定企业
 *
 *  @param result     <#result description#>
 */
- (void)unbindCompanyToResult:(void (^)(NSInteger code))result;

/**
 *  添加新企业
 *
 *  @param parameters <#parameters description#>
 *  @param result     <#result description#>
 */
- (void)addNewCompanyWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

/**
 *  修改企业信息
 *
 *  @param parameters
 *  @param result
 */
- (void)modifyCompanyWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

/**
 *  获取我的积分明细
 *
 *  @param type   1/2 获取/消费
 *  @param result <#result description#>
 */
- (void)queryScoreWithType:(NSInteger)type page:(NSInteger)page result:(void (^)(NSString *total, NSArray<ScoreDomain *> *arr_score, NSInteger code))result;
@end