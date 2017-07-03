//
//  LetterOrderDetailDomain.m
//  zyz
//
//  Created by 郭界 on 16/10/25.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "LetterOrderDetailDomain.h"

@implementation LetterOrderDetailDomain

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"ContactInfo"]) {
        ContactInfo *contact = [ContactInfo domainWithObject:value];
        self.ContactInfo = contact;
    } else if ([key isEqualToString:@"Tracking"]) {
        Tracking *tracking = [Tracking domainWithObject:value];
        self.Tracking = tracking;
    } else if ([key isEqualToString:@"Region"]) {
        KeyValueDomain *region = [KeyValueDomain domainWithObject:value];
        self.Region = region;
    }else {
        [super setValue:value forKey:key];
    }
}

@end

@implementation Tracking

@end
