//
//  OrderInfoDomain.m
//  自由找
//
//  Created by guojie on 16/8/10.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "OrderInfoDomain.h"

@implementation OrderInfoDomain

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"ContactInfo"]) {
        ContactInfo *contact = [ContactInfo domainWithObject:value];
        self.ContactInfo = contact;
    } else if ([key isEqualToString:@"DownLoad"]) {
        DownloadInfo *download = [DownloadInfo domainWithObject:value];
        self.DownLoad = download;
    } else {
        [super setValue:value forKey:key];
    }
}

@end
