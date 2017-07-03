//
//  BannerPageDomain.h
//  BaseProject
//
//  Created by guojie on 15/12/25.
//  Copyright © 2015年 yutonghudong. All rights reserved.
//

#import "BaseDomain.h"

@interface BannerPageDomain : BaseDomain

/**
 *  标题
 */
@property (nonatomic, strong) NSString *Title;

/**
 *  banner图片地址
 */
@property (nonatomic, strong) NSString *ImgUrl;

/**
 *  点击跳转到的url
 */
@property (nonatomic, strong) NSString *ToUrl;


@end
