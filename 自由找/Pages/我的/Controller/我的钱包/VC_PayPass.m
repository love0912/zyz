//
//  VC_PayPass.m
//  自由找
//
//  Created by guojie on 16/8/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_PayPass.h"
#import "Masonry.h"
#import "PayService.h"

@interface VC_PayPass ()
{
    //验证码
    NSTimer *_codeTimer;
    int _countDown;
    
    UIView *_v_activeTip_back;
    UIView *_v_activeTip_content;
    UILabel *_lb_countdown;
    NSInteger _countActive;
    NSTimer *_activeTimer;
    
    PayService *_payService;
    
    /*
     * 返回类型执行
     * 1 -- 投标保函购买
     */
    NSInteger _returnType;
}

@end

@implementation VC_PayPass

- (void)initData {
//    self.tf_phone.text = @"13752919675";
    
    self.tf_phone.text = [CommonUtil getUserDomain].Phone;
    _countDown = 59;
    _countActive = 3;
    
    _payService = [PayService sharedService];
    _returnType = [[self.parameters objectForKey:kPageReturnType] integerValue];
}

- (void)layoutUI {
    [self.btn_getCode setTitle:[NSString stringWithFormat:@"%d秒后获取", _countDown] forState:UIControlStateDisabled];
    _btn_commit.enabled = NO;
    _btn_agree.selected = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableRegistButton:) name:UITextFieldTextDidChangeNotification object:nil];
    
    
//    UserDomain *user = [CommonUtil getUserDomain];
//    self.tf_phone.text = user.Phone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"设置钱包密码";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - 验证必输项是否输入
- (void)enableRegistButton:(NSNotification *)notification {
    if (![self isNull:_tf_phone] &&
        ![self isNull:_tf_pass] &&
        ![self isNull:_tf_rePass] &&
        ![self isNull:_tf_code]) {
        _btn_commit.enabled = YES;
    } else {
        _btn_commit.enabled = NO;
    }
    
    UITextField *textField = notification.object;
    if (_tf_pass == textField || _tf_rePass == textField) {
        NSString *text = textField.text;
        if (text.trimWhitesSpace.length > 6) {
            textField.text = [text substringWithRange:NSMakeRange(0, 6)];
        }
    }
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

    if (![_tf_pass.text isValidPayPassword]) {
        [ProgressHUD showInfo:@"钱包密码为6位数字" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (![_tf_pass.text isEqualToString:_tf_rePass.text]) {
        [ProgressHUD showInfo:@"两次密码输入不一致" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (!_btn_agree.isSelected) {
        [ProgressHUD showInfo:@"请勾选同意《自由找用户协议》" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
}

#pragma mark - 


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

- (void)getCodeSuccess {
    [_tf_code becomeFirstResponder];
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

- (IBAction)btn_code_pressed:(id)sender {
    if ([_tf_phone.text isValidPhone]) {
        [_payService getPayCodeByPhone:_tf_phone.text Type:@"3" result:^(NSInteger code, NSString *identifiyCode) {
            if (code == 1) {
                [self getCodeSuccess];
            }
        }];
    } else {
        [ProgressHUD showInfo:@"手机号码不合法，请联系自由找客服" withSucc:NO withDismissDelay:2];
    }
}

- (IBAction)btn_agree_pressed:(id)sender {
    _btn_agree.selected = !_btn_agree.selected;
}

- (IBAction)btn_payProtocol_pressed:(id)sender {
    [CommonUtil showUserProtocalInController:self];
}
- (IBAction)btn_commit_pressed:(id)sender {
    if ([self checkInput]) {
        [_payService createWalletWithPhone:_tf_phone.text password:_tf_pass.text identifyCode:_tf_code.text result:^(NSInteger code) {
            if (code == 1) {
                if ([[self.parameters objectForKey:kPageType] integerValue] == 1) {
                    NSString *title = @"钱包创建成功，系统赠送您价值一千元的抵用券，快去够买吧！";
                    [JAlertHelper jAlertWithTitle:title message:nil cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                        [self goBack];
                        if (_returnType == 1) {
                            [CommonUtil notificationWithName:Notification_RePay_BidLetter];
                        }
                    }];
//                    [ProgressHUD showInfo:@"钱包创建成功" withSucc:YES withDismissDelay:2];
                } else {
                    [self showActiveView];
                }
            }
        }];
    }
}


- (void)layoutActiveSuccessView {
    _v_activeTip_back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height)];
    _v_activeTip_back.userInteractionEnabled = YES;
    _v_activeTip_back.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _v_activeTip_content = [[UIView alloc] init];
    _v_activeTip_content.userInteractionEnabled = YES;
    _v_activeTip_content.backgroundColor = [UIColor whiteColor];
    _v_activeTip_content.layer.masksToBounds = YES;
    _v_activeTip_content.layer.cornerRadius = 5;
    
    [_v_activeTip_back addSubview:_v_activeTip_content];
    [_v_activeTip_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_v_activeTip_back.mas_left).with.offset(42);
        make.right.equalTo(_v_activeTip_back.mas_right).with.offset(-42);
        if (IS_IPHONE_6P) {
            make.height.mas_equalTo(290);
        } else {
            make.height.mas_equalTo(272);
        }
        
        make.centerY.equalTo(_v_activeTip_back.mas_centerY);
    }];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_active_success"]];
    [_v_activeTip_content addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_v_activeTip_content.mas_top).with.offset(33);
        make.centerX.equalTo(_v_activeTip_content.mas_centerX);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHex:@"333333"];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"恭喜您，自由找钱包激活成功!";
    [_v_activeTip_content addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).with.offset(27);
        make.left.equalTo(_v_activeTip_content.mas_left).with.offset(10);
        make.right.equalTo(_v_activeTip_content.mas_right).with.offset(-10);
    }];
    _lb_countdown = [[UILabel alloc] init];
    _lb_countdown.textColor = [UIColor colorWithHex:@"666666"];
    _lb_countdown.font = [UIFont systemFontOfSize:14];
    _lb_countdown.textAlignment = NSTextAlignmentCenter;
    _lb_countdown.text = @"3秒后自动进入钱包首页";
    [_v_activeTip_content addSubview:_lb_countdown];
    [_lb_countdown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).with.offset(12);
        make.centerX.equalTo(_v_activeTip_content.mas_centerX);
    }];
    UIView *v_seperate = [[UIView alloc] init];
    v_seperate.backgroundColor = [UIColor colorWithHex:@"dddddd"];
    [_v_activeTip_content addSubview:v_seperate];
    [v_seperate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lb_countdown.mas_bottom).with.offset(25);
        make.left.equalTo(_v_activeTip_content.mas_left);
        make.right.equalTo(_v_activeTip_content.mas_right);
        make.height.mas_offset(1);
    }];
    UIButton *btn_enter = [UIButton buttonWithType:UIButtonTypeSystem];
    btn_enter.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_enter setTitle:@"立即进入" forState:UIControlStateNormal];
    [btn_enter setTitleColor:[CommonUtil zyzOrangeColor] forState:UIControlStateNormal];
    [_v_activeTip_content addSubview:btn_enter];
    [btn_enter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v_seperate.mas_top);
        make.left.equalTo(_v_activeTip_content.mas_left);
        make.bottom.equalTo(_v_activeTip_content.mas_bottom);
        make.right.equalTo(_v_activeTip_content.mas_right);
    }];
    [btn_enter addTarget:self action:@selector(enterPayMainView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showActiveView {
    [self layoutActiveSuccessView];
    [self.view addSubview:_v_activeTip_back];
    [_v_activeTip_back mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _activeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countActiving:) userInfo:nil repeats:YES];
}

- (void)countActiving:(NSTimer *)timer {
    _countActive --;
    NSString *title = [NSString stringWithFormat:@"%ld秒后自动进入钱包首页", _countActive];
    _lb_countdown.text = title;
    if (_countActive == 0) {
        [self enterPayMainView];
    }
}

- (void)enterPayMainView {
    [_activeTimer invalidate];
    if ([self.parameters[kPageType] isEqualToString:@"1"]) {
        [self goBack];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Wallet_ToWalletMain object:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
