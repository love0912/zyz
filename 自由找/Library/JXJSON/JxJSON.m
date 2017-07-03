//
//  JxJSON.m
//  奔跑兄弟
//
//  Created by guojie on 16/4/25.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//

#import "JxJSON.h"

//
//  EASYJSONCategories.m
//  EASYJSON
//
//  Created by EZ on 13-5-23.
//  Copyright (c) 2013年 cactus. All rights reserved.
//


@implementation NSObject (JXJSON)

-(NSString*) JSONStringWithOption:(int) option
{
    if(self == nil){
        return nil;
    }
    NSError *err = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:option
                                                     error:&err];
    
    if(err)
        NSLog(@"%@", [err description]);
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
}

- (NSString *)prettyJSONString {
    return [self JSONStringWithOption:NSJSONWritingPrettyPrinted];
}

- (NSString *)JSONStringRepresentation {
    return [self JSONStringWithOption:0];
}

@end


@implementation NSString (JXJSON)

- (id)JSONObject {
    if(self == nil){
        return self;
    }
    NSError *err = nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    id jsonValue = [NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves
                                                     error:&err];
    
    if(err)
        NSLog(@"%@", [err description]);
    return jsonValue;
}

@end

@implementation NSData (JXJSON)
- (id)JSONData
{
    if(self == nil){
        return nil;
    }
    NSError *err = nil;
    id jsonValue = [NSJSONSerialization JSONObjectWithData:self
                                                   options:0
                                                     error:&err];
    if(err)
        NSLog(@"%@", [err description]);
    return jsonValue;
}

@end
