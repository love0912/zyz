//
//  VC_Producer.m
//  自由找
//
//  Created by guojie on 16/8/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Producer.h"
#import "Cell_Producer.h"
#import "ProductService.h"

@interface VC_Producer ()
{
    ProductService *_productService;
    NSString *_orderID;
    NSInteger _page;
    NSMutableArray *_arr_producer;
}
@end

@implementation VC_Producer

- (void)initData {
    _productService = [ProductService sharedService];
    _arr_producer = [NSMutableArray arrayWithCapacity:0];
    _orderID = [self.parameters objectForKey:kPageDataDic];
    
}

- (void)layoutUI {
    [self downRefresh];
    [self upRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"制作人员列表";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}
//下拉刷新
- (void)downRefresh
{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self resetNoMoreStatusWithTableView:_tableView];
        _page = 1;
        [self getProducer];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self getProducer];
    }];
}

- (void)getProducer {
    [_productService getProducerByID:_orderID result:^(NSInteger code, NSArray<ProducerDomain *> *producerInfo) {
        [self endingMJRefreshWithTableView:_tableView];
        if (code != 1) {
            return;
        }
        if (_page == 1) {
            [_arr_producer removeAllObjects];
        }
        [_arr_producer addObjectsFromArray:producerInfo];
        if (producerInfo.count == 0) {
            [self endingNoMoreWithTableView:_tableView];
        }
        [_tableView reloadData];
    }];
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 10;
    return _arr_producer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_Producer";
    Cell_Producer *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    ProducerDomain *producer = [_arr_producer objectAtIndex:indexPath.row];
    cell.producer = producer;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProducerDomain *producer = [_arr_producer objectAtIndex:indexPath.row];
    [PageJumpHelper pushToVCID:@"VC_OthersInformation" storyboard:Storyboard_Main parameters:@{kPageDataDic: producer} parent:self];
//    [PageJumpHelper pushToVCID:@"VC_OthersInformation" storyboard:Storyboard_Main  parent:self];
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
