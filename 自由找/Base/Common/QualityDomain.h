//
//  QualityDomain.h
//  自由找
//
//  Created by guojie on 16/6/28.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"
#import "UserDomain.h"
#import "KeyDefine.h"

@interface QualityDomain : BaseDomain

@property (strong, nonatomic) NSString *key;

@property (strong, nonatomic) NSString *value;

@property (strong, nonatomic) NSArray<KeyValueDomain *> *SubCollection;

@end
