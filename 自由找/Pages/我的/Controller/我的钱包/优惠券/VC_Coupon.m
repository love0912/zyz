//
//  VC_Coupon.m
//  自由找
//
//  Created by guojie on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Coupon.h"
#import "Cell_Coupon.h"
#import "PayService.h"

#define CellScale 0.3253

@interface VC_Coupon ()
{
    CGFloat _tableCellHeight;
    PayService *_payService;
    NSMutableArray *_arr_coupon;
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UILabel *lb_noneCoupon1;
@property (weak, nonatomic) IBOutlet UILabel *lb_noneCoupon2;

@property (weak, nonatomic) IBOutlet UIImageView *iv_noneCoupon;
@end

@implementation VC_Coupon

- (void)initData {
    _tableCellHeight = ScreenSize.width * CellScale;
    _payService = [PayService sharedService];
    _page=1;
    _arr_coupon = [NSMutableArray arrayWithCapacity:0];
}

- (void)layoutUI {
    [self downRefresh];
    [self upRefresh];
}

//下拉刷新
- (void)downRefresh
{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self resetNoMoreStatusWithTableView:_tableView];
        _page = 1;
        [self getCoupon];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self getCoupon];
    }];
}

- (void)getCoupon {
    [_payService getCouponsPage:_page reult:^(NSInteger code, NSArray<CouponDomain *> *coupon) {
        if(code == 1) {
            [self endingMJRefreshWithTableView:_tableView];
            if (_page == 1) {
                [_arr_coupon removeAllObjects];
            }
            [_arr_coupon addObjectsFromArray:coupon];
            if (coupon.count == 0) {
                [self endingNoMoreWithTableView:_tableView];
            }
            [_tableView reloadData];
            if (_arr_coupon.count==0) {
                _tableView.hidden=YES;
                _iv_noneCoupon.hidden=NO;
                _lb_noneCoupon1.hidden=NO;
                _lb_noneCoupon2.hidden=NO;
            }else{
                _tableView.hidden=NO;
                _iv_noneCoupon.hidden=YES;
                _lb_noneCoupon1.hidden=YES;
                _lb_noneCoupon2.hidden=YES;
                
            }
        }
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"优惠券";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
//    [self getCoupon];
    
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 10;
    return _arr_coupon.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_Coupon";
    Cell_Coupon *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    CouponDomain *coupon = [_arr_coupon objectAtIndex:indexPath.row];
    cell.coupon = coupon;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _tableCellHeight;
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

@end
