//
//  VC_Withdrawal_Verify.m
//  自由找
//
//  Created by guojie on 16/8/31.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Withdrawal_Verify.h"
#import "PayService.h"

@interface VC_Withdrawal_Verify ()
{
    //验证码
    NSTimer *_codeTimer;
    int _countDown;
    PayService *_payService;
}
@end

@implementation VC_Withdrawal_Verify

- (void)initData {
    _countDown = 59;
    _payService = [PayService sharedService];
}

- (void)layoutUI {
    [self.btn_code setTitle:[NSString stringWithFormat:@"%d秒后获取", _countDown] forState:UIControlStateDisabled];
    _btn_commit.enabled = NO;
    
    NSString *phone = [CommonUtil getUserDomain].Phone;
    NSString *showPhoneString = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    _lb_phone.text = showPhoneString;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableRegistButton:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"手机认证";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - 验证必输项是否输入
- (void)enableRegistButton:(NSNotification *)notification {
    if (![self isNull:_tf_code]) {
        _btn_commit.enabled = YES;
    } else {
        _btn_commit.enabled = NO;
    }
}

- (BOOL)isNull:(UITextField *)textfield {
    if (textfield.text.trimWhitesSpace.length == 0) {
        return YES;
    }
    return NO;
}

- (void)getCodeSuccess {
    [_tf_code becomeFirstResponder];
    [ProgressHUD showInfo:@"验证码已发送" withSucc:YES withDismissDelay:1];
    _btn_code.enabled = NO;
    _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown {
    _countDown --;
    NSString *buttonTitle = [NSString stringWithFormat:@"%d秒后获取", _countDown];
    [self.btn_code setTitle:buttonTitle forState:UIControlStateDisabled];
    if (_countDown == 0) {
        _countDown = 59;
        self.btn_code.enabled = YES;
        [_codeTimer invalidate];
        [self.btn_code setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.btn_code setTitle:[NSString stringWithFormat:@"%d秒后获取", _countDown] forState:UIControlStateDisabled];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (IBAction)btn_code_pressed:(id)sender {
    [_payService getPayCodeByPhone:[CommonUtil getUserDomain].Phone Type:@"4" result:^(NSInteger code, NSString *identifiyCode) {
        if (code == 1) {
            [self getCodeSuccess];
        }
    }];
}
- (IBAction)btn_commit_pressed:(id)sender {
    [_payService withdrawalVerifyByPhone:[CommonUtil getUserDomain].Phone code:_tf_code.text result:^(NSInteger code) {
        if (code == 1) {
            WalletDomain *wallet = [self.parameters objectForKey:kPageDataDic];
            [PageJumpHelper pushToVCID:@"VC_Withdrawal" storyboard:Storyboard_Mine parameters:@{kPageDataDic: wallet} parent:self];
        }
    }];
}
@end
