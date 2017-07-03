//
//  VC_Regist.m
//  自由找
//
//  Created by guojie on 16/6/14.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Regist.h"
#import "Cell_UserRegist.h"
#import "MineService.h"
#define TableViewHeightInIphone6 255

@interface VC_Regist ()
{
    NSArray *_arr_input;
    CGFloat _cellHeight;
    CGFloat _inputViewHeight;
    MineService *_mineService;
    
    //验证码
    NSTimer *_codeTimer;
    int _countDown;
}
@end

@implementation VC_Regist

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"用户注册";
    [self initData];
    [self layoutUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self statusBarLightContent];
}

- (void)initData {
    _arr_input = @[@[@1, @2], @[@3, @4, @5]];
    if (IS_IPHONE_6P) {
        _cellHeight = 54;
        _inputViewHeight = TableViewHeightInIphone6 + (7 * 5);
    } else if (IS_IPHONE_4_OR_LESS) {
        _cellHeight = 40;
        _inputViewHeight = TableViewHeightInIphone6 - (7 * 5);
    } else {
        _cellHeight = 47;
        _inputViewHeight = TableViewHeightInIphone6;
    }
    
    _mineService = [MineService sharedService];
    _countDown = 59;
}

- (void)layoutUI {
    self.jx_background = [CommonUtil zyzOrangeColor];
    self.jx_titleColor = [UIColor whiteColor];
    
    _constraint_inputView_height.constant = _inputViewHeight;
    _constraint_perInput_height.constant = _cellHeight;
    
    _btn_regist.enabled = NO;
    _btn_agree.selected = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableRegistButton) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self.btn_getCode setTitle:[NSString stringWithFormat:@"%d秒后获取", _countDown] forState:UIControlStateDisabled];
    
//    [_tf_userName addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 验证必输项是否输入
- (void)enableRegistButton {
    if (![self isNull:_tf_userName] &&
        ![self isNull:_tf_password] &&
        ![self isNull:_tf_account] &&
        ![self isNull:_tf_identifyCode]) {
        _btn_regist.enabled = YES;
    } else {
        _btn_regist.enabled = NO;
    }
}

- (void)textFieldChange:(UITextField *)textField {
    
}

- (BOOL)isNull:(UITextField *)textfield {
    if (textfield.text.trimWhitesSpace.length == 0) {
        return YES;
    }
    return NO;
}
#pragma mark - 注册处理
/**
 *  检查输入项的合法性
 *
 *  @return
 */
- (BOOL)checkInput {
    if (_tf_userName.text.length > 5) {
        [ProgressHUD showInfo:@"姓名长度不能超过5位" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (![_tf_password.text isValidPassword]) {
        [ProgressHUD showInfo:@"密码长度为6-12位，且不能包含特殊字符" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (![_tf_account.text isValidPhone]) {
        [ProgressHUD showInfo:@"请输入合法的手机号" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (!_btn_agree.isSelected) {
        [ProgressHUD showInfo:@"请勾选同意《自由找用户协议》" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
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

- (IBAction)btn_showPass_Pressed:(id)sender {
    _btn_showPass.selected = !_btn_showPass.selected;
    if (_btn_showPass.isSelected) {
        _tf_password.secureTextEntry = NO;
    } else {
        _tf_password.secureTextEntry = YES;
    }
    NSString *trimmedString = _tf_password.text;
    _tf_password.text = @"";
    _tf_password.text = trimmedString;
}


- (IBAction)btn_getCode_pressed:(id)sender {
    if ([_tf_account.text isValidPhone]) {
        [_mineService getCodeWithPhone:_tf_account.text type:@"1" result:^(NSInteger code) {
            if (code == 1) {
                [self getCodeSuccess];
            }
        }];
    } else {
        [ProgressHUD showInfo:@"请输入合法的手机号码" withSucc:NO withDismissDelay:2];
    }
}

- (void)getCodeSuccess {
    [_tf_identifyCode becomeFirstResponder];
    [ProgressHUD showInfo:@"验证码已发送" withSucc:YES withDismissDelay:1];
    _btn_getCode.enabled = NO;
    _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)countDown {
    _countDown --;
    NSString *buttonTitle = [NSString stringWithFormat:@"%d秒后获取", _countDown];
    [self.btn_getCode setTitle:buttonTitle forState:UIControlStateDisabled];
    if (_countDown == 0) {
        _countDown = 59;
        self.btn_getCode.enabled = YES;
        [_codeTimer invalidate];
        [self.btn_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.btn_getCode setTitle:[NSString stringWithFormat:@"%d秒后获取", _countDown] forState:UIControlStateDisabled];
    }
}

- (IBAction)btn_agree_pressed:(id)sender {
    _btn_agree.selected = !_btn_agree.selected;
}

- (IBAction)btn_userProtocal_pressed:(id)sender {
    [CommonUtil showUserProtocalInController:self];
}
- (IBAction)btn_regist_pressed:(id)sender {
    if ([self checkInput]) {
        [self ziyouzhaoRegister];
    }
}
-(void)ziyouzhaoRegister{
    NSDictionary *paramDic = @{kRegistUserName: _tf_userName.text, kRegistPassword: [CommonUtil getMd5_32Bit:_tf_password.text], kRegistAccount: _tf_account.text, kRegistIdentifyCode: _tf_identifyCode.text, kRegistInviteCode: (_tf_inviteCode.text == nil ? @"" : _tf_inviteCode.text), kRegistDevice: @0};
    [_mineService registUserWithParameters:paramDic result:^(UserDomain *user, NSInteger code) {
        if (code != 1) {
            return ;
        }
        [CommonUtil saveUserDomian:user];
//        [self EMRegister];
        [ProgressHUD showInfo:@"注册成功" withSucc:YES withDismissDelay:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_User_Login_Success object:nil];
        //            [self goBack];
    }];

}
//-(void)EMRegister{
//    __weak typeof(self) weakself = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        EMError *error = [[EMClient sharedClient] registerWithUsername:weakself.tf_account.text password:weakself.tf_password.text];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakself hideHud];
//            if (!error) {
//                TTAlertNoTitle(NSLocalizedString(@"register.success", @"Registered successfully, please log in"));
//               
//            }else{
//                switch (error.code) {
//                    case EMErrorServerNotReachable:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
//                        break;
//                    case EMErrorUserAlreadyExist:
//                        TTAlertNoTitle(NSLocalizedString(@"register.repeat", @"You registered user already exists!"));
//                        break;
//                    case EMErrorNetworkUnavailable:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
//                        break;
//                    case EMErrorServerTimeout:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
//                        break;
//                    default:
//                        NSLog(@"%u",error.code);
//                        TTAlertNoTitle(NSLocalizedString(@"register.fail", @"Registration failed"));
//                        break;
//                }
//            }
//        });
//    });
//
//}
- (IBAction)btn_backLogin_pressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backPressed {
    if (_isPresentView) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self goBack];
    }
}
@end
