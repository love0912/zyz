//
//  ResponseHelper.m
//  自由找
//
//  Created by guojie on 16/6/21.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "ResponseHelper.h"
#import "BaseConstants.h"

@implementation ResponseHelper

+ (void)handleResponseErrorData:(id)responseObject {
    NSInteger code = [[responseObject objectForKey:kResponseCode] integerValue];
    NSString *msg = [responseObject objectForKey:kResponseMsg];
    if (code == 401) {
        [CommonUtil removeUserDomain];
        [CommonUtil removeObjectforUserDefaultsKey:kUserSessionKey];
        [CommonUtil setMsgCount:0];
        [CommonUtil setMineCount:0];
        //重新登录，跳出登录页面
        [ProgressHUD showInfo:@"登录已过期，请重新登录" withSucc:NO withDismissDelay:2];
        [PageJumpHelper presentLoginViewController];
        
    } else if (code == 0) {
        //失败, 提示2秒
        [ProgressHUD showInfo:msg withSucc:NO withDismissDelay:2];
        
    } else if (code == 20) {
        //对话框提示错误信息
        [JAlertHelper jAlertWithTitle:msg message:nil cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:nil clickAtIndex:^(NSInteger buttonIndex) {
            
        }];
    } else if (code == 301) {
        
    } else if (code == 302) {
        
    }
}

@end
