//
//  VC_PayInOut.m
//  自由找
//
//  Created by guojie on 16/8/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_PayInOut.h"
#import "Cell_PayInOut.h"
#import "JDropMenu.h"
#import "PayService.h"

@interface VC_PayInOut ()
{
    UIView *_v_filerBack;
    JDropMenu *_jDropMenu;
    KVImageDomain *_selectKVImage;
    PayService *_payService;
    NSString *_type;
    NSInteger _page;
    NSMutableArray *_arr_payExpand;
}
@end

@implementation VC_PayInOut

- (void)initData {
    _type = @"0";
    _page=1;
    _payService = [PayService sharedService];
    _arr_payExpand = [NSMutableArray arrayWithCapacity:0];
}

- (void)layoutUI {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed)];
    [self setNavigationBarRightItem:rightItem];
    [self layoutFilterView];
    
    [self hideTableViewFooter:self.tableView];
    [self downRefresh];
    [self upRefresh];
}

- (void)rightItemPressed {
    if (!_jDropMenu.isShowing) {
        [self showFilterView];
    } else {
        [self hideFilterView];
    }
}

- (void)layoutFilterView {
    NSMutableArray *filterArray = [NSMutableArray arrayWithCapacity:3];
    NSArray *tmpArray = @[
                          @{kCommonKey: @"0", kCommonValue: @"全部", @"ImageName": @"filter_all", @"SelectImageName": @"filter_all_sel"},
                          @{kCommonKey: @"1", kCommonValue: @"收入", @"ImageName": @"filter_in", @"SelectImageName": @"filter_in_sel"},
                          @{kCommonKey: @"2", kCommonValue: @"支出", @"ImageName": @"filter_out", @"SelectImageName": @"filter_out_sel"},
                          ];
    for (NSDictionary *tmpDic in tmpArray) {
        KVImageDomain *kvImage = [KVImageDomain domainWithObject:tmpDic];
        [filterArray addObject:kvImage];
    }
    _selectKVImage = filterArray.firstObject;
    _jDropMenu = [[JDropMenu alloc] initWithdataSource:filterArray fromTop:YES margin:64];
}

- (void)showFilterView {
    [_jDropMenu showInView:self.view selectData:_selectKVImage dropData:^(KVImageDomain *dropData) {
        _selectKVImage = dropData;
        UIBarButtonItem *rightItem = self.jx_navigationBar.items.firstObject.rightBarButtonItems.lastObject;
        rightItem.title = _selectKVImage.Value;
        _type = _selectKVImage.Key;
        [_tableView.mj_header beginRefreshing];
    }];
}

- (void)hideFilterView {
    [_jDropMenu dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"收支明细";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    [self getPayInOut];
}

//下拉刷新
- (void)downRefresh
{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self resetNoMoreStatusWithTableView:_tableView];
        _page = 1;
        [self getPayInOut];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self getPayInOut];
    }];
}

- (void)getPayInOut {
    [_payService getPayExpendByType:_type page:_page result:^(NSInteger code, NSArray<ExpendDomain *> *expend) {
        [self endingMJRefreshWithTableView:_tableView];
        
        if (code != 1) {
            return ;
        }
        if (_page == 1) {
            [_arr_payExpand removeAllObjects];
        }
        [_arr_payExpand addObjectsFromArray:expend];
        if (expend.count == 0) {
            [self endingNoMoreWithTableView:_tableView];
        }
        [_tableView reloadData];
    }];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 10;
    return _arr_payExpand.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_PayInOut";
    Cell_PayInOut *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    cell.lb_name.text = @"购买项目";
//    cell.lb_date.text = @"2016-12-12";
    
    ExpendDomain *expand = [_arr_payExpand objectAtIndex:indexPath.row];
    cell.expand = expand;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [PageJumpHelper pushToVCID:@"VC_PayInOutDetail" storyboard:Storyboard_Mine parent:self];
    
    ExpendDomain *expand = [_arr_payExpand objectAtIndex:indexPath.row];
    [PageJumpHelper pushToVCID:@"VC_PayInOutDetail" storyboard:Storyboard_Mine parameters:@{kPageDataDic: expand} parent:self];
    
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
