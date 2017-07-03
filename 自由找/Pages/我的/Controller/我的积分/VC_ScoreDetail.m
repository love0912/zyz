//
//  VC_ScoreDetail.m
//  自由找
//
//  Created by guojie on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_ScoreDetail.h"
#import "MineService.h"
#import "Cell_ScoreDetail.h"

@interface VC_ScoreDetail ()
{
    /**
     *  1 -- 获取积分， 2 -- 消费积分
     */
    NSInteger _type;
    
    NSInteger _page;
    MineService *_mineService;
    NSMutableArray *_arr_score;
}
@end

@implementation VC_ScoreDetail

- (void)initData {
    _page = 1;
    _type = [[self.parameters objectForKey:kPageType] integerValue];
    _mineService = [MineService sharedService];
    _arr_score = [NSMutableArray array];
}

- (void)layoutUI {
    if (_type == 1) {
        self.jx_title = @"积分获取情况";
        _lb_tips.text = @"积分获取（个）";
    } else {
        self.jx_title = @"积分消费情况";
        _lb_tips.text = @"积分消费（个）";
    }
//    [self downRefresh];
    [self upRefresh];
    [self hideTableViewFooter:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    [self queryScore];
}
////下拉刷新
//- (void)downRefresh
//{
//    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _page = 1;
//    }];
//    // 马上进入刷新状态
//    [self.tableView.mj_header beginRefreshing];
//}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self queryScore];
    }];
}

- (void)queryScore {
    [_mineService queryScoreWithType:_type page:_page result:^(NSString *total, NSArray<ScoreDomain *> *arr_score, NSInteger code) {
        if (code == 1) {
            _lb_score.text = total;
            [self endingMJRefreshWithTableView:self.tableView];
            if (_page == 1) {
                [_arr_score removeAllObjects];
            }
            [_arr_score addObjectsFromArray:arr_score];
            if (arr_score.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [_tableView reloadData];
        }
    }];
    
}

#pragma mark - tableview 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_score.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_ScoreDetail";
    Cell_ScoreDetail *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.type = _type;
    cell.score = [_arr_score objectAtIndex:indexPath.row];
    return cell;
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
