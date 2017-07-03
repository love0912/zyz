//
//  UpdateWindow.h
//  自由找
//
//  Created by 郭界 on 16/9/21.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateWindow : UIWindow

+(UpdateWindow *)sharedInstance;

/**
 弹出视图

 @param content     显示的更新内容
 @param version   显示的版本号
 @param urlString 下载地址
 @param type      1--强制更新， 2--提示更新
 */
- (void)showInContent:(NSString *)content version:(NSString *)version donwloadUrlString:(NSString *)urlString type:(NSInteger)type;

@end
