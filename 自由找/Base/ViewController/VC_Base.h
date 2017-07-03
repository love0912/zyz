//
//  VC_Base.h
//  奔跑兄弟
//
//  Created by guojie on 16/4/20.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//
/**
 *  基类，创建常用方法和属性
 */


#import <UIKit/UIKit.h>
#import "BaseService.h"
#import "BaseConstants.h"
#import "RESideMenu.h"
#import "Masonry.h"
#import <MJRefresh/MJRefresh.h>
#import <UMMobClick/MobClick.h>
#import "SwipeBack.h"
#import "CountUtil.h"

@interface VC_Base : UIViewController<UITextFieldDelegate, UITextViewDelegate>

/**
 *  自定义navigationbar , 以便全屏返回
 */
@property (nonatomic, strong) UINavigationBar *jx_navigationBar;

/**
 *  自定义navagionitem的标题,需放在super方法执行之前
 */
@property (nonatomic, strong) NSString *jx_title;

/**
 *  标题颜色
 */
@property (nonatomic, strong) UIColor *jx_titleColor;

/**
 *  导航栏背景色
 */
@property (nonatomic, strong) UIColor *jx_background;


@property (nonatomic, weak) UITextField *tf_check;

@property (nonatomic, weak) UITextView *tv_check;

/**
 *  处理htpp请求的service
 */
//@property (nonatomic, strong) BaseService *service;

/**
 *  页面跳转需要传递的参数
 */
@property (nonatomic, strong) NSDictionary *parameters;


/**
 *  如果需自定义返回按钮事件，实现该方法重写
 */
- (void)backPressed;

/**
 *  隐藏tableview下面多余的行数
 *
 *  @param tableView 
 */
- (void)hideTableViewFooter:(UITableView *)tableView;

/**
 *  隐藏分组table header
 *
 *  @param tableView <#tableView description#>
 */
- (void)hideTableViewHeader:(UITableView *)tableView;

/**
 *  设置navigation左边的item
 *
 *  @param item <#item description#>
 */
- (void) setNavigationBarLeftItem:(UIBarButtonItem *)item;

/**
 *  设置navigation右边的item
 *
 *  @param item <#item description#>
 */
- (void) setNavigationBarRightItem:(UIBarButtonItem *)item;

/**
 *  设置navigation右边的item
 *
 *  @param item <#item description#>
 *  @param width 偏移量 
 */
- (void) setNavigationBarRightItem:(UIBarButtonItem *)item spaceWidth:(NSInteger) width;

/**
 *  设置navigation的titleView
 *
 *  @param view <#view description#>
 */
- (void)setNavigationBarTitleView:(UIView *)view;

/**
 *  状态栏浅色字体
 */
- (void)statusBarLightContent;

/**
 *  状态栏默认字体
 */
- (void)statusBarDefault;

/**
 *  获取版本号---用户所见
 *
 *  @return 1.x.x
 */
- (NSString *)shortVersion;

/**
 *  获取版本号 -- 后台更新所用
 *
 *  @return 20
 */
- (NSInteger)version;

/**
 *  返回前一个页面
 *  只用于push
 */
- (void)goBack;
/**
 *  列表获取数据后停止刷新
 */
- (void)endingMJRefreshWithTableView:(UITableView *)tableView;

- (void)endingNoMoreWithTableView:(UITableView *)tableview;

- (void)resetNoMoreStatusWithTableView:(UITableView *)tableView;

- (void)zyzOringeNavigationBar;

- (void)finishEditing;

@end
