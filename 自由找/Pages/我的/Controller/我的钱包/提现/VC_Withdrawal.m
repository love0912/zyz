//
//  VC_Withdrawal.m
//  自由找
//
//  Created by xiaoqi on 16/8/19.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Withdrawal.h"
#import "PayService.h"
#import "VC_Choice.h"
#import "LPTradeView.h"

@interface VC_Withdrawal ()
{
    NSString *_avaliableMoney;
    PayService *_payService;
    NSDictionary *_bankTypeDic;
    NSString *_password;
    WalletDomain *_wallet;
}
@end

@implementation VC_Withdrawal


- (void)initData {
    _wallet = [self.parameters objectForKey:kPageDataDic];
    _avaliableMoney = _wallet.availableBalance;
    _payService = [PayService sharedService];
}

- (void)layoutUI {
    _lb_avaliableMoney.text = [NSString stringWithFormat:@"可提现金额%@元", _avaliableMoney];
    if ([_wallet.IsCanOutpour isEqualToString:@"1"] && _wallet.Bank != nil) {
        _tf_cardNumber.text = _wallet.BankAccountNo == nil ? @"" : _wallet.BankAccountNo;
        _tf_username.text = _wallet.BankAccountName == nil ? @"" : _wallet.BankAccountName;
        _bankTypeDic = [_wallet.Bank toDictionary];
        [_btn_bankType setTitle:_bankTypeDic[kCommonValue] forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableRegistButton:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - 验证必输项是否输入
- (void)enableRegistButton:(NSNotification *)notification {
    
    UITextField *textField = notification.object;
    if (_tf_money == textField) {
        NSString *text = textField.text;
        NSInteger withdrawalMoney = [text integerValue];
        NSInteger avaliableMoney = [_avaliableMoney integerValue];
        NSInteger maxPerTime = [_wallet.MaxOutpourPer integerValue];
        if (withdrawalMoney > (avaliableMoney >= maxPerTime ? maxPerTime : avaliableMoney)) {
            textField.text = [text substringWithRange:NSMakeRange(0, textField.text.length-1)];
            NSString *tipMsg;
            if (avaliableMoney <= maxPerTime) {
                textField.text = _avaliableMoney;
                tipMsg = [NSString stringWithFormat:@"最多只能提现%@元", _avaliableMoney];
            } else {
                textField.text = _wallet.MaxOutpourPer;
                tipMsg = [NSString stringWithFormat:@"单笔只能提现%@元", _wallet.MaxOutpourPer];
            }
            [ProgressHUD showInfo:tipMsg withSucc:NO withDismissDelay:3];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title=@"余额提现";
    [self zyzOringeNavigationBar];
    
    [self initData];
    [self layoutUI];
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

/**
 *  检查输入项的合法性
 *
 *  @return
 */
- (BOOL)checkInput {
    
    if ([_tf_username.text isEmptyString]) {
        [ProgressHUD showInfo:@"请输入开户名" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if ([_tf_cardNumber.text isEmptyString]) {
        [ProgressHUD showInfo:@"请输入银行卡号" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_bankTypeDic == nil) {
        [ProgressHUD showInfo:@"选择银行列表" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if ([_tf_money.text isEmptyString]) {
        [ProgressHUD showInfo:@"输入提现金额" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
}


- (IBAction)btn_withdraw_all:(id)sender {
    NSInteger avaliableMoney = [_avaliableMoney integerValue];
    NSInteger maxPerTime = [_wallet.MaxOutpourPer integerValue];
    if (avaliableMoney <= maxPerTime) {
        _tf_money.text = _avaliableMoney;
    } else {
        [ProgressHUD showInfo:[NSString stringWithFormat:@"单笔只能提现%@元", _wallet.MaxOutpourPer] withSucc:NO withDismissDelay:2];
        _tf_money.text = _wallet.MaxOutpourPer;
    }
}

- (IBAction)btn_commit_pressed:(id)sender {
    [self.view endEditing:YES];
    if ([self checkInput]) {
        [LPTradeView tradeViewNumberKeyboardWithMoney:[NSString stringWithFormat:@"%@", _tf_money.text] password:^(NSString *password) {
            _password = password;
            [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(withdrawalByPassword:) userInfo:nil repeats:NO];
//            [self withdrawalByPassword:password];
        }];
    }
}

- (void)withdrawalByPassword:(NSString *)password {
    [_payService withdrawWithAmount:_tf_money.text password:_password bankDic:_bankTypeDic bankAccountNo:_tf_cardNumber.text backAccountName:_tf_username.text result:^(NSInteger code) {
        if (code == 1) {
            [ProgressHUD showInfo:@"提现申请成功" withSucc:YES withDismissDelay:2];
            [_payService getWalletInfoToResult:^(NSInteger code, WalletDomain *wallet) {
                if (code == 1) {
//                    [ProgressHUD showInfo:@"提现成功" withSucc:YES withDismissDelay:2];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Wallet_RefreshWalletInfo object:wallet];
                    [JAlertHelper jAlertWithTitle:@"提现成功，请注意查收!" message:nil cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                       [self backPressed];
                    }];
                }
            }];
        }
    }];
}

- (IBAction)btn_bankType_pressed:(id)sender {
    [self.view endEditing:YES];
    [_payService getBackTypeListToResult:^(NSInteger code, NSArray<KeyValueDomain *> *bankList) {
        if (code != 1) {
            return ;
        }
        VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
        vc_choice.type = @"0";
        vc_choice.jx_title = @"选择银行";
        NSMutableArray *selectArray = [NSMutableArray array];
        if (_bankTypeDic != nil) {
            [selectArray addObject:_bankTypeDic[kCommonKey]];
        }
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:bankList];
        [vc_choice setDataArray:dataArray selectArray:selectArray];
        vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
            _bankTypeDic = resultDic;
            [_btn_bankType setTitle:resultDic[kCommonValue] forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:vc_choice animated:YES];
    }];
}

- (void)backPressed {
    NSArray *vcs = self.navigationController.viewControllers;
    UIViewController *backVC = [vcs objectAtIndex:vcs.count - 3];
    [self.navigationController popToViewController:backVC animated:YES];
}
@end
