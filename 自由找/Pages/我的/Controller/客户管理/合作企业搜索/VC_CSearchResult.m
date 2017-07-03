//
//  VC_CSearchResult.m
//  自由找
//
//  Created by guojie on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_CSearchResult.h"
#import "CustomerService.h"
#import "Cell_CSearchResult.h"

@interface VC_CSearchResult ()
{
    NSMutableDictionary *_paramDic;
    NSInteger _page;
    CustomerService *_customerService;
    NSMutableArray *_arr_customer;
}
@end

@implementation VC_CSearchResult

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"查询结果";
    [self zyzOringeNavigationBar];
    
    _paramDic = [NSMutableDictionary dictionaryWithDictionary:[self.parameters objectForKey:kPageDataDic]];
    _page = 1;
    
    _customerService = [CustomerService sharedService];
    _arr_customer = [NSMutableArray arrayWithArray:[self.parameters objectForKey:@"Data"]];
    
    NSInteger count = [[self.parameters objectForKey:@"Count"] integerValue];
    _lb_total.text = [NSString stringWithFormat:@"为您搜索到%ld家企业", count];
    
//    [self getCustomer];
    [self upRefresh];
    
    [self hideTableViewFooter:self.tableView];
    
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self getCustomer];
    }];
}

- (void)getCustomer {
    [_paramDic setObject:@(_page) forKey:kPage];
    [_customerService queryCustomerWithParameters:_paramDic result:^(NSArray<CustomerDomain *> *arr_custom, NSInteger count, NSInteger code) {
        [self endingMJRefreshWithTableView:_tableView];
        if (code == 1) {
            if (_page == 1) {
                [_arr_customer removeAllObjects];
            }
            [_arr_customer addObjectsFromArray:arr_custom];
            [_tableView reloadData];
            if (arr_custom.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            _lb_total.text = [NSString stringWithFormat:@"为您搜索到%ld家企业", count];
        }
        if (_page == 1 && arr_custom.count == 0) {
            [ProgressHUD showInfo:@"未查询到结果" withSucc:NO withDismissDelay:2];
            [self goBack];
        }
    }];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_customer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_CSearchResult";
    Cell_CSearchResult *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.customer = [_arr_customer objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomerDomain *customer = [_arr_customer objectAtIndex:indexPath.row];
    [PageJumpHelper pushToVCID:@"VC_CustomerDetail" storyboard:Storyboard_Mine parameters:@{kPageDataDic: customer.CustomerId} parent:self];
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
