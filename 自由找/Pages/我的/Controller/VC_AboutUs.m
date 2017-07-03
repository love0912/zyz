//
//  VC_AboutUs.m
//  自由找
//
//  Created by xiaoqi on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_AboutUs.h"

@interface VC_AboutUs ()

@end

@implementation VC_AboutUs

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"关于我们";
    [self zyzOringeNavigationBar];
    [self initData];
}
-(void)initData{
    _lb_version.text=[self shortVersion];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
