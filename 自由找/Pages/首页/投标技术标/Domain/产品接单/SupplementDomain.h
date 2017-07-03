//
//  SupplementDomain.h
//  自由找
//
//  Created by guojie on 16/8/12.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"

@interface SupplementDomain : BaseDomain

@property (strong, nonatomic) NSString *Title;

@property (strong, nonatomic) NSString *Content;

@property (strong, nonatomic) NSString *DownloadUrl;

@property (strong, nonatomic) NSString *AccessCode;

@property (strong, nonatomic) NSString *CreateDt;

@end
