//
//  VC_CommitLetter.m
//  自由找
//
//  Created by 郭界 on 16/10/14.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_CommitLetter.h"
#import "LetterAddressDomain.h"
#import "PayService.h"
#import "SwipeBack.h"
#import "LPTradeView.h"
#import "LetterService.h"

@interface VC_CommitLetter ()
{
    /**
     *  1 -- 从购买页进入支付完成， 2 -- 从我的订单详情页未支付跳转过来支付
     */
    NSInteger _type;
    LetterAddressDomain *_letterAddress;
    //订单ID
    NSString *_OrderID;
    //支付的费用
    NSString *_PayFee;
    
    PayService *_payService;
    LetterService *_letterService;
    
    NSString *_password;
    
    Boolean _isNotification;
    NSInteger _payCount;
    
    NSTimer *_payTimer;
    Boolean _isContinuePay;
    
    LetterOrderDetailDomain *_orderDetailIInfo;
    
}
@end

@implementation VC_CommitLetter

- (void)initData {
    _type = [[self.parameters objectForKey:kPageType] integerValue];
    _letterAddress = [self.parameters objectForKey:kPageDataDic];
    _OrderID = [self.parameters objectForKey:@"Order_ID"];
    _PayFee = [self.parameters objectForKey:@"Pay_Fee"];
    _orderDetailIInfo = [self.parameters objectForKey:@"OrderDetail_Info"];
    _payService = [PayService sharedService];
    _letterService = [LetterService sharedService];
    
    _isNotification = NO;
}

- (void)layoutUI {
    _btn_agree.selected = YES;
    NSString *tips = [NSString stringWithFormat:@"交易过程中，系统将在您的钱包中冻结%@元。在自由找将您购买的保函提交给您后，系统将自动将你钱包中冻结的金额扣取", _PayFee];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:tips];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[CommonUtil zyzOrangeColor] range:NSMakeRange(17,_PayFee.length)];
    _lb_tips.attributedText = attributeString;
    
    _lb_totalPrice.text = [NSString stringWithFormat:@"%.2lf", _PayFee.floatValue];
    _lb_totalPrice_bottom.text = [NSString stringWithFormat:@"￥%.2lf元", _PayFee.floatValue];
    
    [self reloadAddress];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAddress:) name:@"Notification_Change_Address" object:nil];
}

- (void)changeAddress:(NSNotification *)notification {
    _letterAddress = notification.object;
    [self reloadAddress];
}

- (void)reloadAddress {
    _lb_name.text = _letterAddress.Recipient;
    _lb_phone.text = _letterAddress.Phone;
    _lb_street.text = _letterAddress.Street;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"确认订单";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPayOrder) name:Notification_RePay_BidLetter object:nil];
}

- (void)notificationPayOrder {
    _isNotification = YES;
    _payCount = 0;
    _payTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(addPayCount) userInfo:nil repeats:YES];
    [self payOrder];
}

- (void)addPayCount {
    _payCount++;
    if (_payCount % 5 == 0) {
        [self payWithPassword:_password];
    }
    
    if (_payCount > 30) {
        _isNotification = NO;
        _payCount = 0;
        [ProgressHUD hideProgressHUD];
        [ProgressHUD showInfo:@"请稍后再试" withSucc:NO withDismissDelay:2];
        [_payTimer invalidate];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.swipeBackEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.swipeBackEnabled = YES;
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

- (IBAction)btn_agree_pressed:(id)sender {
    _btn_agree.selected = !_btn_agree.selected;
}


- (IBAction)btn_choiceAddress_pressed:(id)sender {
    if (_type == 1) {
        [PageJumpHelper pushToVCID:@"VC_LetterAddressList" storyboard:Storyboard_Main parent:self];
    }
}

- (IBAction)btn_buy_procotol_pressed:(id)sender {
    NSString *urlString = @"http://jk.ziyouzhao.com:8042/ZYZMobileWeb/Statementv8.html";
    [CommonUtil jxWebViewShowInController:self loadUrl:urlString backTips:nil];
}

- (IBAction)btn_commit_pressed:(id)sender {
    if (_btn_agree.selected) {
        [self payOrder];
    } else {
        [ProgressHUD showInfo:@"请同意购买协议" withSucc:NO withDismissDelay:2];
    }
}

- (void)payOrder {
    //TODO: 支付密码框封装
    //    [PageJumpHelper pushToVCID:@"VC_OrderDetail" storyboard:Storyboard_Main parameters:self.parameters parent:self];
    
    [_payService getWalletInfoToResult:^(NSInteger code, WalletDomain *wallet) {
        if (code != 1) {
            return;
        }
        if (wallet.Balance == nil) {
            [JAlertHelper jAlertWithTitle:@"未开通钱包，是否前去开通？" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [PageJumpHelper pushToVCID:@"VC_PayPass" storyboard:Storyboard_Mine parameters:@{kPageType:@"1"} parent:self];
                }
            }];
        } else {
            if (_password == nil) {
                [LPTradeView tradeViewNumberKeyboardWithMoney:[NSString stringWithFormat:@"%@", _PayFee] password:^(NSString *password) {
                    
                    _password = password;
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(payWithPasswordByTimer:) userInfo:password repeats:NO];
                }];
            } else {
                [self payWithPassword:_password];
            }
            
        }
    }];
}

- (void)payWithPasswordByTimer:(NSTimer *)timer {
    NSString *password = timer.userInfo;
    [self payWithPassword:password];
    
}

- (void)payWithPassword:(NSString *)password {
    [_letterService payLetterOrderByOrderNo:_OrderID payFee:_PayFee addressNo:_letterAddress.OId payPwd:password result:^(NSInteger code) {
        if (code == 1) {
            if (_isNotification) {
                [_payTimer invalidate];
            }
            
            [CountUtil countBidLetterBuySuccess];
            
            //支付成功, 上传资料
//            LetterOrderDetailDomain *letterDetail = [[LetterOrderDetailDomain alloc] init];
//            letterDetail.OrderNo = _OrderID;
            [PageJumpHelper pushToVCID:@"VC_BidLetterProjectInfo" storyboard:Storyboard_Main parameters:@{kPageDataDic:_orderDetailIInfo, kPageType:@(_type)} parent:self];
//            [PageJumpHelper pushToVCID:@"VC_UploadData" storyboard:Storyboard_Main parameters:@{kPageType: @1, kPageDataDic: _OrderID} parent:self];
            
            
            //TODO: 调转至我的订单
            //            if (_type == 1) {
            //                [PageJumpHelper pushToVCID:@"VC_MineOrders" storyboard:Storyboard_Mine parameters:@{kPageType:@(1)} parent:self];
            //            } else {
            //                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OrderDetail_Refresh object:nil];
            //                [self goBack];
            //            }
        }else if (code==301){//充值
            if (_isNotification) {
//                if (_payCount > 30) {
//                    [JAlertHelper jAlertWithTitle:@"您的充值可能还未到账，请稍后在下单，给您带来的不便，尽请谅解!" message:nil cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
//                        [PageJumpHelper pushToVCID:@"VC_MineOrders" storyboard:Storyboard_Mine parameters:@{kPageType:@3} parent:self];
//                    }];
//                } else {
//                    [self payWithPassword:_password];
//                }
                [ProgressHUD showProgressHUDWithInfo:@""];
                return;
            }
            [JAlertHelper jAlertWithTitle:@"余额不足，是否前去充值？" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    NSString *price = _PayFee;
                    [PageJumpHelper pushToVCID:@"VC_Recharge" storyboard:Storyboard_Mine parameters:@{kPageDataDic: price, kPageReturnType: @1} parent:self];
                }
            }];
            
        }else if (code==302){//未开通
            [JAlertHelper jAlertWithTitle:@"未开通钱包，是否前去开通？" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [PageJumpHelper pushToVCID:@"VC_PayPass" storyboard:Storyboard_Mine parameters:@{kPageType:@"1"} parent:self];
                }
            }];
            
        }
    }];
}

- (void)backPressed {
    if (_type == 1) {
        [JAlertHelper jAlertWithTitle:@"您还没有支付成功,要离开吗？" message:nil cancleButtonTitle:@"继续支付" OtherButtonsArray:@[@"确认离开"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [PageJumpHelper pushToVCID:@"VC_MineOrders" storyboard:Storyboard_Mine parameters:@{kPageType:@3} parent:self];
            }
        }];
    } else {
        [self goBack];
    }
}
@end
