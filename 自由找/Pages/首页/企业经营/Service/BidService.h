//
//  BidService.h
//  自由找
//
//  Created by guojie on 16/6/22.
//  Copyright © 2016年 zyz. All rights reserved.
//  招投标项目service

#import "BaseService.h"
#import "ResponseBid.h"
#import "BidDomain.h"
#import "QualificaDomian.h"

@interface BidService : BaseService

/**
 *  发布招投标项目
 *
 *  @param parameters <#parameters description#>
 *  @param result     <#result description#>
 */
- (void)addBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

/**
 *  查询招投标项目列表
 *
 *  @param parameters
 *  @param result
 */
- (void)queryBidListWithParameters:(NSDictionary *)parameters result:(void (^)(ResponseBid *responseBid, NSInteger code))result;

/**
 *  查询单个招投标项目列表信息
 *
 *  @param Id     招投标项目ID
 *  @param result <#result description#>
 */
- (void)queryBidListByID:(NSString *)Id result:(void (^)(BidListDomain *bidListInfo, NSInteger code))result;

/**
 *  查询招投标项目明细
 *
 *  @param parameters <#parameters description#>
 *  @param result     <#result description#>
 */
- (void)queryBidDetailWithParameters:(NSDictionary *)parameters result:(void (^)(NSDictionary *bid, NSInteger code))result;

/**
 *  招投标项目报名
 *
 *  @param parameters <#parameters description#>
 *  @param result     <#result description#>
 */
- (void)applyBidWithParameters:(NSDictionary *)parameters result:(void (^)(NSDictionary *paramDic,  NSInteger code))result;

/**
 *  查看符合我项目的企业
 *
 *  @param parameters <#parameters description#>
 *  @param result     <#result description#>
 */
- (void)viewBidCompanyWithParameters:(NSDictionary *)parameters result:(void (^)(QualificaDomian *qualitifics, NSInteger code))result;

@end
