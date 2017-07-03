//
//  PageJumpHelper.h
//  自由找
//
//  Created by guojie on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonUtil.h"

@interface PageJumpHelper : NSObject

/**
 *  页面跳转帮助
 *
 *  @param vcID       controller的identifier
 *  @param name       controller所在的storyboard
 *  @param controller 父容器 一般传 self
 */
+ (void)pushToVCID:(NSString *)vcID storyboard:(NSString *)name parent:(UIViewController *)controller;

/**
 *  页面跳转帮助
 *
 *  @param vcID       ontroller的identifier
 *  @param name       controller所在的storyboard
 *  @param parameters 需要传递的参数
 *  @param controller 父容器 一般传 self
 */
+ (void)pushToVCID:(NSString *)vcID storyboard:(NSString *)name parameters:(NSDictionary *)parameters parent:(UIViewController *)controller;

+ (void)presentLoginViewController;

+ (void)presentLoginVCWithParameter:(NSDictionary *)parameters;

@end
