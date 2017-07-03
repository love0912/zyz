//
//  VC_EvaluateList.m
//  自由找
//
//  Created by guojie on 16/8/3.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_EvaluateList.h"
#import "Cell_EvaluateList.h"
#import "ProductService.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface VC_EvaluateList ()
{
    ProductService *_productService;
    NSInteger _page;
    NSString *_productID;
    NSString *_count;
    NSMutableArray *_arr_evaluate;
    NSInteger _productType;
}

@end

@implementation VC_EvaluateList

- (void)initData {
    _productService = [ProductService sharedService];
    _productID = [[self.parameters objectForKey:kPageDataDic] objectForKey:@"ProjectID"];
    _count = [[self.parameters objectForKey:kPageDataDic] objectForKey:@"Count"];
    _productType = [[self.parameters objectForKey:kPageType] integerValue];
    if (_count != nil) {
        self.jx_title = [NSString stringWithFormat:@"评价（%@）", _count];
    }
    _arr_evaluate = [NSMutableArray arrayWithCapacity:0];
    

}

- (void)layoutUI {
    UIView *v_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 10)];
    v_header.backgroundColor = [CommonUtil zyzBackgroundColor];
    self.tableView.tableHeaderView = v_header;
    [self hideTableViewFooter:_tableView];
    
    [self downRefresh];
    [self upRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"评价";
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
        [self getEvaluate];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self getEvaluate];
    }];
}

- (void)getEvaluate {
    if (_productType == 3) {
        [_productService getProductEvaluateWithProductID:_productID productType:3 page:_page result:^(NSInteger code, NSArray<EvaluateDomain *> *evaluateInfo) {
            [self endingMJRefreshWithTableView:_tableView];
            if (code == 1) {
                if (_page == 1) {
                    [_arr_evaluate removeAllObjects];
                }
                [_arr_evaluate addObjectsFromArray:evaluateInfo];
            }
            if (evaluateInfo.count == 0) {
                [self endingNoMoreWithTableView:_tableView];
            }
            [_tableView reloadData];
        }];
    } else {
        [_productService getProductEvaluateWithProductID:_productID page:_page result:^(NSInteger code, NSArray<EvaluateDomain *> *evaluateInfo) {
            [self endingMJRefreshWithTableView:_tableView];
            if (code == 1) {
                if (_page == 1) {
                    [_arr_evaluate removeAllObjects];
                }
                [_arr_evaluate addObjectsFromArray:evaluateInfo];
            }
            if (evaluateInfo.count == 0) {
                [self endingNoMoreWithTableView:_tableView];
            }
            [_tableView reloadData];
        }];
    }
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 10;
    return _arr_evaluate.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_EvaluateList";
    Cell_EvaluateList *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    EvaluateDomain *evaluate = [_arr_evaluate objectAtIndex:indexPath.row];
    cell.evaluate = evaluate;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"Cell_EvaluateList" cacheByIndexPath:indexPath configuration:^(Cell_EvaluateList *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    if (height < 131) {
        height = 131;
    }
    return height;
}

- (void)configureCell:(Cell_EvaluateList *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    EvaluateDomain *evaluate = [_arr_evaluate objectAtIndex:indexPath.row];
    cell.evaluate = evaluate;
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
