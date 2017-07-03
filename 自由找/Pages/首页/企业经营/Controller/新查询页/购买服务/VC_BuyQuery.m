//
//  VC_BuyQuery.m
//  zyz
//
//  Created by 郭界 on 17/1/11.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "VC_BuyQuery.h"
#import "Cell_BuyQuery.h"
#import "NewQueryService.h"
#import "PayService.h"
#import "LPTradeView.h"

@interface VC_BuyQuery ()<UITableViewDelegate, UITableViewDataSource>
@end

@implementation VC_BuyQuery
{
    NSMutableArray *_arr_buyService;
    NSInteger _selectIndex;
    NewQueryService *_queryService;
    PayService *_payService;
    NSString *_password;
    NSString *_PayFee;
    NSString *_ServiceOId;
    
    Boolean _isNotification;
    NSInteger _payCount;
    NSTimer *_payTimer;
    Boolean _isContinuePay;
    
    BuyQueryDomain *_buyQueryServiceDomain;
}

- (void)initData {
    _selectIndex = 0;
    _queryService = [NewQueryService sharedService];
    _payService = [PayService sharedService];
    _arr_buyService = [NSMutableArray arrayWithCapacity:0];
    
    
    _isNotification = NO;
    
    
//    BuyQueryDomain *buy1 = [BuyQueryDomain domainWithObject:@{@"Name": @"年度会员服务", @"Desc": @"服务时长：12个月", @"Money": @"500元"}];
//    BuyQueryDomain *buy2 = [BuyQueryDomain domainWithObject:@{@"Name": @"半年会员服务", @"Desc": @"服务时长：6个月", @"Money": @"300元"}];
//    BuyQueryDomain *buy3 = [BuyQueryDomain domainWithObject:@{@"Name": @"季度会员服务", @"Desc": @"服务时长：3个月", @"Money": @"200元"}];
//    BuyQueryDomain *buy4 = [BuyQueryDomain domainWithObject:@{@"Name": @"月度会员服务", @"Desc": @"服务时长：1个月", @"Money": @"100元"}];
//    [_arr_buyService addObject:buy1];
//    [_arr_buyService addObject:buy2];
//    [_arr_buyService addObject:buy3];
//    [_arr_buyService addObject:buy4];
    [self getServiceList];
}

- (void)layoutUI {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationPayOrder) name:Notification_RePay_BidLetter object:nil];
}

- (void)getServiceList {
    [_queryService getQueryServiceListResult:^(NSArray<BuyQueryDomain *> *list, NSInteger code) {
        if (code != 1) {
            return ;
        }
        [_arr_buyService setArray:list];
        [_tableView reloadData];
        [self resetPrice];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    self.jx_title = @"购买服务";
    [self initData];
    [self layoutUI];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_buyService.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_BuyQuery";
    Cell_BuyQuery *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    BuyQueryDomain *buyQuery = [_arr_buyService objectAtIndex:indexPath.row];
    cell.buyQueryDomain = buyQuery;
    cell.isSelected = (_selectIndex == indexPath.row ? YES : NO);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectIndex = indexPath.row;
    [_tableView reloadData];
    [self resetPrice];
}

#pragma mark - 
- (void)resetPrice {
    BuyQueryDomain *buyQuery = _arr_buyService[_selectIndex];
    NSString *price = [NSString stringWithFormat:@"支付金额：%@元", buyQuery.Price];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:price];
    NSRange range = NSMakeRange(5, price.length - 5);
    [attrString addAttribute:NSForegroundColorAttributeName value:[CommonUtil zyzOrangeColor] range:range];
    [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:range];
    _lb_payMoney.attributedText = attrString;
    
    _PayFee = buyQuery.Price;
    _ServiceOId = buyQuery.ServiceOId;
    _buyQueryServiceDomain = buyQuery;
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

- (IBAction)btn_buy_pressed:(id)sender {
    [self payOrder];
}

- (void)payOrderByID:(NSString *)orderId {
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
                [LPTradeView tradeViewNumberKeyboardWithMoney:[NSString stringWithFormat:@"%@", _PayFee] moneyTag:@"金额" password:^(NSString *password) {
                    _password = password;
                    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(payWithPasswordByTimer:) userInfo:password repeats:NO];
                } cancel:^(BOOL cancel) {
                    if (cancel) {
                        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(cancelInputPassword:) userInfo:nil repeats:NO];
                    }
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

- (void)cancelInputPassword:(NSTimer *)timer {
    [JAlertHelper jAlertWithTitle:@"您还没有支付成功,要离开吗？" message:nil cancleButtonTitle:@"继续支付" OtherButtonsArray:@[@"确认离开"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [PageJumpHelper pushToVCID:@"VC_MineOrders" storyboard:Storyboard_Mine parameters:@{kPageType:@3} parent:self];
        } else {
            [self payOrder];
        }
    }];
}

- (void)payOrder {
    [self payOrderByID:_ServiceOId];
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

- (void)payWithPassword:(NSString *)password {
    [_queryService buyQueryServiceByOId:_ServiceOId password:password result:^(NSInteger code) {
        if (code == 1) {
            if (_isNotification) {
                [_payTimer invalidate];
            }
            
//            [CountUtil countBidLetterBuySuccess];
            
            NSString *msg = [NSString stringWithFormat:@"服务时长:%@个月", _buyQueryServiceDomain.ValidPeriod];
            //支付成功, 退出查询
            [JAlertHelper jAlertWithTitle:@"恭喜您开通服务成功" message:msg cancleButtonTitle:@"马上去查询!" OtherButtonsArray:nil
                         showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                            [self goBack];
                         }];
        }else if (code==301){//充值
            if (_isNotification) {
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
            
        } else {
            _password = nil;
        }

    }];
}
@end
