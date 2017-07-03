//
//  VC_OrderSubmit.m
//  自由找
//
//  Created by guojie on 16/8/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_OrderSubmit.h"
#import "ProductService.h"
#import "PayService.h"
#import "LPTradeView.h"
#import "SwipeBack.h"
#define TipsPreCount 22

@interface VC_OrderSubmit ()
{
    OrderInfoDomain *_orderInfo;
    ProductService *_productService;
    /**
     *  1 -- 从购买页进入支付完成， 2 -- 从我的订单详情页未支付跳转过来支付
     */
    NSInteger _type;
    
    PayService *_payService;
    
    Boolean _isNotification;
    NSInteger _payCount;
    
    NSTimer *_payTimer;
    Boolean _isContinuePay;
    NSString *_password;
    
}
@end

@implementation VC_OrderSubmit

- (void)initData {
    _orderInfo = [self.parameters objectForKey:kPageDataDic];
    _type = [[self.parameters objectForKey:kPageType] integerValue];
//    
//    _orderInfo = [[OrderInfoDomain alloc] init];
//    _orderInfo.POAmount = @"12000.00";
//    _orderInfo.CouponAmount = @"0";
    
    _productService = [ProductService sharedService];
    _payService = [PayService sharedService];
    
    _isNotification = NO;
}

- (void)layoutUI {
    _btn_agree.selected = YES;
    
    if ([_orderInfo.CouponAmount isEqualToString:@"0"] || _orderInfo.CouponAmount == nil) {
        _v_coupon.hidden = YES;
        NSString *tips = [NSString stringWithFormat:@"交易过程中，在您的钱包余额中，系统将自动冻结%@元，系统将在资料提交后自动扣款。", _orderInfo.POAmount];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:tips];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[CommonUtil zyzOrangeColor] range:NSMakeRange(TipsPreCount,_orderInfo.POAmount.length)];
        _lb_tips.attributedText = attributeString;
    } else {
        CGFloat price_1 = [_orderInfo.POAmount floatValue];
        CGFloat coupou_1 = [_orderInfo.CouponAmount floatValue];
        CGFloat total_1 = price_1 - coupou_1;
        NSString *tips = [NSString stringWithFormat:@"交易过程中，在您的钱包余额中，系统将自动冻结%@元，优惠券%@元。在自由找将您购买的方案提交给您后，系统将自动将你钱包中冻结的金额扣取。如果自由找未能按时提交您的方案或提交的方案不满足招标文件要求，您可以申请退款。", [NSString stringWithFormat:@"%.0f", total_1], _orderInfo.CouponAmount];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:tips];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[CommonUtil zyzOrangeColor] range:NSMakeRange(TipsPreCount,_orderInfo.POAmount.length)];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[CommonUtil zyzOrangeColor] range:NSMakeRange(TipsPreCount + _orderInfo.POAmount.length + 5,_orderInfo.CouponAmount.length)];
        _lb_tips.attributedText = attributeString;
    }
    
    _lb_money.text = _orderInfo.POAmount;
    _lb_coupon.text = [NSString stringWithFormat:@"抵用券%@元", _orderInfo.CouponAmount];
    
    CGFloat price = [_orderInfo.POAmount floatValue];
    CGFloat coupou = [_orderInfo.CouponAmount floatValue];
    CGFloat total = price - coupou;
    _lb_total.text = [NSString stringWithFormat:@"%.0f元", total];
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"确认订单";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.swipeBackEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.swipeBackEnabled = YES;
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
                [LPTradeView tradeViewNumberKeyboardWithMoney:[NSString stringWithFormat:@"%@", _orderInfo.POAmount] password:^(NSString *password) {
                    _password = password;
                    //        NSLog(@"密码是:%@",password);
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(payWithPasswordByTimer:) userInfo:password repeats:NO];
                }];
            } else {
                [self payWithPassword:_password];
            }
        }
    }];
}

- (void)payWithPassword:(NSString *)password {
    [_productService payOrderByID:_orderInfo.SerialNo password:password result:^(NSInteger code) {
        if (code == 1) {
            if (_isNotification) {
                [_payTimer invalidate];
            }
            if ([[self.parameters objectForKey:@"ProductType"] integerValue] == 1) {
                [CountUtil countTechBuySuccess];
            } else {
                [CountUtil countBudgeBuySuccess];
            }
            
            
            //支付成功
            //TODO: 调转至我的订单
            if (_type == 1) {
                [PageJumpHelper pushToVCID:@"VC_MineOrders" storyboard:Storyboard_Mine parameters:@{kPageType:@(1)} parent:self];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OrderDetail_Refresh object:nil];
                [self goBack];
            }
        }else if (code==301){//充值
            if (_isNotification) {
                [ProgressHUD showProgressHUDWithInfo:@""];
                return;
            }
            [JAlertHelper jAlertWithTitle:@"余额不足，是否前去充值？" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    NSString *price = _orderInfo.POAmount;
                    [PageJumpHelper pushToVCID:@"VC_Recharge" storyboard:Storyboard_Mine parameters:@{kPageDataDic: price, kPageReturnType: @1} parent:self];
                }
            }];
        }else if (code==302){//未开通
            [JAlertHelper jAlertWithTitle:@"未开通钱包，是否前去开通？" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [PageJumpHelper pushToVCID:@"VC_PayPass" storyboard:Storyboard_Mine parameters:@{kPageType:@"1"} parent:self];
                }
            }];
            
        } else {
            _password = nil;
        }
        
    }];
}

- (void)payWithPasswordByTimer:(NSTimer *)timer {
    NSString *password = timer.userInfo;
    [self payWithPassword:password];
}

- (void)backPressed {
    if (_type == 1) {
//        NSArray *vcs = self.navigationController.viewControllers;
//        UIViewController *backVC = [vcs objectAtIndex:vcs.count - 3];
//        [self.navigationController popToViewController:backVC animated:NO];
//        [self performSelector:@selector(pushToMyOrder) withObject:nil afterDelay:0.1];
        [JAlertHelper jAlertWithTitle:@"您还没有支付成功,要离开吗？" message:nil cancleButtonTitle:@"继续支付" OtherButtonsArray:@[@"确认离开"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [PageJumpHelper pushToVCID:@"VC_MineOrders" storyboard:Storyboard_Mine parameters:@{kPageType:@3} parent:self];
            }
        }];
    } else {
        [self goBack];
    }
}

- (void)pushToMyOrder {
    
}

- (IBAction)btn_agree_pressed:(id)sender {
    _btn_agree.selected = !_btn_agree.selected;
}

- (IBAction)btn_buy_procotol_pressed:(id)sender {
    [CommonUtil showBuyProductProtocalInController:self];
}
@end
