//
//  ProductInfoDomain.h
//  自由找
//
//  Created by guojie on 16/8/11.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
#import "EvaluateDomain.h"

@interface ProductDetailsDomain : BaseDomain

@property (strong, nonatomic) NSString *RegionCount;

@property (strong, nonatomic) NSString *CommentCount;

@property (strong, nonatomic) EvaluateDomain *CommentTopItem;

@end
