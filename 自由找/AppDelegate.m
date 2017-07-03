//
//  AppDelegate.m
//  自由找
//
//  Created by guojie on 16/5/26.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件
#import "WeiboSDK.h"
//极光推送SDK头文件
#import "JPUSHService.h"
#import <UMMobClick/MobClick.h>

#import <AlipaySDK/AlipaySDK.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import <UserNotifications/UserNotifications.h>

//环信
//#import  "EMSDK.h"
#define kEMAppKey @"ziyouzhao#ziyouzhao"

#define kSharedAppKey @"56722236e0f55a2d76000c5f"

#define WX_ID @"wx0af952e4a355c271"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 1.创建Window
    self.window = [[UIWindow alloc] initWithFrame:MainScreenBounds];
    self.window.backgroundColor = [UIColor whiteColor];
    // 2.创建TabBarCongtroller
    VC_MainTab *vc_mainTab = [[VC_MainTab alloc] init];
    self.mainTab = vc_mainTab;
    // 3.设置根控制器
    self.window.rootViewController = vc_mainTab;
    // 4.显示Window
    [self.window makeKeyAndVisible];
    
    
    [self registShareSDK];
    //极光推送
    [self initializeJPush:launchOptions];

    [self registMobClick];
//    [self registerEMSDK:application];
    
    [WXApi registerApp:WX_ID withDescription:@"Ziyouzhao"];
    
    return YES;
}
/**
 *  环信
 */
//-(void)registerEMSDK:(UIApplication *)application{
//    //AppKey:注册的AppKey
//    //apnsCertName:推送证书名（不需要加后缀)
//    EMOptions *options = [EMOptions optionsWithAppkey:kEMAppKey];
//    options.apnsCertName = @"push_dev";
//    [[EMClient sharedClient] initializeSDKWithOptions:options];
//    //iOS8 注册APNS
//    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
//        [application registerForRemoteNotifications];
//        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge |
//        UIUserNotificationTypeSound |
//        UIUserNotificationTypeAlert;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }
//    else{
//        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
//        UIRemoteNotificationTypeSound |
//        UIRemoteNotificationTypeAlert;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
//    }
//    BOOL isAutoLogin = [EMClient sharedClient].isAutoLogin;
//    if (isAutoLogin){
//        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
//    }
//    else
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
//    }
//
//
//}
/**
 *  极光推送
 */
-(void)initializeJPush:(NSDictionary *)launchOptions{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    /**
       isProduction 是否生产环境. 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES.
     */
    [JPUSHService setupWithOption:launchOptions appKey:@"32b801ef804ff5aa8723ecae"
                          channel:nil
                 apsForProduction:YES
            advertisingIdentifier:nil];
}
/**
 *  初始化分享SDK
 */
- (void)registShareSDK {
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"13d5d1f1bb7ec"
          activePlatforms:@[
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeQQFriend),
                            @(SSDKPlatformSubTypeQZone),
                            @(SSDKPlatformTypeSMS)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx0af952e4a355c271"
                                       appSecret:@"a9e7cda3dc5ee611a54570f395401234"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105008526"
                                      appKey:@"qqICHcY5L0cNSbQv"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

/** 注册友盟统计 */
- (void)registMobClick {
    
    UMAnalyticsConfig *config = UMConfigInstance;
    config.appKey = kSharedAppKey;
    [MobClick startWithConfigure:config];
//    [MobClick startWithAppkey:kSharedAppKey reportPolicy:BATCH channelId:nil];
    //    [MobClick startWithAppkey:kSharedAppKey reportPolicy:BATCH channelId:@"1"];
    //    [MobClick startWithAppkey:kSharedAppKey reportPolicy:BATCH channelId:@"2"];
    //    [MobClick startWithAppkey:kSharedAppKey reportPolicy:BATCH channelId:@"3"];
    //    [MobClick startWithAppkey:kSharedAppKey reportPolicy:BATCH channelId:@"4"];
    //    [MobClick startWithAppkey:kSharedAppKey reportPolicy:BATCH channelId:@"5"];
    
        [MobClick setLogEnabled:YES];
    
    NSString *version = [CommonUtil shortVersion];
    [MobClick setAppVersion:version];
    
}

- (BOOL)application: (UIApplication *)application  handleOpenURL: (NSURL *)url
{
    BOOL result = [TencentOAuth HandleOpenURL:url];
    if (result == NO) {
        if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",WX_ID]].location != NSNotFound) {
            return  [WXApi handleOpenURL:url delegate:self];
            //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [TencentOAuth HandleOpenURL:url];
    if (result == NO) {
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        } else if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",WX_ID]].location != NSNotFound) {
            return  [WXApi handleOpenURL:url delegate:self];
            //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
        }
        return YES;
    }
    return result;
}

//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法
-(void) onResp:(BaseResp*)resp
{
    //这里判断回调信息是否为 支付
    if([resp isKindOfClass:[PayResp class]]){
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                //如果支付成功的话，全局发送一个通知，支付成功
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_TenPay_Result object:response];
                break;
                
            default:
                //如果支付失败的话，全局发送一个通知，支付失败
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_TenPay_Result object:response];
                break;
        }
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
            //如果支付失败的话，全局发送一个通知，支付失败
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_AliPay_Result object:resultDic];
            
        }];
    } else if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"%@://pay",WX_ID]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //环信
//    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [JPUSHService resetBadge];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //环信
//    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/*
 极光推送
 */
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    //收到通知
   
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    //收到通知
    
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
//    //环信
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [[EMClient sharedClient] bindDeviceToken:deviceToken];
//    });
}
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //环信
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
//                                                    message:error.description
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
//                                          otherButtonTitles:nil];
//    [alert show];
}
// 打印收到的apns信息
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //环信
//    NSError *parseError = nil;
//    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
//                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
//    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.content", @"Apns content")
//                                                    message:str
//                                                   delegate:nil
//                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
//                                          otherButtonTitles:nil];
//    [alert show];
    
}

@end
