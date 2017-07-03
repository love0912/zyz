//
//  LetterPerformDomain.m
//  自由找
//
//  Created by 郭界 on 16/10/19.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "LetterPerformDomain.h"

@implementation LetterPerformDomain

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"ProjectArea"]) {
        KeyValueDomain *projectArea = [KeyValueDomain domainWithObject:value];
        self.ProjectArea = projectArea;
    } else if ([key isEqualToString:@"ProjectCategory"]) {
        KeyValueDomain *projectCategory = [KeyValueDomain domainWithObject:value];
        self.ProjectCategory = projectCategory;
    } else {
        [super setValue:value forKey:key];
    }
}

@end
