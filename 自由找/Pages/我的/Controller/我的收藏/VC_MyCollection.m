//
//  VC_MyCollection.m
//  自由找
//
//  Created by xiaoqi on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_MyCollection.h"
#import "Cell_MyCollection.h"
#import "ProjectOrderService.h"
#import "ProjectOrderDomain.h"
#import "VC_Tech_Order.h"
#import "Cell_Letter_Perform.h"

static NSString *cellID=@"Cell_MyCollection";
@interface VC_MyCollection (){
    NSInteger _page;
    ProjectOrderService *_projectOrderService;
    NSMutableArray *_arr_collections;
}

@end

@implementation VC_MyCollection

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"我的收藏";
    [self zyzOringeNavigationBar];
    [self loadData];
    [self layoutUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadcollection) name:@"mine_collection" object:nil];
}
-(void)loadData{
    _projectOrderService=[ProjectOrderService sharedService];
    _arr_collections=[NSMutableArray arrayWithCapacity:0];
    _page=1;
    _lb_toast.text=@"您还没收藏项目哦～\n您可以在接单列表中收藏您感兴趣的\n项目，方便接单。";
    NSRange range = [_lb_toast.text rangeOfString:@"您还没收藏项目哦～"];
    [CommonUtil  setTextColor:_lb_toast FontNumber:[UIFont systemFontOfSize:14.0] AndRange:range AndColor:[UIColor colorWithHex:@"333333"]];
}
-(void)getcollection{
    [_projectOrderService getOurCollectionByPage:_page result:^(NSInteger code, NSArray<ProjectOrderDomain *> *orders) {
        [self endingMJRefreshWithTableView:_tableView];
        if (code == 1) {
            if (_page == 1) {
                [_arr_collections removeAllObjects];
            }
            [_arr_collections addObjectsFromArray:orders];
            if (_arr_collections.count==0) {
                _tableView.hidden=YES;
                _iv_toast.hidden=NO;
                _lb_toast.hidden=NO;
                _btn_toast.hidden=NO;
            }else{
                _tableView.hidden=NO;
                _iv_toast.hidden=YES;
                _lb_toast.hidden=YES;
                _btn_toast.hidden=YES;
            }
            if (orders.count == 0) {
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
        [self getcollection];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self getcollection];
    }];
}

-(void)layoutUI{
    [self hideTableViewFooter:_tableView];
    [self downRefresh];
    [self upRefresh];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 4;
    return _arr_collections.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell_MyCollection *cell_mycollection = [tableView dequeueReusableCellWithIdentifier:cellID];
    static NSString *CellIdentifier = @"Cell_Letter_Perform";
    Cell_Letter_Perform *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BaseDomain *obj = [_arr_collections objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[ProjectOrderDomain class]]) {
        ProjectOrderDomain *collection = (ProjectOrderDomain *)obj;
        cell_mycollection.mycollection = collection;
        if (IS_IPHONE_5_OR_LESS) {
            cell_mycollection.lb_price.font=[UIFont systemFontOfSize:14.0];
            cell_mycollection.lb_time.font=[UIFont systemFontOfSize:12.0];
        }
        return cell_mycollection;
    } else {
        LetterPerformDomain *letterPerform = (LetterPerformDomain *)obj;
        cell.letterPerform = letterPerform;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseDomain *obj = [_arr_collections objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[ProjectOrderDomain class]]) {
        ProjectOrderDomain *collection = (ProjectOrderDomain *)obj;
        NSInteger productType = [collection.ProductType integerValue];
        [PageJumpHelper pushToVCID:@"VC_Tech_OrderDetail" storyboard:Storyboard_Main parameters:@{kPageDataDic:collection, kPageType:@(productType)} parent:self];
        
    } else {
        LetterPerformDomain *letterPerform = (LetterPerformDomain *)obj;
        [PageJumpHelper pushToVCID:@"VC_LetterPerformDetail" storyboard:Storyboard_Main parameters:@{kPageDataDic:letterPerform} parent:self];
    }
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView

           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *ID = @"";
        NSString *productType = @"";
        BaseDomain *obj = [_arr_collections objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[ProjectOrderDomain class]]) {
            ProjectOrderDomain *collection = (ProjectOrderDomain *)obj;
            ID = collection.SerialNo;
            productType = collection.ProductType;
        } else {
            LetterPerformDomain *letterPerform = (LetterPerformDomain *)obj;
            ID = letterPerform.SerialNo;
            productType = @"3";
        }
        [_projectOrderService deletecollectByID:ID productType:productType result:^(NSInteger code) {
            if (code==1) {
                [_arr_collections removeObjectAtIndex:indexPath.row];
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
                if (_arr_collections.count==0) {
                    _tableView.hidden=YES;
                    _iv_toast.hidden=NO;
                    _lb_toast.hidden=NO;
                    _btn_toast.hidden=NO;
                }else{
                    _tableView.hidden=NO;
                    _iv_toast.hidden=YES;
                    _lb_toast.hidden=YES;
                    _btn_toast.hidden=YES;
                }
                
            }else{
                [ProgressHUD showInfo:@"删除失败" withSucc:YES withDismissDelay:1];
            }
        }];
        
//        ProjectOrderDomain *collection = _arr_collections[indexPath.row];
//        [_projectOrderService deletecollectProjectByProjectID:collection.SummaryId result:^(NSInteger code) {
//            if (code==1) {
//                [_arr_collections removeObjectAtIndex:indexPath.row];
//                [tableView beginUpdates];
//                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//                [tableView endUpdates];
//                if (_arr_collections.count==0) {
//                    _tableView.hidden=YES;
//                    _iv_toast.hidden=NO;
//                    _lb_toast.hidden=NO;
//                    _btn_toast.hidden=NO;
//                }else{
//                    _tableView.hidden=NO;
//                    _iv_toast.hidden=YES;
//                    _lb_toast.hidden=YES;
//                    _btn_toast.hidden=YES;
//                }
//
//            }else{
//                [ProgressHUD showInfo:@"删除失败" withSucc:YES withDismissDelay:1];
//            }
//        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)btn_toast_pressed:(id)sender {
//    NSDictionary *dic=@{@"collectionPushType":@(1),kPageType:@"2"};
//    [PageJumpHelper pushToVCID:@"VC_Tech_Order" storyboard:Storyboard_Main parameters:dic parent:self];
    VC_Tech_Order *vc = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Tech_Order"];
    [self.navigationController pushViewController:vc animated:YES];
    vc.type = 1;
    vc.pushType = 1;
    
}
- (IBAction)btn_toastBudget_pressed:(id)sender{
//    NSDictionary *dic=@{@"collectionPushType":@(1),kPageType:@"2"};
//    [PageJumpHelper pushToVCID:@"VC_Tech_Order" storyboard:Storyboard_Main parameters:dic parent:self];
    
    VC_Tech_Order *vc = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Tech_Order"];
    [self.navigationController pushViewController:vc animated:YES];
    vc.type = 2;
    vc.pushType = 1;

}
-(void)reloadcollection{
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
