//
//  OrderRefundDomain.h
//  自由找
//
//  Created by guojie on 16/8/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
#import "UserDomain.h"

@interface OrderRefundDomain : BaseDomain

/**
 *  退款状态 -- 1申请退款中， 2退款失败，3退款成功
 */
@property (strong, nonatomic) NSString *Status;

@property (strong, nonatomic) NSString *ProjectName;

@property (strong, nonatomic) NSString *RequestDt;

@property (strong, nonatomic) NSString *Reason;

@property (strong, nonatomic) NSString *Feedback;

@end
