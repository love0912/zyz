//
//  ProgressHUD.h
//  金手指
//
//  Created by GUO on 14-2-22.
//  Copyright (c) 2014年 GUO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressHUD : NSObject

+(void)showInfo:(NSString *)info withSucc:(BOOL)succ withDismissDelay:(float)delay;
+(void)showProgressHUDWithInfo:(NSString *)info;
+(void)hideProgressHUD;

@end
