//
//  BaseDomain.h
//  奔跑兄弟
//
//  Created by guojie on 16/4/22.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDomain : NSObject

//+ (id)domain;

+ (id)domainWithObject:(NSObject *)dataSource;

/**
 *  通过dictionary自动赋值生成对象
 *
 *  @param dataSource == dictionary
 *
 *  @return YES -- 赋值成功, NO -- 失败
 */
- (BOOL)jx_setDataFromObject:(NSObject*)dataSource;

/**
 *  对象转换为dictionary
 *
 *  @return
 */
- (NSDictionary *)toDictionary;

/**
 *  利用runtime归档对象
 *  子类直接调用该方法，自动对属性进行归档
 *
 *  @param aCoder
 */
- (void)jx_encodeWithCoder:(NSCoder *)aCoder;

/**
 *  利用runtime解档对象
 *  子类直接调用该方法，自动对属性进行解档
 *
 *  @param aDecoder
 */
- (void)jx_decodeWithCoder:(NSCoder *)aDecoder;


@end
