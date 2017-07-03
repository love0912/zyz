//
//  VC_PayToPC.m
//  zyz
//
//  Created by 郭界 on 17/1/3.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "VC_PayToPC.h"

@interface VC_PayToPC ()
{
    //0 -- 保函, 1 -- 技术标， 2 -- 预算
    NSInteger _type;
}
@end

@implementation VC_PayToPC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    self.jx_title = @"电脑支付提示";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backPressed {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
