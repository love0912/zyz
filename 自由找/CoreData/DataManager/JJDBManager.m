//
//  JJDBManager.m
//  FreeJob
//
//  Created by guojie on 15/11/25.
//  Copyright © 2015年 yutonghudong. All rights reserved.
//

#import "JJDBManager.h"

@implementation JJDBManager
singleton_implementation(JJDBManager)

#pragma mark 重写初始化方法
-(instancetype)init{
    JJDBManager *manager;
    if((manager=[super init]))
    {
        _context =[manager createDbContext];
    }
    return manager;
}


-(NSManagedObjectContext *)createDbContext{
    NSManagedObjectContext *context;
    //打开模型文件，参数为nil则打开包中所有模型文件并合并成一个
    NSManagedObjectModel *model=[NSManagedObjectModel mergedModelFromBundles:nil];
    //创建解析器
    NSPersistentStoreCoordinator *storeCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    //创建数据库保存路径
    NSString *dir=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path=[dir stringByAppendingPathComponent:@"jjDatabase.db"];
    NSURL *url=[NSURL fileURLWithPath:path];
    //添加SQLite持久存储到解析器
    NSError *error;
    [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if(error){
        NSLog(@"数据库打开失败！错误:%@",error.localizedDescription);
    }else{
        context=[[NSManagedObjectContext alloc]init];
        context.persistentStoreCoordinator=storeCoordinator;
        NSLog(@"数据库打开成功！");
    }
    return context;
}

@end
