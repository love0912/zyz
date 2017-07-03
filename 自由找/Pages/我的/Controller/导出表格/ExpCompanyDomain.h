//
//  ExpCompanyDomain.h
//  自由找
//
//  Created by guojie on 16/7/1.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"

@interface ExpCompanyDomain : BaseDomain

/**
 *  企业名
 */
@property (strong, nonatomic) NSString *CompanyName;

/**
 *  联系人
 */
@property (strong, nonatomic) NSString *Contact;

/**
 *  联系电话
 */
@property (strong, nonatomic) NSString *Phone;

/**
 *  状态
 */
@property (strong, nonatomic) NSString *Status;

@end
