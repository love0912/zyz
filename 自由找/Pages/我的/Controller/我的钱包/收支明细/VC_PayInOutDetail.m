//
//  VC_PayInOutDetail.m
//  自由找
//
//  Created by guojie on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_PayInOutDetail.h"
#import "ExpendDomain.h"

@interface VC_PayInOutDetail ()
{
    NSMutableArray *_arrTmp;
    ExpendDomain *_expend;
}
@end

@implementation VC_PayInOutDetail

- (void)initData {
//    _arrTmp = @[
//                @{kCellName: @"交易单号", kCellDefaultText: @"TP1000000001"},
//                @{kCellName: @"类型", kCellDefaultText: @"订单在线支付"},
//                @{kCellName: @"支付方式", kCellDefaultText: @"微信支付"},
//                @{kCellName: @"时间", kCellDefaultText: @"2016-08-08"},
//                @{kCellName: @"余额", kCellDefaultText: @"12222"},
//                @{kCellName: @"备注", kCellDefaultText: @"惺惺惜惺惺"}
//                ];
    
    _expend = [self.parameters objectForKey:kPageDataDic];
//    _expend = [[ExpendDomain alloc] init];
//    _expend.CreateDt = @"2016-10-10";
//    _expend.Summary = @"会员充值";
//    _expend.Value = @"-300";
//    _expend.TradeNo = @"20111010";
//    _expend.TradeType = @"在线支付";
//    _expend.PayType = @"支付宝支付";
//    _expend.Remark = @"没事随便花一下";
    
    _lb_name.text = _expend.Summary;
    _lb_money.text = [_expend.Value stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"￥"];
    _arrTmp = [NSMutableArray arrayWithCapacity:5];
    [_arrTmp addObject:@{kCellName: @"交易单号", kCellDefaultText: _expend.TradeNo}];
    [_arrTmp addObject:@{kCellName: @"类型", kCellDefaultText: _expend.TradeType}];
    [_arrTmp addObject:@{kCellName: @"支付方式", kCellDefaultText: _expend.PayType}];
    [_arrTmp addObject:@{kCellName: @"时间", kCellDefaultText: _expend.CreateDt}];
    if (_expend.DrawCashInfo != nil) {
        [_arrTmp addObject:@{kCellName: @"姓名", kCellDefaultText: _expend.DrawCashInfo.Name}];
        [_arrTmp addObject:@{kCellName: @"银行卡", kCellDefaultText: _expend.DrawCashInfo.CartNo}];
    }
    [_arrTmp addObject:@{kCellName: @"备注", kCellDefaultText: _expend.Remark}];
//    _arrTmp = @[
//                @{kCellName: @"交易单号", kCellDefaultText: _expend.TradeNo},
//                @{kCellName: @"类型", kCellDefaultText: _expend.TradeType},
//                @{kCellName: @"支付方式", kCellDefaultText: _expend.PayType},
//                @{kCellName: @"时间", kCellDefaultText: _expend.CreateDt},
////                @{kCellName: @"余额", kCellDefaultText: @"12222"},
//                @{kCellName: @"备注", kCellDefaultText: _expend.Remark}
//                ];
}

- (void)layoutUI {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"收支详情";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrTmp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_PayDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *tmpDic = [_arrTmp objectAtIndex:indexPath.row];
    cell.textLabel.text = tmpDic[kCellName];
    cell.detailTextLabel.text = tmpDic[kCellDefaultText];
    return cell;
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

@end
