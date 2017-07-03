//
//  VC_FindLetterCompany.m
//  zyz
//
//  Created by 郭界 on 17/1/9.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "VC_FindLetterCompany.h"
#import "Cell_FindLetterCompany.h"
#import "VC_Choice.h"
#import "BidService.h"
#import "LetterService.h"

#define DefaultRegion @{kCommonKey: @"0", kCommonValue: @"经营区域"}
#define DefaultType @{kCommonKey: @"0", kCommonValue: @"经营类别"}


@interface VC_FindLetterCompany ()
{
    LetterService *_letterService;
    
    NSInteger _page;
    NSMutableArray *_arr_region;
    NSMutableArray *_arr_type;
    
    NSMutableDictionary *_regionDic;
    NSMutableDictionary *_typeDic;
    
    NSMutableArray *_arr_company;
}
@end

@implementation VC_FindLetterCompany

- (void)initData {
    _arr_region = [NSMutableArray array];
    _arr_type = [NSMutableArray array];
    _regionDic = [NSMutableDictionary dictionary];
    [_regionDic setDictionary:DefaultRegion];
    _typeDic = [NSMutableDictionary dictionary];
    [_typeDic setDictionary:DefaultType];
    
    _letterService = [LetterService sharedService];
    _arr_company = [NSMutableArray arrayWithCapacity:0];
}

- (void)layoutUI {
    [self downRefresh];
    [self upRefresh];
}

//下拉刷新
- (void)downRefresh
{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [_tableView.mj_footer resetNoMoreData];
        _page = 1;
        [self getCompanys];
    }];
    [self.tableView.mj_header beginRefreshing];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self getCompanys];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"找担保或投资";
    self.jx_navigationBar.hidden = YES;
    [self initData];
    [self layoutUI];
}

- (void)getCompanys {
    [_letterService getLetterCompanyListByRegionOfDic:_regionDic typeOfDic:_typeDic page:_page result:^(NSArray<LetterCompanyDomain *> *companyList, NSInteger code) {
        [self endingMJRefreshWithTableView:_tableView];
        if (code != 1) {
            return;
        }
        if (_page == 1) {
            [_arr_company removeAllObjects];
        }
        [_arr_company addObjectsFromArray:companyList];
        
        if (companyList.count == 0) {
            [self endingNoMoreWithTableView:_tableView];
        }
        [_tableView reloadData];
    }];
}

#pragma mark - tableview 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_company.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_FindLetterCompany";
    Cell_FindLetterCompany *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    LetterCompanyDomain *company = [_arr_company objectAtIndex:indexPath.row];
    cell.company = company;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LetterCompanyDomain *company = [_arr_company objectAtIndex:indexPath.row];
    [PageJumpHelper pushToVCID:@"VC_LetterCompanyDetail" storyboard:Storyboard_Main parameters:@{kPageDataDic: company} parent:self];
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

- (IBAction)btn_scope_pressed:(id)sender {
    if (_arr_region.count > 0) {
        [self showRegionChoiceView];
    } else {
        [[BidService sharedService] getRegionToResult:^(NSArray<KeyValueDomain *> *regionList, NSInteger code) {
            if (code != 1) {
                return;
            }
            NSMutableArray *dataArray = [NSMutableArray arrayWithArray:regionList];
            KeyValueDomain *native = dataArray.firstObject;
            if ([native.Key isEqualToString:@"0"]) {
                native.Value = @"所在地不限";
            }
            [_arr_region setArray:dataArray];
            [self showRegionChoiceView];
        }];
    }
}
- (IBAction)btn_type_pressed:(id)sender {
    if (_arr_type.count > 0) {
        [self showTypeChoiceView];
    } else {
        [_letterService getLetterCompanyTypeToResult:^(NSInteger code, NSArray *typeList) {
            if (code != 1) {
                [ProgressHUD showInfo:@"获取保函类别出错，请稍后再试!" withSucc:NO withDismissDelay:2];
                [self goBack];
                return;
            }
            NSMutableArray *dataArray = [NSMutableArray arrayWithArray:typeList];
            KeyValueDomain *native = dataArray.firstObject;
            if (![native.Key isEqualToString:@"0"]) {
                KeyValueDomain *titleType = [KeyValueDomain domainWithObject:@{kCommonKey: @"0", kCommonValue: @"所有类别"}];
                [dataArray insertObject:titleType atIndex:0];
                
            }
            [_arr_type setArray:dataArray];
            
            [self showTypeChoiceView];
        }];
    }
}

- (void)showRegionChoiceView {
    __block typeof(self) weakSelf = self;
    VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
    vc_choice.nav_title = @"选择银行所在地";
    NSMutableArray *selectArray = [NSMutableArray array];
    [selectArray addObject:_regionDic[kCommonKey]];
    [vc_choice setDataArray:_arr_region selectArray:selectArray];
    vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
        [_regionDic setDictionary:resultDic];
        weakSelf.lb_scope.text = [self menuStringForString:resultDic[kCommonValue]];
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc_choice animated:YES];
}

- (void)showTypeChoiceView {
    __block typeof(self) weakSelf = self;
    VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
    vc_choice.nav_title = @"选择保函类别";
    NSMutableArray *selectArray = [NSMutableArray array];
    [selectArray addObject:_typeDic[kCommonKey]];
    [vc_choice setDataArray:_arr_type selectArray:selectArray];
    vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
        [_typeDic setDictionary:resultDic];
        weakSelf.lb_type.text = [self menuStringForString:resultDic[kCommonValue]];
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc_choice animated:YES];
}

- (NSString *)menuStringForString:(NSString *)string {
    return [NSString stringWithFormat:@"%@ ∧", string];
}
@end
