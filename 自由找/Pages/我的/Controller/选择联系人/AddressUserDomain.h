//
//  AddressUserDomain.h
//  自由找
//
//  Created by guojie on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"

@interface AddressUserDomain : BaseDomain

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *phones;
@property (nonatomic, assign) NSInteger sectionNum;
@property (nonatomic, assign) NSInteger originIndex;

- (NSString *)getFirstName;


@end
