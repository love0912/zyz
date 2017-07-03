//
//  QualificaService.h
//  自由找
//
//  Created by xiaoqi on 16/7/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseService.h"
#import "QualificaDomian.h"
@interface QualificaService : BaseService
/**
 *   资质查询列表
 *
 *  @param parameters
 *  @param result
 */
- (void)queryQualificaListWithParameters:(NSDictionary *)parameters result:(void (^)(QualificaDomian *responseBid, NSInteger code))result;
/**
 *   诚信得分
 *
 *  @param parameters
 *  @param result
 */
-(void)creditsettingWithParameters:(NSDictionary *)parameters result:(void (^)(NSArray<KeyValueDomain *> *responseBid, NSInteger code))result;
/**
 *   企业展示—最近注册
 *
 *  @param parameters
 *  @param result
 */
-(void)companyRegistresult:(void (^)(NSArray<CompanyListDomian *> *bidList, NSInteger code))result;

/**
 *  获取积分类别
 *  type 0 查询、 1 编辑
 *  @param result <#result description#>
 */
- (void)getCreditTypeWithRegionCode:(NSString *)regionCode type:(NSInteger)type result:(void (^)(NSArray *creditTypes, NSInteger code))result;
@end
