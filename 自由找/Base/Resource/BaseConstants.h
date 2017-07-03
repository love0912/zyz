//
//  BaseConstants.h
//  奔跑兄弟
//
//  Created by guojie on 16/4/22.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//

#ifndef BaseConstants_h
#define BaseConstants_h
#import "ActionDefine.h"
#import "KeyDefine.h"
#import "UIViewExt.h"
#import "UIColorExt.h"
#import "NSOjbectExt.h"
#import "JxJSON.h"
#import "ProgressHUD.h"
#import "Singleton.h"
#import "ALView+PureLayout.h"
#import "UserDomain.h"
#import "CommonUtil.h"
#import "JAlertHelper.h"
#import "PageJumpHelper.h"
#import "QualityDomain.h"
#define Storyboard_Main @"TB"
#define Storyboard_Publish @"TB1"
#define Storyboard_Mine @"TB2"

#define DEFAULTAVATER [UIImage imageNamed:@"default_avater"]


/*****
 *  日志打印
 *  发布版不打印 开发版打印
 ******/
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

/*****
 *  获取系统版本号
 ******/
#define SystemVersion [[[UIDevice currentDevice] systemVersion] doubleValue]

#define MainScreenBounds [UIScreen mainScreen].bounds
#define ScreenSize [UIScreen mainScreen].bounds.size

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#endif
