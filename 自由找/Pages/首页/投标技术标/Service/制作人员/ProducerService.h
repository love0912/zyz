//
//  ProducerService.h
//  自由找
//
//  Created by guojie on 16/8/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseService.h"
#import "ProducerDomain.h"

@interface ProducerService : BaseService

/**
 *  创建用户认证信息 -- 制作人员
 *
 *  @param producer
 *  @param result   <#result description#>
 */
- (void)createProducerWithDictionary:(NSDictionary *)producer result:(void(^)(NSInteger code))result;
/**
 *  修改用户认证信息 -- 制作人员
 *
 *  @param producer
 *  @param result   <#result description#>
 */
- (void)updateProducerWithDictionary:(NSDictionary *)producer result:(void(^)(NSInteger code))result;

/**
 *  查看自己认证信息
 *
 *  @param result
 */
- (void)getSelfInfoToResult:(void(^)(NSInteger code, ProducerDomain *producer))result;

/**
 *  认证
 *
 *  @param fronUrlString 身份证前面urlstring
 *  @param backUrlString 身份证背面urlstring
 *  @param result
 */
- (void)authProducerWithIDFronUrlString:(NSString *)fronUrlString IDBackUrlString:(NSString *)backUrlString  CertificateUrlString:(NSString *)certificateUrlString   result:(void(^)(NSInteger code))result;
/**
 *  擅长领域
 *
 *  @param result
 */
- (void)goodFiledResult:(void(^)(NSArray<KeyValueDomain *>*goodFiledList,NSInteger code))result;

@end
