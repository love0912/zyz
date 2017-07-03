//
//  VC_ScanResult.m
//  自由找
//
//  Created by guojie on 16/7/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_ScanResult.h"

@interface VC_ScanResult ()
{
    /**
     *  0 -- 扫描登录进来， 1 -- 其他扫描结果
     */
    NSInteger _type;
}
@end

@implementation VC_ScanResult

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"扫描成功";
    [self zyzOringeNavigationBar];
//    _delegate = [self.parameters objectForKey:kPageDataDic];
    
    if (self.parameters != nil) {
        _type = [[self.parameters objectForKey:kPageType] integerValue];
    }
    
    _lb_result.hidden = YES;
    if (_type == 1) {
        self.jx_title = @"扫描结果";
        _lb_result.hidden = NO;
        _lb_tips.hidden = YES;
        _btn_return.hidden = YES;
        
        _lb_result.text = [self.parameters objectForKey:kPageDataDic];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_return_pressed:(id)sender {
    [self goBack];
}

//- (void)backPressed {
//    [JAlertHelper jAlertWithTitle:@"是否已完成发布" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
//        if (buttonIndex == 0) {
//            //否
//        } else {
//            
//        }
//    }];
//}

- (void)finishRelease {
    
}
@end
