//
//  CustomerService.h
//  自由找
//
//  Created by xiaoqi on 16/6/27.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseService.h"

@interface CustomerService : BaseService
/**
 *  客户管理--新增(3.0)
 */
-(void)addCustomerUserWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

@end
