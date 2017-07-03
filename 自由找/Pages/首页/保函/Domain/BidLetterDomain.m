//
//  BidLetterDomain.m
//  自由找
//
//  Created by 郭界 on 16/9/27.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BidLetterDomain.h"

@implementation BidLetterDomain

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"Region"]) {
        KeyValueDomain *region = [KeyValueDomain domainWithObject:value];
        self.Region = region;
    } else {
        [super setValue:value forKey:key];
    }
}

@end
