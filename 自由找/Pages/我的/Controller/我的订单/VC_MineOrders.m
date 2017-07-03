//
//  VC_MineOrders.m
//  自由找
//
//  Created by xiaoqi on 16/8/10.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_MineOrders.h"
#import "Cell_MineOrders.h"
#import "ProductService.h"
#import "SwipeBack.h"
#import "LetterService.h"

static NSString *cellID=@"Cell_MineOrders";
@interface VC_MineOrders ()
{
    ProductService *_productService;
    NSMutableArray *_arr_orders;
    NSInteger _page;
    
    LetterService *_letterService;
}
@end

@implementation VC_MineOrders

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"我的订单";
    [self zyzOringeNavigationBar];
    [self loadData];
    [self layoutUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrders) name:Notification_OurOrder_Refresh object:nil];
}

- (void)refreshOrders {
    [self.tableView.mj_header beginRefreshing];
}

-(void)loadData{
    _productService = [ProductService sharedService];
    _letterService = [LetterService sharedService];
    _arr_orders = [NSMutableArray arrayWithCapacity:0];
    _lb_toast.text=@"暂无订单记录\n您的购买记录会出现在这里";
    NSRange range = [_lb_toast.text rangeOfString:@"暂无订单记录"];
    [CommonUtil  setTextColor:_lb_toast FontNumber:[UIFont systemFontOfSize:14.0] AndRange:range AndColor:[UIColor colorWithHex:@"333333"]];

}
-(void)layoutUI{
    [self hideTableViewFooter:_tableView];
    
    [self downRefresh];
    [self upRefresh];
}
-(void)backPressed{
    if ([self.parameters[kPageType]integerValue]==1) {//购买－支付成功
        NSArray *tmpArray = self.navigationController.viewControllers;
        UIViewController *vc = [tmpArray objectAtIndex:tmpArray.count - 6];
        [self.navigationController popToViewController:vc animated:YES];
    } else if ([self.parameters[kPageType]integerValue]==3) {
        NSArray *tmpArray = self.navigationController.viewControllers;
        UIViewController *vc = [tmpArray objectAtIndex:tmpArray.count - 3];
        [self.navigationController popToViewController:vc animated:YES];
    } else if ([self.parameters[kPageType] integerValue] == 4) {
        NSArray *tmpArray = self.navigationController.viewControllers;
        UIViewController *vc = [tmpArray objectAtIndex:tmpArray.count - 5];
        [self.navigationController popToViewController:vc animated:YES];
    }else{
        [self goBack];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    if ([self.parameters[kPageType]integerValue]==3 || [self.parameters[kPageType] integerValue]==4) {
        
    }
    self.navigationController.swipeBackEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.swipeBackEnabled = YES;
}

//下拉刷新
- (void)downRefresh
{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self resetNoMoreStatusWithTableView:_tableView];
        _page = 1;
        [self getMySelfOrders];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self getMySelfOrders];
    }];
}

- (void)getMySelfOrders {
    [_productService getMySelfOrderWithPage:_page result:^(NSInteger code, NSArray<OrderInfoDomain *> *mySelfs) {
        [self endingMJRefreshWithTableView:_tableView];
        if (code == 1) {
            if (_page == 1) {
                [_arr_orders removeAllObjects];
            }
            [_arr_orders addObjectsFromArray:mySelfs];
            if (_arr_orders.count==0) {
                _tableView.hidden=YES;
                _iv_toast.hidden=NO;
                _lb_toast.hidden=NO;
                _btn_toast_technology.hidden=NO;
                _btn_toast_budget.hidden=NO;
                _btn_toast_letter.hidden = NO;
            }else{
                _tableView.hidden=NO;
                _iv_toast.hidden=YES;
                _lb_toast.hidden=YES;
                _btn_toast_technology.hidden=YES;
                _btn_toast_budget.hidden=YES;
                _btn_toast_letter.hidden = YES;
            }
            
            if (mySelfs.count == 0) {
                [self endingNoMoreWithTableView:_tableView];
            }
            [_tableView reloadData];
        }
    }];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 4;
    return _arr_orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell_MineOrders *cell_mineOrders = [tableView dequeueReusableCellWithIdentifier:cellID];
    OrderInfoDomain *order = [_arr_orders objectAtIndex:indexPath.row];
    cell_mineOrders.order = order;
    return cell_mineOrders;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderInfoDomain *order = [_arr_orders objectAtIndex:indexPath.row];
    if ([order.ProductType isEqualToString:@"3"]) {
        [self getLetterOrderDetailByOrderID:order.SerialNo];
    } else {
        [self getOrderDetailsByOrderID:order.SerialNo];
    }
    
//    [PageJumpHelper pushToVCID:@"VC_OrderDetail" storyboard:Storyboard_Main parent:self];
}

- (void)getLetterOrderDetailByOrderID:(NSString *)orderID {
    [_letterService getLetterOrderDetailByOrderNo:orderID result:^(NSInteger code, LetterOrderDetailDomain *orderDetail) {
        if (code != 1) {
            return;
        }
        
        if ([orderDetail.Status isEqualToString:@"1"]) {
            //待付款订单
            [PageJumpHelper pushToVCID:@"VC_NewBidLetterBuy" storyboard:Storyboard_Main parameters:@{kPageType:@1, kPageDataDic:orderDetail, @"StatusType":@1 } parent:self];
        } else {
            [PageJumpHelper pushToVCID:@"VC_LetterOrderDetail" storyboard:Storyboard_Main parameters:@{kPageDataDic: orderDetail} parent:self];
        }
    }];
}


- (void)getOrderDetailsByOrderID:(NSString *)orderID {
    [_productService getOrderDetailByID:orderID result:^(NSInteger code, OrderInfoDomain *orderInfo) {
        if (code == 1) {
            [PageJumpHelper pushToVCID:@"VC_OrderDetail" storyboard:Storyboard_Main parameters:@{kPageDataDic: orderInfo,kPageType:@(3)} parent:self];
        }
    }];
}
- (IBAction)btn_toastTechnology_pressed:(id)sender{
    [PageJumpHelper pushToVCID:@"VC_Technology" storyboard:Storyboard_Main parameters:@{@"pushType":@"3"} parent:self];

}
- (IBAction)btn_toastBudge_pressed:(id)sender{
    [PageJumpHelper pushToVCID:@"VC_Budget" storyboard:Storyboard_Main parameters:@{@"pushType":@"3"} parent:self];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)btn_toastLetter_pressed:(id)sender {
    [PageJumpHelper pushToVCID:@"VC_LetterMain" storyboard:Storyboard_Main parent:self];
}
@end
