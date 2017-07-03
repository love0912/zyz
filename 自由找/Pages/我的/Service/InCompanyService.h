//
//  InCompanyService.h
//  自由找
//
//  Created by xiaoqi on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseService.h"
#import "InCompanyDomain.h"
@interface InCompanyService : BaseService
//查询企业
-(void)inCompanywithParamters:(NSDictionary *)parameters result:(void (^)(NSArray<InCompanyDomain *> *user, NSInteger code))result;
- (NSArray *)searchWithKey:(NSString *)key InMessageArray:(NSArray *)messages;
//认领企业
-(void)userCalimWithParameters:(NSDictionary *)parameters result:(void (^)(NSUInteger code))result;
//修改认领企业经营区域
-(void)userchangecompanyregion:(NSDictionary *)parameters result:(void (^)(NSUInteger code))result;

//认领企业，从资质查询页详情过来
- (void)updateFromCompanyWithParameters:(NSDictionary *)parameters result:(void (^)(NSUInteger code))result;
@end
