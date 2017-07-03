//
//  BidDomain.m
//  自由找
//
//  Created by guojie on 16/6/22.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BidDomain.h"
#import "KeyDefine.h"

@implementation BidDomain

- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:kBidRegion]) {
        KeyValueDomain *domain = [KeyValueDomain domainWithObject:value];
        self.Region = domain;
    } else if ([key isEqualToString:kBidProjectType]) {
        KeyValueDomain *domain = [KeyValueDomain domainWithObject:value];
        self.ProjectType = domain;
    } else if ([key isEqualToString:kBidCompanyType]) {
        KeyValueDomain *domain = [KeyValueDomain domainWithObject:value];
        self.CompanyType = domain;
    } else if ([key isEqualToString:kBidAptitudesRequired]) {
        NSArray *tmpArr = value;
        NSMutableArray *Aptitudes = [NSMutableArray arrayWithCapacity:tmpArr.count];
        for (NSDictionary *tmpDic in tmpArr) {
            KeyValueDomain *domain = [KeyValueDomain domainWithObject:tmpDic];
            [Aptitudes addObject:domain];
        }
        self.AptitudesRequired = Aptitudes;
    } else if ([key isEqualToString:kBidPerformance]) {
        TxtImgDomain *domain = [TxtImgDomain domainWithObject:value];
        self.Performance = domain;
    } else if ([key isEqualToString:kBidMemberRequired]) {
        TxtImgDomain *domain = [TxtImgDomain domainWithObject:value];
        self.MemberRequired = domain;
    } else if ([key isEqualToString:kBidDescribe]) {
        TxtImgDomain *domain = [TxtImgDomain domainWithObject:value];
        self.Describe = domain;
    } else {
        [super setValue:value forKey:key];
    }
}

@end

@implementation TxtImgDomain

@end