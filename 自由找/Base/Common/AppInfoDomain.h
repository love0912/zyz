//
//  AppInfoDomain.h
//  自由找
//
//  Created by guojie on 16/6/28.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "BaseDomain.h"

@interface AppInfoDomain : BaseDomain

@property (strong, nonatomic) NSString *LatestVersionNo;

/**
 *  0/1/2,非强制更新/强制更新/不需要更新
 */
@property (assign, nonatomic) NSInteger Force;

@property (strong, nonatomic) NSString *DownloadUrl;


/**
 显示给用户的version 1.x.x
 */
@property (strong, nonatomic) NSString *LatestVersion;


/**
 更新的内容
 */
@property (strong, nonatomic) NSString *Content;

@end
