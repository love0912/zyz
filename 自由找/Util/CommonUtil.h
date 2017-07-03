//
//  CommonUtil.h
//  自由找
//
//  Created by guojie on 16/6/14.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserDomain.h"
#import "VC_MainTab.h"

#define JXColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]


@interface CommonUtil : NSObject

//归档文件地址
+ (NSString *)getArchPath;

+ (UserDomain *)getUserDomain;

+ (void)saveUserDomian:(UserDomain *)userDomian;

+ (BOOL)isLogin;

+ (void)removeUserDomain;

+ (NSString *)getMd5_32Bit:(NSString *)password;

+ (BOOL)isIDCardNumber:(NSString *)value;

/**
 *  取保存在UserDefaults里面的数据
 *
 *  @param key
 *
 *  @return
 */
+ (NSObject *)objectForUserDefaultsKey:(NSString *)key;

/**
 *  写对象到UserDefaults
 *
 *  @param obj
 *  @param key
 */
+ (void)saveObject:(NSObject *)obj forUserDefaultsKey:(NSString *)key;

/**
 *  删除userDefaults的对象
 *
 *  @param
 */
+ (void)removeObjectforUserDefaultsKey:(NSString *)key;

//显示文本框
+ (void)jxWebViewShowInController:(UIViewController *)controller loadUrl:(NSString *)urlString backTips:(NSString *)tips;
+ (void)jxPushWebViewShowInController:(UIViewController *)controller loadUrl:(NSString *)urlString backTips:(NSString *)tips;

+ (void)showUserProtocalInController:(UIViewController *)controller;

/**
 *  自由找购买协议
 *
 *  @param controller <#controller description#>
 */
+ (void)showBuyProductProtocalInController:(UIViewController *)controller;

/**
 *  自由找接单协议
 *
 *  @param controller <#controller description#>
 */
+ (void)showReiciveOrderProtocalInController:(UIViewController *)controller;

/**
 *  自由找接单必读
 *
 *  @param controller <#controller description#>
 */
+ (void)showReiciveOrderReadmeProtocalInController:(UIViewController *)controller;


/**
 自由找积分规则
 
 @param controller <#controller description#>
 */
+ (void)showScoreRuleInController:(UIViewController *)controller;

/**
 *  设计图--类似橙色的颜色
 *
 *  @return
 */
+ (UIColor *) zyzOrangeColor;

/**
 *  视图背景色
 *
 *  @return <#return value description#>
 */
+ (UIColor *)zyzBackgroundColor;
/**
 *  统计字符长度
 *
 *  @return <#return value description#>
 */

+(NSUInteger)unicodeLengthOfString:(NSString *)text;

+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSString *)stringFromDate1:(NSDate *)date;
+ (NSDate *)dateFromString1:(NSString *)string;

/**
 *  拨打电话
 *
 *  @param phone <#phone description#>
 */
+ (void)callWithPhone:(NSString *)phone;

/**
 *  合作情况
 */
+ (NSArray *)getCooperationData;

/**
 *  根据key返回合作情况value
 *
 *  @param key
 *
 *  @return
 */
+ (NSString *)cooperationValueForKey:(NSString *)key;

/**
 *  生成纯色图片
 *
 *  @param color <#color description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  获取版本号---用户所见
 *
 *  @return 1.x.x
 */
+ (NSString *)shortVersion;

/**
 *  获取版本号 -- 后台更新所用
 *
 *  @return 20
 */
+ (NSInteger)version;

/**
 *  设置选中的tab
 *
 *  @param index <#index description#>
 */
+ (void)setSelectIndex:(NSInteger)index;

/**
 *  获取上一个选中的tab
 *
 *  @return <#return value description#>
 */
+ (NSInteger)getSelectIndex;

/**
 *  获取Tabbar
 *
 *  @return <#return value description#>
 */
+ (VC_MainTab *)getRootTabbar;

/**
 *  设置tabbar的消息提示红圈
 *
 *  @param count <#count description#>
 */
+ (void)setMsgCount:(NSInteger)count;

/**
 *  消息提示红圈减一
 */
+ (void)subMsgCount;

/**
 *  设置我的提示
 *
 *  @param count <#count description#>
 */
+ (void)setMineCount:(NSInteger)count;

/**
 *  减少我的上面的数字提示
 *
 *  @param count 减少的数量
 */
+ (void)subMineCount:(NSInteger)count;

/**
 *  设置我的发布数量提示
 *
 *  @param count
 */
+ (void)setPublishCount:(NSInteger)count;

/**
 *  设置我的发布数量和我的下标数量一致
 */
+ (void)setPublishCount;

/**
 *  减少我的发布提示数量
 *
 *  @param count 减少的数量
 */
+ (void)subPublishCount:(NSInteger)count;
+(void)setTextColor:(UILabel *)label FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor;


/**
 去浮点数末尾的0

 @param string <#string description#>

 @return <#return value description#>
 */
+(NSString*)removeFloatAllZero:(NSString*)string;

/**
 触发通知
 
 @param name <#name description#>
 */
+ (void)notificationWithName:(NSString *)name;


/**
 截屏 -- 将view转化为image

 @param view <#view description#>
 @return <#return value description#>
 */
+ (UIImage *)captureImageFormView:(UIView *)view;


/**
 计算文字的宽度
 
 @param label <#label description#>
 @param font <#font description#>
 @return <#return value description#>
 */
+ (CGFloat)widthWithText:(NSString *)text labelHeight:(CGFloat)labelHeight font:(UIFont *)font ;
@end
