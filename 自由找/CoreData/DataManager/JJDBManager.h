//
//  JJDBManager.h
//  FreeJob
//
//  Created by guojie on 15/11/25.
//  Copyright © 2015年 yutonghudong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "singleton.h"

@interface JJDBManager : NSObject
singleton_interface(JJDBManager)

#pragma mark - 属性
#pragma mark 数据库引用，使用它进行数据库操作
@property (nonatomic, strong) NSManagedObjectContext *context;

#pragma mark - 共有方法
/**
 *  打开数据库
 *
 *  @param dbname 数据库名称
 */
-(NSManagedObjectContext *)createDbContext;

@end
