//
//  BaseDomain.m
//  奔跑兄弟
//
//  Created by guojie on 16/4/22.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//

#import "BaseDomain.h"
#import <objc/runtime.h>

@implementation BaseDomain

+ (id)domainWithObject:(NSObject *)dataSource {
//    if (dataSource == nil) {
//        return nil;
//    }
    BaseDomain *obj = [[self alloc] init];
    [obj jx_setDataFromObject:dataSource];
    return obj;
}

- (BOOL)jx_setDataFromObject:(NSObject*)dataSource {
    BOOL ret = NO;
    for (NSString *key in [self propertyKeys]) {
        if ([dataSource isKindOfClass:[NSDictionary class]]) {
            ret = ([dataSource valueForKey:key]==nil)?NO:YES;
        }
        else
        {
            ret = [dataSource respondsToSelector:NSSelectorFromString(key)];
        }
        if (ret) {
            id propertyValue = [dataSource valueForKey:key];
            //该值不为NSNULL，并且也不为nil
            if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
                [self setValue:propertyValue forKey:key];
            }
        }
    }
    return ret;
}

- (NSArray*)propertyKeys
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(properties);
    return keys;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSArray *allKeys = [self propertyKeys];
    for (NSString *key in allKeys) {
        id value = [self valueForKey:key];
        if (value == nil) {
            // nothing todo
        }
        else if ([value isKindOfClass:[NSNumber class]]
                 || [value isKindOfClass:[NSString class]]
                 || [value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableArray class]] || [value isKindOfClass:[NSArray class]]) {
            // TODO: extend to other types
            [dictionary setObject:value forKey:key];
        } else if ([value isKindOfClass:[BaseDomain class]]) {
            [dictionary setObject:[value toDictionary] forKey:key];
        } else if ([value isKindOfClass:[NSObject class]]) {
            [dictionary setObject:[value dictionary] forKey:key];
        }
        else {
            NSLog(@"Invalid type for %@ (%@)", NSStringFromClass([self class]), key);
        }
    }
    return dictionary;
}

- (void)jx_encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count;
    Ivar *ivar = class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++) {
        Ivar iv = ivar[i];
        const char *name = ivar_getName(iv);
        NSString *strName = [NSString stringWithUTF8String:name];
        //利用KVC取值
        id value = [self valueForKey:strName];
        [aCoder encodeObject:value forKey:strName];
    }
    free(ivar);
}

- (void)jx_decodeWithCoder:(NSCoder *)aDecoder {
    unsigned int count = 0;
    //获取类中所有成员变量名
    Ivar *ivar = class_copyIvarList([self class], &count);
    for (int i = 0; i<count; i++) {
        Ivar iva = ivar[i];
        const char *name = ivar_getName(iva);
        NSString *strName = [NSString stringWithUTF8String:name];
        //进行解档取值
        id value = [aDecoder decodeObjectForKey:strName];
        //利用KVC对属性赋值
        [self setValue:value forKey:strName];
    }
    free(ivar);
}

@end
