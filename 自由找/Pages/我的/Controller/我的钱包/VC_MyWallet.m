//
//  VC_MyWallet.m
//  自由找
//
//  Created by xiaoqi on 16/8/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_MyWallet.h"
#import "Cell_MyWallet.h"
#import "PayService.h"


//优惠券
#define CellCoupon @"Coupon"
//消费明细
#define CellStatement @"Statement"
//账户充值
#define CellTopup @"Topup"
//余额提现
#define CellWithdrawal @"Withdrawal"
//修改支付密码
#define CellUpdatePwd @"UpdatePwd"
#define kHederDefaultHeight 225
static NSString *CellID1 = @"Cell_MyWallet";
static NSString *CellID2 = @"MyWallet";
@interface VC_MyWallet (){
    NSArray *_arr_menu;
    CGFloat _headerHeight;
    CGFloat _headerCellHeight;
    CGFloat _accountTop;
     CGFloat _accountToMoney;

    //header 使用到的view
    UIButton *_btn_account;
    UILabel *_lb_money;
    
    WalletDomain *_wallet;
    PayService *_payService;

}

@end

@implementation VC_MyWallet

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"自由找钱包";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    
}
-(void)initData{
    if (IS_IPHONE_4_OR_LESS) {
        _headerHeight = 140;
        _accountTop = 18;
        _accountToMoney=14;
    } else if (IS_IPHONE_5) {
        _accountTop = 24;
        _headerHeight = 150;
        _accountToMoney=20;
    } else {
        _accountTop = 35;
        _accountToMoney=30;
        _headerHeight = kHederDefaultHeight;
    }
    
    _payService = [PayService sharedService];
    _wallet = [self.parameters objectForKey:kPageDataDic];
    
//    _wallet = [[WalletDomain alloc] init];
//    _wallet.Balance = @"10000";
//    _wallet.FrozenBalance = @"5000";
//    _wallet.FrozenCoupon = @"0";
//    _wallet.availableBalance = @"5000";
    
    [self layoutTableCell];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWalletInfo:) name:Notification_Wallet_RefreshWalletInfo object:nil];
    
}

- (void)layoutTableCell {
    if ([_wallet.FrozenCoupon isEqualToString:@"0"]) {
        _arr_menu = @[
                      @[@{}],
                      @[
                          @{kCellImage: @"wallet_xf0", kCellName: @"优惠券", kCellKey: CellCoupon, kCellDefaultText: @""},
                          @{kCellImage: @"wallet_xf1", kCellName: @"消费明细", kCellKey: CellStatement, kCellDefaultText: @""},
                          @{kCellImage: @"wallet_xf2", kCellName: @"账户充值", kCellKey: CellTopup, kCellDefaultText: @""}
                          ],
                      @[
                          @{kCellImage: @"wallet_xf3", kCellName: @"余额提现", kCellKey: CellWithdrawal, kCellDefaultText: @""},
                          @{kCellImage: @"wallet_xf4", kCellName: @"修改钱包密码", kCellKey: CellUpdatePwd}
                          ]
                      ];
    } else {
        _arr_menu = @[
                      @[@{}, @{}],
                      @[
                          @{kCellImage: @"wallet_xf0", kCellName: @"优惠券", kCellKey: CellCoupon, kCellDefaultText: @""},
                          @{kCellImage: @"wallet_xf1", kCellName: @"消费明细", kCellKey: CellStatement, kCellDefaultText: @""},
                          @{kCellImage: @"wallet_xf2", kCellName: @"账户充值", kCellKey: CellTopup, kCellDefaultText: @""}
                          ],
                      @[
                          @{kCellImage: @"wallet_xf3", kCellName: @"余额提现", kCellKey: CellWithdrawal, kCellDefaultText: @""},
                          @{kCellImage: @"wallet_xf4", kCellName: @"修改钱包密码", kCellKey: CellUpdatePwd}
                          ]
                      ];
    }
    [_tableView reloadData];
}

- (void)refreshWalletInfo:(NSNotification *)notification {
    WalletDomain *wallet = notification.object;
    _wallet = wallet;
    [self layoutTableCell];
    _lb_money.text=_wallet.Balance;
}

-(void)layoutUI{
    
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 11)];
    _tableView.sectionHeaderHeight=0;
    _tableView.sectionFooterHeight=10;
    //去除navigabar底部的横线
    NSArray *list=self.jx_navigationBar.subviews;
    for (id obj in list) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView=(UIImageView *)obj;
            imageView.hidden=YES;
        }
    }
//    [self layoutHeaderView];
}
- (void)layoutHeaderView {
    _tableView.sectionFooterHeight=10;
    
    self.mineHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, _headerHeight)];
    self.mineHeaderView.userInteractionEnabled = YES;
    self.mineHeaderView.backgroundColor = [CommonUtil zyzOrangeColor];
    [self.tableView addSubview:self.mineHeaderView];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.mineHeaderView.bounds];
    self.tableView.tableHeaderView = backView;
    backView.hidden = YES;
    
    _btn_account = [[UIButton alloc] init];
    _btn_account.translatesAutoresizingMaskIntoConstraints = NO;
    _btn_account.titleLabel.font=[UIFont systemFontOfSize:11];
    [_btn_account setImage:[UIImage imageNamed:@"wallet_bi"] forState:UIControlStateNormal];
    [_btn_account setTitle:@"账户余额(元)" forState:UIControlStateNormal];
    [_btn_account setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_mineHeaderView addSubview:_btn_account];
    [_btn_account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_mineHeaderView.mas_centerX);
        make.top.equalTo(_mineHeaderView.mas_top).with.offset(_accountTop);
    }];
    _lb_money = [[UILabel alloc] init];
    _lb_money.font = [UIFont systemFontOfSize:66];
    _lb_money.textColor = [UIColor whiteColor];
    _lb_money.translatesAutoresizingMaskIntoConstraints = NO;
    _lb_money.textAlignment=NSTextAlignmentCenter;
    [_mineHeaderView addSubview:_lb_money];
    [_lb_money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_btn_account.mas_bottom).with.offset(_accountToMoney);
        make.centerX.equalTo(_mineHeaderView.mas_centerX).with.offset(0);
    }];
    _lb_money.text=_wallet.Balance;


}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arr_menu.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_arr_menu objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            Cell_MyWallet *cell = [tableView dequeueReusableCellWithIdentifier:CellID1];
            [cell configureWithFreeze:_wallet.FrozenBalance avaliable:_wallet.availableBalance];
            return cell;
        } else {
            static NSString *CellID3 = @"Cell_ID3";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID3];
            cell.textLabel.text = [NSString stringWithFormat:@"已冻结优惠券面值%@元", _wallet.FrozenCoupon];
            return cell;
        }
        
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID2];
        NSDictionary *paramDic = [[_arr_menu objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:paramDic[kCellImage]];
        cell.textLabel.text = paramDic[kCellName];
        return cell;
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //获取当前活动的tableview
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        _mineHeaderView.frame = CGRectMake(offsetY/2, offsetY, ScreenSize.width - offsetY, _headerHeight - offsetY);  // 修改头部的frame值就行了
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row == 0) {
            return 84;
        }
        return 40;
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [[_arr_menu objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (tmpDic.count > 0) {
        NSString *key = tmpDic[kCellKey];
        if ([CellStatement isEqualToString:key]) {
            [PageJumpHelper pushToVCID:@"VC_PayInOut" storyboard:Storyboard_Mine parent:self];
        } else if ([CellTopup isEqualToString:key]) {
            [PageJumpHelper pushToVCID:@"VC_Recharge" storyboard:Storyboard_Mine parent:self];
        } else if ([CellCoupon isEqualToString:key]) {
            [PageJumpHelper pushToVCID:@"VC_Coupon" storyboard:Storyboard_Mine parent:self];
        } else if ([CellUpdatePwd isEqualToString:key]) {
            [PageJumpHelper pushToVCID:@"VC_ModifyPayPass" storyboard:Storyboard_Mine parent:self];
        }else if([CellWithdrawal isEqualToString:key]){
//            [PageJumpHelper pushToVCID:@"VC_Withdrawal" storyboard:Storyboard_Mine parameters:@{kPageDataDic: _wallet.availableBalance} parent:self];
            
            [PageJumpHelper pushToVCID:@"VC_Withdrawal_Verify" storyboard:Storyboard_Mine parameters:@{kPageDataDic:_wallet} parent:self];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
