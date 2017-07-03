//
//  VC_ServiceCenter.m
//  自由找
//
//  Created by xiaoqi on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_ServiceCenter.h"

@interface VC_ServiceCenter (){
    UIWebView *phoneCallWebView;          //电话
    CGFloat _cellHeight;
    CGFloat _versionToPhoneheight;
}

@end

@implementation VC_ServiceCenter

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"客服中心";
    self.jx_background = [CommonUtil zyzOrangeColor];
    self.jx_titleColor = [UIColor whiteColor];
    [self initData];
    [self layoutUI];
}
-(void)initData{
     _lb_Version.text=[self shortVersion];
    if (IS_IPHONE_6P) {
//        _cellHeight = 44;
        _versionToPhoneheight=45;
    } else if (IS_IPHONE_4_OR_LESS) {
//        _cellHeight = 40;
        _versionToPhoneheight=18;
    } else {
//        _cellHeight = 48;
        _versionToPhoneheight=40;
    }
    _cellHeight = 48;

}
-(void)layoutUI{
    _layout_height.constant=_cellHeight;
    _layout_vsersionTophoneHeight.constant=_versionToPhoneheight;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btn_callPhone_press:(id)sender {
    NSString * phoneNumber=[NSString stringWithFormat:@"telprompt://400-021-3618"];
//     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    if (!phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneNumber]]];

}
@end
