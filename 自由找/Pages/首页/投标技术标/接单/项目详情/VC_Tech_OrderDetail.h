//
//  VC_Tech_OrderDetail.h
//  自由找
//
//  Created by xiaoqi on 16/8/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"
#import "View_OrderTakeBounced.h"
@interface VC_Tech_OrderDetail : VC_Base<OrderTakeBouncedDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *btn_applyOrder;
- (IBAction)btn_applyorder_press:(id)sender;

@end
