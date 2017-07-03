//
//  VC_Export.h
//  自由找
//
//  Created by guojie on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_Export : VC_Base<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSArray *arr_export;

@property (strong, nonatomic) NSString *exportTitle;

//1 -- 导出报名用户.  2 -- 导出我报名的项目
@property (strong, nonatomic) NSString *type;

@end
