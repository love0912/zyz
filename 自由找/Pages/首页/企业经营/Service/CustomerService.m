//
//  CustomerService.m
//  自由找
//
//  Created by xiaoqi on 16/6/27.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "CustomerService.h"

@implementation CustomerService
-(void)addCustomerUserWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result{

    [self httpRequestWithUrl:ACTION_CUSTOMER_ADD parameters:parameters success:^(id responseObject) {
        
    } fail:^{
        
    }];
}
@end
