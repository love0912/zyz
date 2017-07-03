//
//  ProgressHUD.m
//  金手指
//
//  Created by GUO on 14-2-22.
//  Copyright (c) 2014年 GUO. All rights reserved.
//

#import "ProgressHUD.h"
#import "MBProgressHUD.h"

@implementation ProgressHUD

+(void)showInfo:(NSString *)info withSucc:(BOOL)succ withDismissDelay:(float)delay
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    if (succ) {
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
        [progressHUD setMode:MBProgressHUDModeCustomView];
        progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
        [progressHUD setDetailsLabelText:info];
    }
    else
    {
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
        [progressHUD setMode:MBProgressHUDModeCustomView];
        progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-ErrorMark"]];
        [progressHUD setDetailsLabelText:info];
    }
    
    double delayInSeconds = delay;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [ProgressHUD hideProgressHUD];
    });
}

+(void)showProgressHUDWithInfo:(NSString *)info
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    [progressHUD setLabelText:info];
}

+(void)hideProgressHUD
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
}

@end
