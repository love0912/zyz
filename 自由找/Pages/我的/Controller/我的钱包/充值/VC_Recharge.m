//
//  VC_Recharge.m
//  自由找
//
//  Created by guojie on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Recharge.h"

@interface VC_Recharge ()
{
    NSInteger _returnType;
}

@end

@implementation VC_Recharge

- (void)initData {
    NSString *price = [self.parameters objectForKey:kPageDataDic];
    if (price != nil) {
        _tf_money.text = price;
        _btn_next.enabled = YES;
    } else {
        _btn_next.enabled = NO;
    }
    
    _returnType = [[self.parameters objectForKey:kPageReturnType] integerValue];
}

- (void)layoutUI {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableRegistButton:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - 验证必输项是否输入
- (void)enableRegistButton:(NSNotification *)notification {
    if (![self isNull:_tf_money]) {
        _btn_next.enabled = YES;
    } else {
        _btn_next.enabled = NO;
    }
}

- (BOOL)isNull:(UITextField *)textfield {
    if (textfield.text.trimWhitesSpace.length == 0) {
        return YES;
    }
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"账户充值";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_next_pressed:(id)sender {
//    [PageJumpHelper pushToVCID:@"VC_RechargeWay" storyboard:Storyboard_Mine parent:self];
    [PageJumpHelper pushToVCID:@"VC_RechargeWay" storyboard:Storyboard_Mine parameters:@{kPageDataDic:_tf_money.text, kPageReturnType: @(_returnType)} parent:self];
}
@end
