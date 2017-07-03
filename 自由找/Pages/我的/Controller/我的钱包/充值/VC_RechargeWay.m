//
//  VC_RechargeWay.m
//  自由找
//
//  Created by guojie on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_RechargeWay.h"
#import "PayService.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "YijiPayLib.h"

#define APPSCHEME @"Ziyouzhao"
#define YiJiPartnerID @"20160615020011662930"
#define YiJiSignKey @"c6df06e137b5d8359f350611f3c6628b"


//#define Test_YiJiSignKey @"3e5509cd3ab2c0ca73cc178d274dcd33"
//#define Test_YiJiPartnerID @"20160606020000748137"

#define TenPayPartnerID @""


#define CellAliPay @"AliPay"
#define CellTenPay @"TenPay"
#define CellYijiPay @"YijiPay"

@interface VC_RechargeWay ()<WXApiDelegate, YJEPayDelegate>
{
    NSArray *_arr_menu;
    NSString *_money;
    PayService *_payService;
    NSString *_tradeNo;
    NSString *_thirdPartyType;
    
    /*
     1 -- 投标保函，
     */
    NSInteger _returnType;
}
@end

@implementation VC_RechargeWay

- (void)initData {
    _arr_menu = @[
                  @{kCellKey: CellAliPay, kCellName: @"支付宝支付", kCellDefaultText: @"推荐安装支付宝客户端使用", kCellImage: @"payway_1"},
                  @{kCellKey: CellTenPay, kCellName: @"微信支付", kCellDefaultText: @"推荐微信6.0以上版本使用", kCellImage: @"payway_2"},
                  @{kCellKey: CellYijiPay, kCellName: @"易极付支付", kCellDefaultText: @"易极付在线安全支付", kCellImage: @"payway_3"}
                  ];
    _money = [self.parameters objectForKey:kPageDataDic];
    _payService = [PayService sharedService];
    
    _returnType = [[self.parameters objectForKey:kPageReturnType] integerValue];
}

- (void)layoutUI {
    _tableView.scrollEnabled = NO;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 10)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tenpayResponse:) name:Notification_TenPay_Result object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayResponse:) name:Notification_AliPay_Result object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"选择支付方式";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_PayWay";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    NSDictionary *tmpDic = [_arr_menu objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:tmpDic[kCellImage]];
    cell.textLabel.text = tmpDic[kCellName];
    cell.detailTextLabel.text = tmpDic[kCellDefaultText];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arr_menu objectAtIndex:indexPath.row];
    NSString *key = tmpDic[kCellKey];
    NSString *thirdPartyType = @"1";
    if ([key isEqualToString:CellAliPay]) {
        thirdPartyType = @"2";
    } else if ([key isEqualToString:CellTenPay]) {
        thirdPartyType = @"3";
    }
    _thirdPartyType = thirdPartyType;
    [self requestPayWayByPayType:thirdPartyType];
    
//    PayReq *request = [[PayReq alloc] init];
////    NSLog(@"%@", self);
//    NSLog(@"%@", request);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 30)];
    backView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenSize.width - 15, 30)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHex:@"666666"];
    label.text = @"选择支付方式";
    [backView addSubview:label];
    return backView;
}

- (void)requestPayWayByPayType:(NSString *)type {
    if ([type isEqualToString:@"3"] && ![WXApi isWXAppInstalled]) {
        [JAlertHelper jAlertWithTitle:@"您还未安装微信，是否前往安装?" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                NSString *urlString = [WXApi getWXAppInstallUrl];
                if ([urlString hasPrefix:@"https"]) {
                    urlString = [urlString stringByReplacingOccurrencesOfString:@"https" withString:@"itms-apps"];
                } else {
                    if ([urlString hasPrefix:@"http"]) {
                        urlString = [urlString stringByReplacingOccurrencesOfString:@"http" withString:@"itms-apps"];
                    }
                }
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }
        }];
        return;
    }
    [_payService requestPayWayByMoney:_money thirdPartyType:type result:^(NSInteger code, NSDictionary *payInfoDic) {
        if (code == 1) {
            [self prepareToPayViewWithPayInfoDic:payInfoDic];
        }
    }];
}

- (void)prepareToPayViewWithPayInfoDic:(NSDictionary *)payInfoDic {
    _tradeNo = [payInfoDic objectForKey:@"TradeNo"];
//    NSString *thirdPartyTradeNo = [payInfoDic objectForKey:@"ThirdPartyTradeNo"];
    NSString *thirdParty = [payInfoDic objectForKey:@"ThirdParty"];
    _thirdPartyType = thirdParty;
//    NSString *sign = [payInfoDic objectForKey:@"Sign"];
    if ([thirdParty isEqualToString:@"1"]) {
        //易极付
        NSString *thirdPartyTradeNo = [payInfoDic objectForKey:@"Yjf"];
//        [self toYijiPayWithTradeOrderID:thirdPartyTradeNo signKey:sign];
        [self toYijiPayWithTradeOrderID:thirdPartyTradeNo signKey:nil];
    } else if ([thirdParty isEqualToString:@"2"]) {
        //支付宝
        NSString *sign = [payInfoDic objectForKey:@"Zfb"];
        [self toAliPayWithOrderString:sign];
    } else {
        //微信支付
        NSDictionary *dic=[payInfoDic objectForKey:@"Wx"];
        [self toTenPayWithDic:dic];
//        [self toTenPayWithPrePayID:thirdPartyTradeNo sign:sign];
    }
    
}

- (void)toAliPayWithOrderString:(NSString *)orderString {
//    NSString *testOrderString = @"app_id=2016052501440851&biz_content={\"subject\":\"pay\",\"body\":\"pay\",\"out_trade_no\":\"T2010123456125\",\"total_amount\":\"0.01\",\"seller_id\":\"2088221665605324\",\"product_code\":\"QUICK_MSECURITY_PAY\"  }&charset=utf-8&method=alipay.trade.app.pay&sign_type=RSA&timestamp=2016-08-18 15:40:49&version=1.0&sign=fwWAheL%2fEZNLt8JJ1yyKbmdbHDWUYTPFo8VPJ0CJefdEDuf%2f%2bsg2UyQMantHrM%2f85KifV8KXLVYKq2wuuryGKPIqok4IkaBG5VGUA2cilHtgioWcMM9SmmkbJkK8xlIsgSkftyKZEy3DSNEJcsc%2fEhA6PAIM5dI7u46%2bv7S4Hzk%3d";
    
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:APPSCHEME callback:^(NSDictionary *resultDic) {
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            [self checkTradeSuccessWithPayResultString:resultDic[@"result"]];
        } else {
//            NSString *descString = resultDic[@"memo"];
            [ProgressHUD showInfo:@"支付失败" withSucc:NO withDismissDelay:2];
        }
    }];
}

- (void)toTenPayWithDic:(NSDictionary *)dic{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [dic objectForKey:@"partnerid"];
    request.prepayId= [dic objectForKey:@"prepayid"];
    request.package = [dic objectForKey:@"package1"];
    request.nonceStr= [dic objectForKey:@"noncestr"];
    request.timeStamp= [[dic objectForKey:@"timestamp"] unsignedIntValue];
    request.sign= [dic objectForKey:@"sign"];
    [WXApi sendReq:request];
}

- (void)toTenPayWithPrePayID:(NSString *)prePayID sign:(NSString *)sign {
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = TenPayPartnerID;
    request.prepayId= prePayID;
    request.package = @"Sign=WXPay";
    request.nonceStr= [self ret32bitString];
    request.timeStamp= [[NSDate date] timeIntervalSince1970] * 1000;
    request.sign= sign;
    [WXApi sendReq:request];
}

- (void)toYijiPayWithTradeOrderID:(NSString *)orderID signKey:(NSString *)key {
    NSDictionary *param = @{kYjParamPartnerID:YiJiPartnerID, kYjParamSignKey: YiJiSignKey,
                            kYjParamTradeOrderID:orderID };
//    NSDictionary *param = @{kYjParamPartnerID:YiJiPartnerID, kYjParamSignKey: YiJiSignKey,kYjParamTradeOrderID:orderID };
    [YijiPayLib startPay:param viewController:self delegate:self];
}

- (void)checkTradeSuccessWithPayResultString:(NSString *)payResult {
    [_payService checkTradeSuccessByTradeNo:_tradeNo amount:_money thirdPartyType:_thirdPartyType payResult:payResult result:^(NSInteger code) {
        if (code == 1) {
            //支付成功
            [self paySuccessToWalletMain];
        }
    }];
}

#pragma mark - wxpay delegate
- (void)tenpayResponse:(NSNotification *)notification {
    PayResp *response = notification.object;
    switch(response.errCode){
        case WXSuccess:
        {
            [self checkTradeSuccessWithPayResultString:response.returnKey];
            //服务器端查询支付通知或查询API返回的结果再提示成功
            NSLog(@"支付成功");
        }
            break;
        default:
        {
            NSLog(@"支付失败，retcode=%d",response.errCode);
            [ProgressHUD showInfo:@"支付失败" withSucc:NO withDismissDelay:2];
        }
            break;
    }
}

- (void)alipayResponse:(NSNotification *)notification {
    NSDictionary *resultDic = notification.object;
    if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
        [self checkTradeSuccessWithPayResultString:resultDic[@"result"]];
    } else {
//        NSString *descString = resultDic[@"memo"];
        [ProgressHUD showInfo:@"支付失败" withSucc:NO withDismissDelay:2];
    }
}


#pragma mark - 易极付
- (void)YJEPayResult:(NSDictionary *)result {
    NSInteger resultCode = [[result objectForKey:kYjResultStatus] integerValue];
    if (resultCode == 200 || resultCode == 201) {
        [self checkTradeSuccessWithPayResultString:@""];
    } else {
//        NSString *resultString = [result objectForKey:kYjResultMessage];
        [ProgressHUD showInfo:@"支付失败" withSucc:NO withDismissDelay:3];
    }
}

- (void)paySuccessToWalletMain {
    [_payService getWalletInfoToResult:^(NSInteger code, WalletDomain *wallet) {
        if (code == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Wallet_RefreshWalletInfo object:wallet];
        }
        //支付成功
        NSArray *tmpArray = self.navigationController.viewControllers;
        UIViewController *vc = [tmpArray objectAtIndex:tmpArray.count - 3];
        [self.navigationController popToViewController:vc animated:YES];
        if (_returnType == 1) {
            [CommonUtil notificationWithName:Notification_RePay_BidLetter];
        }
        
    }];
}

-(NSString *)ret32bitString
{
    char data[32];
    for (int x=0;x<32;data[x++] = (char)('a' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
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

@end
