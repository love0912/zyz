//
//  VC_MyOrder.m
//  自由找
//
//  Created by xiaoqi on 16/8/9.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_MyOrder.h"
//#import "ChatViewController.h"
#import "ProjectOrderService.h"
#import "OurProjectOrderDomain.h"
#import "VC_Tech_Order.h"
#import "ProjectOrderDomain.h"

static NSString *cellID=@"Cell_MyOrder";
@interface VC_MyOrder (){
    NSInteger _page;
    ProjectOrderService *_projectOrderService;
    NSMutableArray *_arr_order;
}

@end

@implementation VC_MyOrder
-(void)getmyorder{
    [_projectOrderService getOurProjectOrderByPage:_page result:^(NSInteger code, NSArray<OurProjectOrderDomain *> *orders) {
        [self endingMJRefreshWithTableView:_tableView];
        if (code == 1) {
            if (_page == 1) {
                [_arr_order removeAllObjects];
            }
            [_arr_order addObjectsFromArray:orders];
            if (_arr_order.count==0) {
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
        [self getmyorder];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self getmyorder];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"我的接单";
    [self zyzOringeNavigationBar];
    [self loadData];
    [self layoutUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadOrder) name:@"mine_order" object:nil];
//    [self getmyorder];
}
-(void)loadData{
    _projectOrderService=[ProjectOrderService sharedService];
    _arr_order=[NSMutableArray arrayWithCapacity:0];
    _page=1;
     _lb_toast.text=@"您还没有接单项目哦～\n您可以在接单列表中选择您感兴趣的\n项目，进行接单。";
    NSRange range = [_lb_toast.text rangeOfString:@"您还没有接单项目哦～"];
    [CommonUtil  setTextColor:_lb_toast FontNumber:[UIFont systemFontOfSize:14.0] AndRange:range AndColor:[UIColor colorWithHex:@"333333"]];

}
-(void)layoutUI{
    [self hideTableViewFooter:_tableView];
    _tableView.rowHeight=124;
    [self downRefresh];
    [self upRefresh];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 4;
    return _arr_order.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell_MyOrder *cell_MyOrder = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell_MyOrder.delegate=self;
    OurProjectOrderDomain *order = [_arr_order objectAtIndex:indexPath.row];
    cell_MyOrder.myorder = order;
    return cell_MyOrder;

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OurProjectOrderDomain *order = [_arr_order objectAtIndex:indexPath.row];
    ProjectOrderDomain *pOrder = [ProjectOrderDomain domainWithObject:[order toDictionary]];
    [PageJumpHelper pushToVCID:@"VC_Tech_OrderDetail" storyboard:Storyboard_Main parameters:@{kPageType :@"3",kPageDataDic:pOrder, @"TakeOrderSnapData": order.TakeOrderSnapData} parent:self];
}
#pragma mark - MyOrderDelegate
- (void)clickPhoneResult:(NSString *)resultPhone{//打电话给发布者
    [CommonUtil callWithPhone:resultPhone];
}
- (void)clickChatResult:(NSString *)resultChatID{//聊天
    [ProgressHUD showProgressHUDWithInfo:@"正在登录聊天..."];
//    [self EMRegisterWithUsername:[CommonUtil getUserDomain].Phone password:[CommonUtil getUserDomain].UserId Result:resultChatID];
}
//-(void)EMRegisterWithUsername:(NSString *)username password:(NSString *)password Result:(NSString *)resultChatID{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        EMError *error = [[EMClient sharedClient] registerWithUsername:username password:password];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            if (!error) {
//                 [self loginWithUsername:username password:password Result:resultChatID];
//            }else{
//                switch (error.code) {
//                    case EMErrorServerNotReachable:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
//                        break;
//                    case EMErrorUserAlreadyExist:{
//                        [self loginWithUsername:username password:password Result:resultChatID];
//                    }
//                        break;
//                    case EMErrorNetworkUnavailable:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
//                        break;
//                    case EMErrorServerTimeout:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
//                        break;
//                    default:
//                        NSLog(@"%u",error.code);
//                        TTAlertNoTitle(NSLocalizedString(@"register.fail", @"Registration failed"));
//                        break;
//                }
//            }
//        });
//    });
//}
////环信登陆
//- (void)loginWithUsername:(NSString *)username password:(NSString *)password Result:(NSString *)resultChatID
//{
//    //异步登陆账号
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (!error) {
//                //设置是否自动登录
//                [[EMClient sharedClient].options setIsAutoLogin:NO];
//                //获取数据库中数据
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    [[EMClient sharedClient] dataMigrationTo3];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                            EMError *error = nil;
//                            [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
//                        });
//                        [ProgressHUD hideProgressHUD];
//                        ChatViewController *message = [[ChatViewController alloc] initWithConversationChatter:resultChatID conversationType:EMConversationTypeChat];
//                        [self.navigationController pushViewController:message animated:YES];
//                        //保存最近一次登录用户名
//                        [self saveLastLoginUsername];
//                        
//                        
//                    });
//                });
//            } else {
//                switch (error.code)
//                {
//                    case EMErrorUserNotFound:{
//                        
//                        
//                    }
//                        break;
//                    case EMErrorNetworkUnavailable:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
//                        break;
//                    case EMErrorServerNotReachable:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
//                        break;
//                    case EMErrorUserAuthenticationFailed:
//                        TTAlertNoTitle(error.errorDescription);
//                        break;
//                    case EMErrorServerTimeout:
//                        TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
//                        break;
//                    default:
//                        TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
//                        break;
//                }
//            }
//        });
//    });
//}
//#pragma  mark - private
//- (void)saveLastLoginUsername
//{
//    NSString *username = [[EMClient sharedClient] currentUsername];
//    if (username && username.length > 0) {
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
//        [ud synchronize];
//    }
//}
- (void)clickAddendumResult:(NSString *)resultAddendum{//查看补遗
    [PageJumpHelper pushToVCID:@"VC_AddendumContent" storyboard:Storyboard_Mine parameters:@{kBidProjectID:resultAddendum} parent:self];
}
- (void)clickMoneyResult:(WalletRecordDomain *)resultMoney{
    if ([resultMoney.RecordType isEqualToString:@"3"]) {
        [PageJumpHelper pushToVCID:@"VC_PaymentDeatails" storyboard:Storyboard_Mine parameters:@{kPageType:@"2",@"WalletRecordDomain":resultMoney} parent:self];
    }else{
       [PageJumpHelper pushToVCID:@"VC_PaymentDeatails" storyboard:Storyboard_Mine parameters:@{kPageType:@"1",@"WalletRecordDomain":resultMoney} parent:self];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)btn_toast_pressed:(id)sender {
//    VC_Tech_Order *vc = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Tech_Order"];
//    [self.navigationController pushViewController:vc animated:YES];
//    vc.type = 1;
//    vc.pushType = 2;
    
    [PageJumpHelper pushToVCID:@"VC_Technology" storyboard:Storyboard_Main parameters:@{kPageType:@1} parent:self];
}
- (IBAction)btn_toastBudget_pressed:(id)sender{
//    VC_Tech_Order *vc = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Tech_Order"];
//    [self.navigationController pushViewController:vc animated:YES];
//    vc.type = 2;
//    vc.pushType = 2;
    [PageJumpHelper pushToVCID:@"VC_Budget" storyboard:Storyboard_Main parameters:@{kPageType:@1} parent:self];
}
-(void)reloadOrder{
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
