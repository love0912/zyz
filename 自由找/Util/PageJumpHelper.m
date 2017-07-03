//
//  PageJumpHelper.m
//  自由找
//
//  Created by guojie on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "PageJumpHelper.h"
#import "VC_Base.h"
#import "VC_Login.h"

@implementation PageJumpHelper

+ (void)pushToVCID:(NSString *)vcID storyboard:(NSString *)name parent:(UIViewController *)controller {
//    NSArray *canLoginVCIDS = @[];
//    //需要登录的页面未登录，跳转至登录页面
//    if ([canLoginVCIDS containsObject:vcID] && ![CommonUtil isLogin]) {
//        UINavigationController *loginNav = [[UIStoryboard storyboardWithName:@"TB2" bundle:nil] instantiateViewControllerWithIdentifier:@"NVC_Login"];
//        [controller presentViewController:loginNav animated:YES completion:nil];
//    } else {
//        UIViewController *destVC = [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:vcID];
//        [controller.navigationController pushViewController:destVC animated:YES];
//    }
    if ([self vertifyLoginWithVCID:vcID parent:controller]) {
        UIViewController *destVC = [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:vcID];
        [controller.navigationController pushViewController:destVC animated:YES];
    }
}

+ (void)pushToVCID:(NSString *)vcID storyboard:(NSString *)name parameters:(NSDictionary *)parameters parent:(UIViewController *)controller {
    if ([self vertifyLoginWithVCID:vcID parent:controller]) {
        VC_Base *destVC = [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:vcID];
        if (destVC != nil) {
            destVC.parameters = parameters;
            [controller.navigationController pushViewController:destVC animated:YES];
        }
    }
}

+ (BOOL) vertifyLoginWithVCID:(NSString *)vcID parent:(UIViewController *)controller {
    /**
     *  需要登录才能进入的页面ID
     */
    NSArray *canLoginVCIDS = @[
                               @"VC_PublishBid", //发布资质合作
                               @"VC_OurPublish", //我的发布
                               @"VC_OurAttention", //我的报名
                               @"VC_Customer", //客户管理
                               @"VC_Score", //我的积分
                               @"VC_InEnterprise", //所在企业
                               @"VC_FeedBack",   //意见反馈
                               @"VC_OrderReview", //提交订单
                               @"VC_MineOrders", //我的订单
                               @"VC_MyWallet", //我的钱包
                               @"VC_MyOrder", //我的接单
                               @"VC_MyCollection", //我的收藏
                               @"VC_Certification", //我要认证
                               @"VC_OrderDetail", //订单详情
                               @"VC_PayPass", //设置支付密码
                               @"VC_Tech_Order", //接单列表
                               @"VC_Withdrawal_Verify", //提现手机认证
                               @"VC_ReleaseLetterPerform", //发布履约保函
                               @"VC_ConfirmLetter" //我要开保函
                               
                               ];
    //需要登录的页面未登录，跳转至登录页面
    if ([canLoginVCIDS containsObject:vcID] && ![CommonUtil isLogin]) {
        UINavigationController *loginNav = [[UIStoryboard storyboardWithName:@"TB2" bundle:nil] instantiateViewControllerWithIdentifier:@"NVC_Login"];
        [controller presentViewController:loginNav animated:YES completion:nil];
        return NO;
    }
    return YES;
}

+ (void)presentLoginViewController {
    UINavigationController *loginNav = [[UIStoryboard storyboardWithName:@"TB2" bundle:nil] instantiateViewControllerWithIdentifier:@"NVC_Login"];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginNav animated:YES completion:nil];
}

+ (void)presentLoginVCWithParameter:(NSDictionary *)parameters {
    UINavigationController *loginNav = [[UIStoryboard storyboardWithName:@"TB2" bundle:nil] instantiateViewControllerWithIdentifier:@"NVC_Login"];
    VC_Login *login = loginNav.viewControllers.firstObject;
    login.parameters = parameters;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginNav animated:YES completion:nil];
}

@end
