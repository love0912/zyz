//
//  VC_AddendumContent.m
//  自由找
//
//  Created by xiaoqi on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_AddendumContent.h"
static NSString *cellID=@"Cell_Addendum";
#import "ProjectOrderService.h"
#import "SupplementDomain.h"
@interface VC_AddendumContent (){
    NSInteger _page;
    ProjectOrderService *_projectOrderService;
    NSMutableArray *_arr_endum;
}


@end

@implementation VC_AddendumContent
-(void)getEndum{
    [_projectOrderService getProjectSupplementByProjectID:self.parameters[kBidProjectID] page:_page result:^(NSInteger code, NSArray<SupplementDomain *> *supplements) {
        [self endingMJRefreshWithTableView:_tableView];
        if (code == 1) {
            if (_page == 1) {
                [_arr_endum removeAllObjects];
            }
            [_arr_endum addObjectsFromArray:supplements];
            if (supplements.count == 0) {
                [self endingNoMoreWithTableView:_tableView];
            }
            [_tableView reloadData];
        }
    }];
}
//下拉刷新
- (void)downRefresh
{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self resetNoMoreStatusWithTableView:_tableView];
        _page = 1;
        [self getEndum];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self getEndum];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"补遗内容";
    [self zyzOringeNavigationBar];
    [self loadData];
    [self layoutUI];
}
-(void)loadData{
    _projectOrderService=[ProjectOrderService sharedService];
    _arr_endum=[NSMutableArray arrayWithCapacity:0];
    _page=1;
}
-(void)layoutUI{
    [self hideTableViewFooter:_tableView];
    [self downRefresh];
    [self upRefresh];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 4;
    return _arr_endum.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    SupplementDomain *endumDomian = [_arr_endum objectAtIndex:indexPath.row];
    cell.textLabel.text = endumDomian.Title;
    cell.detailTextLabel.text = endumDomian.CreateDt;
//    cell.textLabel.text = @"123";
//    cell.detailTextLabel.text = @"2016-08-31";
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [PageJumpHelper pushToVCID:@"VC_AddendumNotice" storyboard:Storyboard_Mine  parent:self];
    [PageJumpHelper pushToVCID:@"VC_AddendumNotice" storyboard:Storyboard_Mine parameters:@{@"endumcontent":[_arr_endum objectAtIndex:indexPath.row]}  parent:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
