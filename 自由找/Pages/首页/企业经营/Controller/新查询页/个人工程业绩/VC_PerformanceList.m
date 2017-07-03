//
//  VC_PerformanceList.m
//  zyz
//
//  Created by 郭界 on 17/1/6.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "VC_PerformanceList.h"
#import "PerformanceDoamin.h"
#import "NewQueryService.h"

@interface VC_PerformanceList ()
{
    NSInteger _page;
    NSInteger _queryType;
    NSString *_name;
    NSString *_companyOId;
    
    NSMutableArray *_arr_performance;
    
    NewQueryService *_queryService;
}
@end

@implementation VC_PerformanceList

- (void)initData {
    _page = [[self.parameters objectForKey:kPage] integerValue];
    _queryType = [[self.parameters objectForKey:@"queryType"] integerValue];
    _name = [self.parameters objectForKey:@"Name"];
    _companyOId = [self.parameters objectForKey:@"CompanyOId"];
    _arr_performance = [NSMutableArray arrayWithArray:[self.parameters objectForKey:kPageDataDic]];
    
    _queryService = [NewQueryService sharedService];
}

- (void)layoutUI {
    [self upRefresh];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self getPerformance];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    self.jx_title = @"工程业绩";
    [self initData];
    [self layoutUI];
    
}

- (void)getPerformance {
    [_queryService getProjectPerformanceWithSearchType:_queryType name:_name companyOId:_companyOId page:_page result:^(NSArray<PerformanceDoamin *> *performList, NSInteger code) {
        if (code != 1) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
        [self.tableView.mj_footer endRefreshing];
        [_arr_performance addObjectsFromArray:performList];
        if (performList.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [_tableView reloadData];
    }];
}


#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_performance.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_Normal";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    PerformanceDoamin *performance = _arr_performance[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row+1, performance.ProjectName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PerformanceDoamin *performance = _arr_performance[indexPath.row];
    [PageJumpHelper pushToVCID:@"VC_PerformanceDetail" storyboard:Storyboard_Main parameters:@{kPageDataDic: performance, kPageType: @(_queryType)} parent:self];
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
