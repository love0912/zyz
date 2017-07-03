//
//  VC_ForgetPwd.m
//  自由找
//
//  Created by xiaoqi on 16/6/27.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_ForgetPwd.h"
#import "MineService.h"
#define TableViewHeightInIphone6 255
@interface VC_ForgetPwd (){
    CGFloat _viewHeight;
    MineService *_mineService;
    //获取验证码
    int _countDown;
     NSTimer *_codeTimer;
}

@end

@implementation VC_ForgetPwd

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"找回密码";
    self.jx_background = [CommonUtil zyzOrangeColor];
    self.jx_titleColor = [UIColor whiteColor];
    [self initData];
    [self layoutUI];
    
    
    //从登录状态修改密码
    if (self.parameters != nil) {
        NSString *phone = [self.parameters objectForKey:kPageDataDic];
        _tf_phone.text = phone;
        _tf_phone.enabled = NO;
    }
}
- (void)initData {
    _mineService = [MineService sharedService];
    _countDown = 59;

    if (IS_IPHONE_6P) {
        _viewHeight = 54;
    } else if (IS_IPHONE_4_OR_LESS) {
        _viewHeight = 40;
    } else {
        _viewHeight = 47;
    }
}
- (void)layoutUI{
    _constraint_perInput_height.constant = _viewHeight;
    [self.btn_code setTitle:[NSString stringWithFormat:@"%d秒后获取", _countDown] forState:UIControlStateDisabled];
    
    NSString *phone = [[CommonUtil objectForUserDefaultsKey:kLastLoginPhone] toString];
    if (phone != nil) {
        _tf_phone.text = phone;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self statusBarLightContent];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btn_login_pressed:(id)sender {
    if ([self checkPhone] && [self checkInput]) {
        NSDictionary *paramDic = @{kResetPhone: _tf_phone.text, kRegistPassword: [CommonUtil getMd5_32Bit:_tf_pwd.text], kRegistIdentifyCode: _tf_code.text};
        [_mineService resetPasswordWithParameters:paramDic result:^(NSInteger code) {
            if (code == 1) {
                [ProgressHUD showInfo:@"密码修改成功" withSucc:YES withDismissDelay:1];
                [self goBack];
            }
        }];
    }
}

- (IBAction)btn_code_pressed:(id)sender {
    if ([self checkPhone]) {
        [_mineService getCodeWithPhone:_tf_phone.text type:@"2" result:^(NSInteger code) {
            if (code == 1) {
                [self getCodeSuccess];
            }
        }];
    }
}

- (void)getCodeSuccess {
    [_tf_code becomeFirstResponder];
    [ProgressHUD showInfo:@"验证码已发送" withSucc:YES withDismissDelay:1];
    _btn_code.enabled = NO;
    _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (BOOL)checkPhone {
    if (![self.tf_phone.text isValidPhone]) {
        [ProgressHUD showInfo:@"手机号不合法" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
}
- (BOOL)checkInput {
    if (self.tf_code.text.trimWhitesSpace.length == 0) {
        [ProgressHUD showInfo:@"验证码不能为空" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (![_tf_pwd.text isValidPassword]) {
        [ProgressHUD showInfo:@"密码长度为6-12位，且不能包含特殊字符" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
}
#pragma mark - 验证码的倒计时
- (void)countDown {
    _countDown --;
    NSString *buttonTitle = [NSString stringWithFormat:@"%d秒后获取", _countDown];
    [_btn_code setTitle:buttonTitle forState:UIControlStateDisabled];
    if (_countDown == 0) {
        _countDown = 59;
        _btn_code.enabled = YES;
        [_codeTimer invalidate];
        [_btn_code setTitle:@"重新获取" forState:UIControlStateNormal];
        [_btn_code setTitle:[NSString stringWithFormat:@"%d秒后获取", _countDown] forState:UIControlStateDisabled];
    }
}
- (IBAction)btn_showPass_Pressed:(id)sender {
    _btn_showpass.selected = !_btn_showpass.selected;
    if (_btn_showpass.isSelected) {
        _tf_pwd.secureTextEntry = NO;
    } else {
        _tf_pwd.secureTextEntry = YES;
    }
    NSString *trimmedString = _tf_pwd.text;
    _tf_pwd.text = @"";
    _tf_pwd.text = trimmedString;
}
@end
