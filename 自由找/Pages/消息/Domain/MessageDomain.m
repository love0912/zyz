//
//  MessageDomain.m
//  自由找
//
//  Created by xiaoqi on 16/7/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "MessageDomain.h"

@implementation MessageDomain
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self jx_encodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self jx_decodeWithCoder:aDecoder];
    }
    return self;
}

@end
