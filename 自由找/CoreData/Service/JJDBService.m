//
//  JJDBService.m
//  FreeJob
//
//  Created by guojie on 15/11/25.
//  Copyright © 2015年 yutonghudong. All rights reserved.
//

#import "JJDBService.h"
#import "JJDBManager.h"
#import "BaseConstants.h"

@implementation JJDBService
singleton_implementation(JJDBService)

-(NSManagedObjectContext *)context{
    return [JJDBManager sharedJJDBManager].context;
}

-(BOOL)addProject:(Project *)project userId:(NSString *)userId {
    Project *projectEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:self.context];
    projectEntity.userId = userId;
    projectEntity.projectId = [NSNumber numberWithInteger:[project.projectId integerValue]];
    projectEntity.name = project.name;
    projectEntity.desc = project.desc;
    projectEntity.contact = project.contact;
    projectEntity.phone = project.phone;
    projectEntity.openDate = project.openDate;
    projectEntity.money = project.money;
    projectEntity.remark = project.remark;
    BOOL isSuccess = YES;
    NSError *error;
//    project.managedObjectContext = self.context;
    //保存上下文
    if (![self.context save:&error]) {
        isSuccess = NO;
        NSLog(@"添加过程中发生错误,错误信息：%@！",error.localizedDescription);
    } else {
        NSLog(@"添加成功");
    }
    return isSuccess;
}

-(NSArray *)getProjectByUserId:(NSString *)userId {
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Project"];
    //使用谓词查询是基于Keypath查询的，如果键是一个变量，格式化字符串时需要使用%K而不是%@
    request.predicate=[NSPredicate predicateWithFormat:@"%K=%@",@"userId",userId];
    NSError *error;
    //进行查询
    NSArray *results=[self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"查询过程中发生错误，错误信息：%@！",error.localizedDescription);
        return @[];
    }else{
        return results;
    }

}

- (Project *)getProjectByProjectId:(NSString *)projectId userId:(NSString *)userId {
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
    fetchRequest.predicate=[NSPredicate predicateWithFormat:@"%K=%@ and %K=%@",@"projectId",projectId, @"userId", userId];
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    Project *project = nil;
    if (!error) {
        project = fetchedObjects.firstObject;
    }
    return project;
    //实例化查询
//    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Project"];
//    //使用谓词查询是基于Keypath查询的，如果键是一个变量，格式化字符串时需要使用%K而不是%@
//    request.predicate=[NSPredicate predicateWithFormat:@"%K=%@ and %K=%@",@"projectId",projectId, @"userId", userId];
//    NSError *error;
//    Project *project;
//    //进行查询
//    NSArray *results=[self.context executeFetchRequest:request error:&error];
//    if (error) {
//        NSLog(@"查询过程中发生错误，错误信息：%@！",error.localizedDescription);
//    }else{
//        project = results.firstObject;
//    }
}

- (BOOL)isRepeatProjectByID:(NSString *)projectId userId:(NSString *)userId {
    BOOL repeat = NO;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
    fetchRequest.predicate=[NSPredicate predicateWithFormat:@"%K=%@ and %K=%@",@"projectId",projectId, @"userId", userId];
    NSError *error;
    NSInteger count = [self.context countForFetchRequest:fetchRequest error:&error];
    if (count > 0) {
        repeat = YES;
    }
    return repeat;
}

- (BOOL)removeProjectByProjectId:(NSString *)projectId userId:(NSString *)userId {
    //实例化查询
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Project"];
    //使用谓词查询是基于Keypath查询的，如果键是一个变量，格式化字符串时需要使用%K而不是%@
    request.predicate=[NSPredicate predicateWithFormat:@"%K=%@ and %K=%@",@"projectId",projectId, @"userId", userId];
    NSError *error;
    //进行查询
    NSArray *results=[self.context executeFetchRequest:request error:&error];
    for (NSManagedObject *tmpEnums in results) {
        [self.context deleteObject:tmpEnums];
    }
    BOOL isSuccess = YES;
    NSError *saveError = nil;
    if (![self.context save:&saveError]) {
        NSLog(@"删除过程中发生错误，错误信息：%@!",error.localizedDescription);
        isSuccess = NO;
    }
    return isSuccess;
}

- (BOOL)editProject:(Project *)project {
    BOOL isSuccess = YES;
    NSError *error;
    if (![self.context save:&error]) {
        isSuccess = NO;
    }
    return isSuccess;
}

//-(void)addEnumeration:(Project *)enumeration {
//    [self addEnumerationWithKey:enumeration.key value:enumeration.value enumtype:enumeration.enumtype];
//}
//
//-(void)addEnumerationWithKey:(NSString *)key value:(NSString *)value enumtype:(NSString *)enumtype {
//    //添加一个对象
//    Enumeration *enumeration= [NSEntityDescription insertNewObjectForEntityForName:@"Enumeration" inManagedObjectContext:self.context];
//    enumeration.key = key;
//    enumeration.value = value;
//    enumeration.enumtype = enumtype;
//    NSError *error;
//    //保存上下文
//    if (![self.context save:&error]) {
//        NSLog(@"添加过程中发生错误,错误信息：%@！",error.localizedDescription);
//    } else {
//        NSLog(@"添加成功");
//    }
//}
//
//- (void)addEnumerationWithArray:(NSArray *)paramArray {
//    for (NSDictionary *tmpDic in paramArray) {
//        [self addEnumerationWithKey:tmpDic[kIDKey] value:tmpDic[kIDValue] enumtype:tmpDic[kEnumType]];
//    }
//}
//
//-(Project *)getEnumerationByKey:(NSString *)key type:(NSString *)type {
//    //实例化查询
//    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Enumeration"];
//    //使用谓词查询是基于Keypath查询的，如果键是一个变量，格式化字符串时需要使用%K而不是%@
//    request.predicate=[NSPredicate predicateWithFormat:@"%K=%@ and %K=%@",kIDKey,key, kEnumType, type];
//    NSError *error;
//    Enumeration *enumeration;
//    //进行查询
//    NSArray *results=[self.context executeFetchRequest:request error:&error];
//    if (error) {
//        NSLog(@"查询过程中发生错误，错误信息：%@！",error.localizedDescription);
//    }else{
//        enumeration = [results firstObject];
//    }
//
//    return enumeration;
//}
//
//- (NSArray *)getEnumerationsByType:(NSString *)type {
//    //实例化查询
//    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Enumeration"];
//    //使用谓词查询是基于Keypath查询的，如果键是一个变量，格式化字符串时需要使用%K而不是%@
//    request.predicate=[NSPredicate predicateWithFormat:@"%K=%@",kEnumType, type];
//    NSError *error;
//    //进行查询
//    NSArray *results=[self.context executeFetchRequest:request error:&error];
//    return results;
//}
//
//- (void)removeAllEnumeration {
//    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"Enumeration"];
//    [request setIncludesPropertyValues:NO]; //only fetch the managedObjectID
//    NSError *error = nil;
//    NSArray *enums = [self.context executeFetchRequest:request error:&error];
//    //error handling goes here
//    for (NSManagedObject *tmpEnums in enums) {
//        [self.context deleteObject:tmpEnums];
//    }
//    NSError *saveError = nil;
//    if (![self.context save:&saveError]) {
//        NSLog(@"删除过程中发生错误，错误信息：%@!",error.localizedDescription);
//    }
//}

@end
