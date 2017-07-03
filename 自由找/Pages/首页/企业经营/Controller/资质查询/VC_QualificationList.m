//
//  VC_QualificationList.m
//  自由找
//
//  Created by xiaoqi on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_QualificationList.h"
#import "QualificaDomian.h"

#import "Cell_QualificationList.h"
#import "BidService.h"
#import "NewQueryService.h"
#import "VC_NewQuality.h"

static NSString *CellID = @"Cell_QualificationList";
@interface VC_QualificationList (){
   NSMutableArray *_arr_data;
    QualificaService *_qualificaService;
    QualificaListDomian *_qualificaDomian;
    BidService *_bidService;
    int _page;
    /**
     *  0 -- 从资质查询里进入， 1 -- 从资质需求详情页进入
     */
    NSInteger _type;
    NewQueryService *_queryService;
}
@end

@implementation VC_QualificationList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"资质查询";
    [self zyzOringeNavigationBar];
    _queryService = [NewQueryService sharedService];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)loadData{
    _type = [[self.parameters objectForKey:kPageType] integerValue];
    if (_type == 1) {
        self.jx_title = @"符合我的企业";
    }
    
    _page=1;
    _arr_data=[NSMutableArray array];
//    [_tableView.mj_footer resetNoMoreData];
    _tableView.rowHeight=68;
     _qualificaService=[QualificaService sharedService];
    _bidService = [BidService sharedService];
       [self loadListData];
    [self hideTableViewFooter:_tableView];
    [self upRefresh];
    [self downRefresh];
}
//下拉刷新
- (void)downRefresh
{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self loadListData];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self loadListData];
    }];
     [self.tableView.mj_footer beginRefreshing];
}

- (void)getCcompanyList {
    NSDictionary *paramDic = [self.parameters objectForKey:kPageDataDic];
    [_queryService getCompanyByName:paramDic[@"CompanyName"] regionKey:paramDic[kBidRegionCode] regionType:[paramDic[kBidRegionType] integerValue] aptitudeFilterOfDic:paramDic[kQualityData] performanceFilterOfDic:paramDic[@"PerformanceFilters"] memberFilterOfDic:paramDic[@"MemberFilters"] creditsOfDic:paramDic[KCredit] pageOfNumber:_page result:^(QualificaDomian *responseBid, NSInteger code) {
        [self endingMJRefreshWithTableView:_tableView];
        if (code != 1) {
            return ;
        }
        if (_page==1) {
            [_arr_data removeAllObjects];
        }
        if (responseBid.Items.count == 0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [_arr_data addObjectsFromArray:responseBid.Items];
        [self.tableView reloadData];

    }];
}

-(void)loadListData{
    if (_type == 0) {
        [self getCcompanyList];
//        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[self.parameters objectForKey:kPageDataDic]];
//        [dic setObject:@(_page) forKey:kPage];
//        [_qualificaService queryQualificaListWithParameters:dic result:^(QualificaDomian *responseBid, NSInteger code) {
//            [self endingMJRefreshWithTableView:_tableView];
//            if (code != 1) {
//                return ;
//            }
//            if (_page==1) {
//                [_arr_data removeAllObjects];
//            }
//            if (responseBid.Items.count == 0) {
//                [_tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//            [_arr_data addObjectsFromArray:responseBid.Items];
//            [self.tableView reloadData];
//
//        }];
    } else {
        NSString *projectID = [self.parameters objectForKey:kPageDataDic];
        [_bidService viewBidCompanyWithParameters:@{kBidProjectID: projectID, kPage: @(_page)} result:^(QualificaDomian *qualitifics, NSInteger code) {
            [self endingMJRefreshWithTableView:_tableView];
            if (code != 1) {
                return ;
            }
            
            if (_page==1) {
                [_arr_data removeAllObjects];
            }
            if (qualitifics.Items.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [_arr_data addObjectsFromArray:qualitifics.Items];
            [self.tableView reloadData];
        }];
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _qualificaDomian=[_arr_data objectAtIndex:indexPath.row];
    Cell_QualificationList *cell_list = [tableView dequeueReusableCellWithIdentifier:CellID];
       cell_list.bidList=_qualificaDomian;
    
    return cell_list;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [CountUtil countSearchViewDetail];
    
    _qualificaDomian=[_arr_data objectAtIndex:indexPath.row];
    [_qualificaService countViewsWithType:0 recordID:@""];
    [PageJumpHelper pushToVCID:@"VC_CompanyDetail" storyboard:Storyboard_Mine parameters:@{kPageDataDic: _qualificaDomian.Url,kCompanyID:_qualificaDomian.CompanyOId,@"Type":@0, kCompanyName: _qualificaDomian.CompanyName} parent:self];
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
