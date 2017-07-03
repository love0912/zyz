//
//  LetterPriceDomain.h
//  zyz
//
//  Created by 郭界 on 16/10/24.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"

@interface LetterPriceDomain : BaseDomain

@property (nonatomic, strong) NSString *SegmentId;


/**
 “一百万以下
 */
@property (nonatomic, strong) NSString *SegmentTitle;


/**
  范围 {Min : “0”, Max:”10000000”   }
 */
@property (nonatomic, strong) NSDictionary *Segment;


/**
 佣金
 */
@property (nonatomic, strong) NSString *SegmentFee;

@end
