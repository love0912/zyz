//
//  JAddressManager.m
//  自由找
//
//  Created by 郭界 on 16/10/20.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "JAddressManager.h"

@implementation JAddressManager

+ (instancetype)shareInstance {
    static JAddressManager *_addressManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _addressManager = [[self alloc] init];
    });
    return _addressManager;
}

- (NSArray *)provinceDicAry {
    if (!_provinceDicAry) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"];
        NSString *jsonStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
        _provinceDicAry = [NSArray arrayWithArray:[jsonStr JSONObject]];
    }
    return _provinceDicAry;
}

@end
