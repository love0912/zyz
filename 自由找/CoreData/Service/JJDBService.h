//
//  JJDBService.h
//  FreeJob
//
//  Created by guojie on 15/11/25.
//  Copyright © 2015年 yutonghudong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Singleton.h"
#import "Project.h"

@interface JJDBService : NSObject
singleton_interface(JJDBService)

@property (nonatomic,strong) NSManagedObjectContext *context;

/**
 *  添加项目
 *
 *  @param u
 */
-(BOOL)addProject:(Project *)project userId:(NSString *)userId;

/**
 *  查询项目列表
 *
 *
 *  @return 枚举对象
 */
-(NSArray *)getProjectByUserId:(NSString *)userId;

/**
 *  通过项目ID查询项目
 *
 *  @param projectId <#projectId description#>
 *
 *  @return <#return value description#>
 */
- (Project *)getProjectByProjectId:(NSString *)projectId userId:(NSString *)userId;

- (BOOL)isRepeatProjectByID:(NSString *)projectId userId:(NSString *)userId;

/**
 *  删除项目
 */
- (BOOL)removeProjectByProjectId:(NSString *)projectId userId:(NSString *)userId;

- (BOOL)editProject:(Project *)project;

@end
