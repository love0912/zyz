//
//  JoinService.h
//  自由找
//
//  Created by guojie on 16/6/23.
//  Copyright © 2016年 zyz. All rights reserved.
//
//我参与的项目的service
#import "BaseService.h"
#import "ResponseBid.h"
#import "AttentionUserList.h"
#import "AttentionBidDomain.h"
#import "ExpCompanyDomain.h"
#import "ExpBidDomain.h"

@interface JoinService : BaseService

/**
 *  我的发布--招投标项目列表
 *
 *  @param parameters <#parameters description#>
 *  @param result     <#result description#>
 */
- (void)queryOurIssueBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSArray<BidListDomain *> *bidList, NSInteger code))result;

/**
 *  查看关注用户列表
 *
 *  @param parameters <#parameters description#>
 *  @param result     <#result description#>
 */
- (void)queryAttentionUserListWithParameters:(NSDictionary *)parameters result:(void (^)(AttentionUserList *userList))result;

/**
 *  标记关注用户，同意或不同意
 *
 *  @param parameters AttentionId: 关注id,
 *                    Marker: 0/1  不同意 /同意
 *  @param result
 */
- (void)modifyAttentionUserWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

/**
 *  退回报名用户
 *
 *  @param parameters AttentionId: 关注id
 *  @param result     <#result description#>
 */
- (void)backAttentionUserWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

/**
 *  删除招投标项目
 *
 *  @param parameters ProjectId:  项目id
 *  @param result     <#result description#>
 */
- (void)delIssueBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

/**
 *  修改招投标项目
 *
 *  @param parameters ....
 *  @param result     <#result description#>
 */
- (void)modifyIssueBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

/**
 *  查询 我的报名项目列表---招投标项目
 *
 *  @param parameters Status: 1/2/4，进行中/已完成/已撤回/
 *                    Page: 请求页码(从1开始)
 *  @param result
 */
- (void)queryAttentionBidListWithParameters:(NSDictionary *)parameters result:(void (^)(NSArray<AttentionBidDomain *> *bidList))result;

/**
 *  撤回报名
 *
 *  @param parameters AttentionId:  关注id
 *  @param result     <#result description#>
 */
- (void)backAttentionBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

/**
 *  删除报名项目
 *
 *  @param parameters AttentionId:  关注id
 *  @param result     <#result description#>
 */
- (void)delAttentionBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

/**
 *  完成报名项目
 *
 *  @param parameters AttentionId:  关注id
 *  @param result     <#result description#>
 */
- (void)finishAttentionBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

/**
 *  导出项目报名用户
 *
 *  @param projectID <#projectID description#>
 *  @param result    <#result description#>
 */
- (void)exportAttentionUserWithProjectID:(NSString *)projectID result:(void (^)(NSArray<ExpCompanyDomain *> *attentionUser , NSInteger code))result;

/**
 *  导出报名项目
 *
 *  @param parameters DateBegin
 *                    DateEnd
 *  @param result
 */
- (void)exportAttentionBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSArray<ExpBidDomain *> *bids , NSInteger code))result;
@end
