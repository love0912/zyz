//
//  BaseService.h
//  奔跑兄弟
//
//  Created by guojie on 16/4/22.
//  Copyright © 2016年 yutonghudong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "BaseConstants.h"
#import "AppInfoDomain.h"


@interface BaseService : NSObject

+(instancetype)sharedService;

- (AFHTTPSessionManager *)sessionManager;

/**
 *  http请求
 *  默认方式 POST 无参数
 *
 *  @param urlStr  URL地址
 *  @param success 成功后的回调
 *  @param fail    失败后的回调
 */
- (void)httpRequestWithUrl:(NSString *)urlStr success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail;

/**
 *  http请求
 *  无参数
 *
 *  @param type    提交方式"GET"、"POST"两种，大写
 *  @param urlStr  URL地址
 *  @param success 成功后的回调
 *  @param fail    失败后的回调
 */
- (void)httpRequestWithType:(NSString *)type url:(NSString *)urlStr success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail;

/**
 *  http请求 ---  默认最常用方式
 *  默认方式 POST
 *
 *  @param urlStr     URL地址
 *  @param parameters 提交的参数
 *  @param success    成功后的回调
 *  @param fail       失败后的回调
 */
- (void)httpRequestWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail;

/**
 *  后台提交，不显示HUD
 *
 *  @param urlStr     <#urlStr description#>
 *  @param parameters <#parameters description#>
 *  @param success    <#success description#>
 *  @param fail       <#fail description#>
 */
- (void)backgroundRequestWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail;

/**
 *  http请求
 *
 *  @param type       提交方式"GET"、"POST"两种，大写
 *  @param parameters 提交的参数
 *  @param urlStr     @param urlStr     URL地址
 *  @param success    成功后的回调
 *  @param fail       失败后的回调
 */
- (void)httpRequestWithType:(NSString *)type hud:(BOOL)show parameters:(id)parameters url:(NSString *)urlStr success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)(id errorObject))fail;

/**
 *  http提交2 ---   新版本功能使用的接口  -- 技术标、预算、钱包等
 *
 *  @param type       <#type description#>
 *  @param show       <#show description#>
 *  @param parameters <#parameters description#>
 *  @param urlStr     <#urlStr description#>
 *  @param success    <#success description#>
 *  @param fail       <#fail description#>
 */
- (void)http2RequestWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)(id errorObject))fail;

/**
 *  后台提交提交2-不显示HUD---   新版本功能使用的接口  -- 技术标、预算、钱包等
 *
 *  @param urlStr     <#urlStr description#>
 *  @param parameters <#parameters description#>
 *  @param success    <#success description#>
 *  @param fail       <#fail description#>
 */
- (void)background2RequestWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail;


/**
 基本处理类别

 @param baseUrlString HOST+端口号
 @param actionName    接口名
 @param parameters    <#parameters description#>
 @param success       <#success description#>
 @param fail          <#fail description#>
 */
- (void)httpBaseUrlString:(NSString *)baseUrlString actionString:(NSString *)actionName showHUD:(BOOL)show parameters:(id)parameters success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail;

- (void)http3RequestWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)(id errorObject))fail;

/**
 *  后台提交提交3-不显示HUD---   新版本功能使用的接口  -- 技术标、预算、钱包等
 *
 *  @param urlStr     <#urlStr description#>
 *  @param parameters parameters description
 *  @param success    <#success description#>
 *  @param fail       <#fail description#>
 */
- (void)background3RequestWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail;

/**
 *  获取html 页面代码
 *
 *  @param urlStr  <#urlStr description#>
 *  @param success <#success description#>
 *  @param fail    <#fail description#>
 */
- (void)getHtmlStringWithUrl:(NSString *)urlStr success:(void (^)(id responseObject))success fail:(void (^)())fail;

/**
 *  上传图片请求
 *
 *  @param urlStr     <#urlStr description#>
 *  @param image      <#image description#>
 *  @param type 1 -- 头像 2 -- 其他
 *  @param success    <#success description#>
 *  @param fail       <#fail description#>
 */
- (void)uploadImageWithUrl:(NSString *)urlStr image:(UIImage *)image type:(NSInteger)type success:(void (^)(id responseObject, NSInteger code))success fail:(void (^)())fail;
/**
 *  提示服务器端返回信息  默认2s
 *
 *  @param responseObject
 */
- (void)showResponseMsg:(NSDictionary *)responseObject;

/**
 *  提示服务器端返回信息
 *
 *  @param responseObject
 *  @param delay
 */
- (void)showResponseMsg:(NSDictionary *)responseObject delay:(double)delay;

+ (BOOL)rightResponse:(NSDictionary *)response;

/**
 *  获取验证码
 *
 *  @param phone  手机号码
 *  @param type   1/2,注册/找回密码
 *  @param result 验证码
 */
- (void)getCodeWithPhone:(NSString *)phone type:(NSString *)type result:(void (^)(NSInteger code))result;

/**
 *  获取地区
 *
 *  @param result 所有地区列表key-value
 */
- (void)getRegionToResult:(void (^)(NSArray<KeyValueDomain *> *regionList, NSInteger code))result;

/**
 *  获取项目类别
 *
 *  @param result 所有项目类别 key-value
 */
- (void)getProjectTypeToResult:(void (^)(NSArray<KeyValueDomain *> *regionList, NSInteger code))result;

/**
 *  获取资质类型
 *
 *  @param type    1- 搜索  2—施工发布  --0 或者不填为其他
 *  @param result
 */
- (void)getQualitificationWithType:(int )type result:(void (^)(NSArray *qualityList, NSInteger code))result;

/**
 *  查看版本更新信息
 *
 *  @param result 
 */
- (void)checkUpdateWithVersion:(NSInteger)version ToResult:(void (^)(AppInfoDomain *appInfo, NSInteger code))result;

/**
 *  意见反馈
 *
 *  @param parameters
 *  @param result
 */
-(void)feedBackWithParameters:(NSDictionary *)parameters result:(void (^)(NSInteger code))result;

/**
 *  获取banner图片
 *
 *  @param result <#result description#>
 */
- (void)getBannerToResult:(void (^)(NSArray *bannerList, NSInteger code))result;

/**
 *  获取评价原因
 *
 *  @param type    1 发布   2 报名
 *  @param result <#result description#>
 */
- (void)getAssesReasonWithType:(NSInteger)type result:(void (^)(NSArray<KeyValueDomain *> *info, NSInteger code))result;


/**
 *  获取消息未读数
 *
 *  @param result <#result description#>
 */
- (void)getMessageCountWithResult:(void (^)(NSInteger count, NSInteger code))result;

/**
 *  获取我的发布新增报名未读数
 *
 *  @param result <#result description#>
 */
- (void)getMinePublishCountWithResult:(void (^)(NSInteger count, NSInteger code))result;

/**
 *  二维码扫描登录
 *
 *  @param scanCode <#scanCode description#>
 */
- (void)loginWithScanCode:(NSString *)scanCode result:(void (^)(NSInteger code))result;

/**
 *  统计首页感兴趣和不感兴趣
 *
 *  @param type   1 技术  2 预算
 *  @param data    0 没兴趣  1 有兴趣
 *  @param result <#result description#>
 */
- (void)countHomeDataWithInterestType:(NSInteger)type isInterest:(NSInteger)data result:(void (^)(NSInteger code))result;

/**
 *  统计 -- 查阅统计
 *
 *  @param type     <#type description#>
 *  @param recordID <#recordID description#>
 */
- (void)countViewsWithType:(NSInteger)type recordID:(NSString *)recordID;

/**
 *  统计 -- 拨打电话
 *
 *  @param type      <#type description#>
 *  @param recordID  <#recordID description#>
 *  @param direction <#direction description#>
 *  @param phone     <#phone description#>
 */
- (void)countCallWithType:(NSInteger)type recordID:(NSString *)recordID direction:(NSInteger)direction phone:(NSString *)phone;
@end
