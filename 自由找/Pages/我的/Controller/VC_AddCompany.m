//
//  VC_AddCompany.m
//  自由找
//
//  Created by xiaoqi on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_AddCompany.h"
#import "Cell_InEnterprise.h"
#import "InCompanyService.h"
#import "InCompanyDomain.h"
#import "MineService.h"
#import "VC_Choice.h"
#import "BidService.h"
#import "VC_AddEditCompany.h"
#import <SwipeBack.h>
static NSString *CellIdentifier = @"Cell_InEnterprise";
@interface VC_AddCompany (){
    NSMutableArray *_company_data;
    CustomIOSAlertView *_alertView;
    BOOL _isSearching;
    int _page;
    NSMutableArray *_searchArray;
    InCompanyService *_inCompanyService;
    MineService *_mineService;
    BidService *_bidService;
    NSMutableDictionary *_paramdic;
    UserDomain *userDomain ;
    NSDictionary *_requestparamDic;
    
    /**
     *  2-- 客户管理－合作企业－增加客户,1 -- 从资质需求报名处进来，选择后可直接进行报名, 0 -- 从我所在的企业处进来, 3 -- 资质详情--所在企业-->
     */
    NSInteger _type;

}

@end

@implementation VC_AddCompany
-(void)initData{
    
    _tableView.hidden=YES;
    _isSearching = NO;
    _page = 1;
    _company_data=[[NSMutableArray alloc]init];
    _searchArray = [NSMutableArray array];
    _inCompanyService=[InCompanyService sharedService];
    _mineService=[MineService sharedService];
    _bidService = [BidService sharedService];
    _paramdic =[[NSMutableDictionary alloc]init];
    userDomain = [CommonUtil getUserDomain];
    
    _type = 0;
    if (self.parameters != nil) {
        _type = [[self.parameters objectForKey:kPageType] integerValue];
    }
    if (_type == 1) {
//        _searchBar.placeholder = @"输入您要报名的企业";
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.swipeBackEnabled=NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.swipeBackEnabled=YES;
}
-(void)layoutUI{
//    _searchBar.layer.borderWidth = 1;
//    _searchBar.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0] CGColor];
    
    
   [self hideTableViewFooter:_tableView];
}
-(void)backPressed{
    if (_type==2) {
        [self goBack];
    }else{
        [JAlertHelper jAlertWithTitle:@"没找到您要的企业，直接增加新的企业吗？" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex==1) {
                self.addCompanyBlock(self.parameters[kPageDataDic][kCompanyName]);
                [self goBack];
                
            }else{
                self.addCompanyBlock(@"请输入企业全称");
                [self goBack];
            }
        }];

    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"请选择企业";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    [self upRefresh];
    [self downRefresh];
    [self searchData];
}
//下拉刷新
- (void)downRefresh
{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self searchData];
    }];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self searchData];
    }];
}

-(void)searchData{
    if (_type==2) {
       _requestparamDic=@{kCompanyName:self.parameters[kPageDataDic][kCompanyName],kPage:[self stringWithInt:_page],kContainAptitudes:@(1)};
    }else{
       _requestparamDic=@{kCompanyName:self.parameters[kPageDataDic][kCompanyName],kPage:[self stringWithInt:_page]};
    }
    [_inCompanyService inCompanywithParamters:_requestparamDic result:^(NSArray<InCompanyDomain *> *user, NSInteger code) {
        [self endingMJRefreshWithTableView:_tableView];
        if (code != 1) {
            return ;
        }
        if (user.count==0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            
        }else{
            _lb_search.hidden=NO;
            _tableView.hidden=NO;
        if (_page == 1) {
            if (user.count==0) {
             _lb_search.hidden=YES;
             _tableView.hidden=YES;
              }
            [_company_data removeAllObjects];
          }
           [_company_data addObjectsFromArray:user];
           [_tableView reloadData];
        }
    }];
       
}

//-(void)loadAlertView{
//        _alertView = [[CustomIOSAlertView alloc] init];
//        [_alertView setContainerView:[self createDemoView]];
//        __weak typeof(self) weakSelf = self;
//       [_alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
//            [_alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
//                if(buttonIndex==1){
//                    [weakSelf pushAddEdit];
//                }else{
//                    [weakSelf initData];
//                }
//                [alertView close];
//            }];
//    
//        [_alertView setUseMotionEffects:true];
//    [_alertView show];
//}
//-(void)pushAddEdit{
//    VC_AddEditCompany *vc_AddEditCompany=[self.storyboard instantiateViewControllerWithIdentifier:@"VC_AddEditCompany"];
//    NSDictionary *dic=@{kCompanyName:self.searchBar.text,@"type":@(1)};
//    vc_AddEditCompany.parameters=dic;
//    vc_AddEditCompany.addEditCompanyBlock= ^(NSString *companyName) {
//    [self searchData];
//    };
//    [self.navigationController pushViewController:vc_AddEditCompany animated:YES];
//}
//- (UIView *)createDemoView
//{
//    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
//    UILabel *lb_alertTitle=[[UILabel alloc]init];
//    lb_alertTitle.text=@"您查询的：";
//    lb_alertTitle.textColor=[UIColor colorWithHex:@"666666"];
//    lb_alertTitle.font=[UIFont systemFontOfSize:15];
//    lb_alertTitle.textAlignment=NSTextAlignmentCenter;
//    [demoView addSubview:lb_alertTitle];
//    [lb_alertTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(100);
//            make.height.mas_equalTo(20);
//            make.topMargin.mas_equalTo(60);
//            make.centerX.equalTo(demoView.mas_centerX);
//        }];
//    UILabel *lb_companyname=[[UILabel alloc]init];
//    lb_companyname.text=_searchBar.text;
//    lb_companyname.textColor=[UIColor colorWithHex:@"ff7b23"];
//    lb_companyname.font=[UIFont systemFontOfSize:15];
//    lb_companyname.textAlignment=NSTextAlignmentCenter;
//    [demoView addSubview:lb_companyname];
//    [lb_companyname mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(290);
//        make.height.mas_equalTo(20);
//        make.top.equalTo(lb_alertTitle.mas_bottom).with.offset(9);
//        make.centerX.equalTo(demoView.mas_centerX);
//    }];
//    UILabel *lb_add=[[UILabel alloc]init];
//    lb_add.text=@"未在平台数据库中，是否添加？";
//    lb_add.textColor=[UIColor colorWithHex:@"333333"];
//    lb_add.font=[UIFont systemFontOfSize:16];
//    lb_add.textAlignment=NSTextAlignmentCenter;
//    [demoView addSubview:lb_add];
//    [lb_add mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(290);
//        make.height.mas_equalTo(20);
//        make.top.equalTo(lb_companyname.mas_bottom).with.offset(12);
//        make.centerX.equalTo(demoView.mas_centerX);
//    }];
//
//    return demoView;
//}
#pragma mark - tableviewx datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _company_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InCompanyDomain *incompany=_company_data[indexPath.row];
    Cell_InEnterprise*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.incompany=incompany;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     InCompanyDomain *incompany=_company_data[indexPath.row];
    [_paramdic setObject:incompany.CompanyId forKey:kCompanyID];
    if(_type==2){
        self.AddCompanyBlock2(incompany);
        [self goBack];
    }else{
       [self regionChoiceWithDic:[incompany toDictionary] indexPath:indexPath];
    }
    
    
}
- (void)regionChoiceWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    [_bidService getRegionToResult:^(NSArray<KeyValueDomain *> *regionList, NSInteger code) {
        if (code != 1) {
            return;
        }
        VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
        vc_choice.nav_title=@"选择经营区域";
        NSMutableArray *selectArray = [NSMutableArray array];
        
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:regionList];
        KeyValueDomain *native = dataArray.firstObject;
        if ([native.Key isEqualToString:@"0"]) {
            [dataArray removeObjectAtIndex:0];
        }
        [vc_choice setDataArray:dataArray selectArray:selectArray];
        vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
            [_paramdic setObject:resultDic[kCommonKey] forKey:kBidRegionCode];
//            [self unbidCompany];
            [self bidCompany];
        };
        [self.navigationController pushViewController:vc_choice animated:YES];
    }];
}

//解绑企业
-(void)unbidCompany{
    if (userDomain.Sites != nil && userDomain.Sites.count > 0) {

    [_mineService unbindCompanyToResult:^(NSInteger code) {
        if (code==1) {
             [self bidCompany];
        }
    }];
    }else{
        [self bidCompany];
    }
}
//绑定企业
-(void)bidCompany{
    //绑定企业
//    [_paramdic setObject:userDomain.UserId forKey:kUserID];
    [_mineService bindCompanyWithParameters:_paramdic result:^(NSInteger code) {
        if (code != 1) {
            return ;
        }
        
        if (_type == 0 || _type == 3) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_ARR_DATA" object:nil];
            [ProgressHUD showInfo:@"绑定成功" withSucc:YES withDismissDelay:1];
        } else {
            if (_type == 1) {
                //返回报名
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Bid_Attention object:nil];
            }
        }
        NSArray *tmpArray = self.navigationController.viewControllers;
//        NSLog(@"%@", tmpArray);
        UIViewController *vc = [tmpArray objectAtIndex:tmpArray.count - 3];
        [self.navigationController popToViewController:vc animated:YES];
    }];
}
//#pragma mark - search bar delegate
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//}
//
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    _isSearching = YES;
//}
//
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//    if (searchBar.text.length == 0) {
//        _isSearching = NO;
//        
//     }
//    if (searchBar.text.trimWhitesSpace.isEmptyString) {
//        [ProgressHUD showInfo:@"请输入企业名称" withSucc:NO withDismissDelay:2];
//        return;
//    }
//    [self searchData];
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    [searchBar resignFirstResponder];
//}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)stringWithInt:(int)number {
    return [NSString stringWithFormat:@"%d", number];
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
