//
//  EvaluateDomain.h
//  自由找
//
//  Created by guojie on 16/8/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
#import "UserDomain.h"

@interface EvaluateDomain : BaseDomain

@property (strong, nonatomic) NSString *Score;

@property (strong, nonatomic) NSString *Reason;

@property (strong, nonatomic) NSString *Content;

@property (strong, nonatomic) NSString *UserName;

@property (strong, nonatomic) NSString *UserHeadImgUrl;

/**
 *  (订单时间)
 */
@property (strong, nonatomic) NSString *PODt;

/**
 *  订单金额
 */
@property (strong, nonatomic) NSString *POAmount;

/**
 *  “1”匿名   “0”实名
 */
@property (strong, nonatomic) NSString *IsAnonymous;

@end
