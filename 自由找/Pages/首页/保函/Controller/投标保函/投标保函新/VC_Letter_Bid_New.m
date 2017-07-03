//
//  VC_Letter_Bid_New.m
//  zyz
//
//  Created by 郭界 on 16/11/25.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Letter_Bid_New.h"
#import "UserDomain.h"
#import "BidService.h"
#import "VC_Choice.h"
#import "Cell_Letter_Bid_New.h"
#import "LetterService.h"

#define DefaultRegion @{kCommonKey: @"0", kCommonValue: @"银行所在地"}
#define DefaultBank @{kCommonKey: @"0", kCommonValue: @"银行名称"}
#define DefaultType @{kCommonKey: @"0", kCommonValue: @"保函类别"}

@interface VC_Letter_Bid_New ()
{
    //查询条件
    NSInteger _regionIndex;
    NSInteger _bankIndex;
    NSInteger _typeIndex;
    NSMutableArray *_arr_region;
    NSMutableArray *_arr_bank;
    NSMutableArray *_arr_type;
    
    NSMutableArray *_arr_BidLetter;
    LetterService *_letterService;
    
    NSInteger _page;
    
    NSMutableDictionary *_regionDic;
    NSMutableDictionary *_bankDic;
    NSMutableDictionary *_typeDic;
}
@end

@implementation VC_Letter_Bid_New

- (void)initData {
    _arr_BidLetter = [NSMutableArray array];
    _letterService = [LetterService sharedService];
    
    _arr_region = [NSMutableArray array];
    _arr_bank = [NSMutableArray array];
    _arr_type = [NSMutableArray array];
    _regionDic = [NSMutableDictionary dictionary];
    [_regionDic setDictionary:DefaultRegion];
    _bankDic = [NSMutableDictionary dictionary];
    [_bankDic setDictionary:DefaultBank];
    _typeDic = [NSMutableDictionary dictionary];
    [_typeDic setDictionary:DefaultType];
    
//    KeyValueDomain *region = [KeyValueDomain domainWithObject:@{kCommonKey: @"0", kCommonValue: @"银行所在地"}];
//    [_arr_region addObject:region];
//    KeyValueDomain *bank = [KeyValueDomain domainWithObject:@{kCommonKey: @"0", kCommonValue: @"银行名称"}];
//    [_arr_bank addObject:bank];
//    KeyValueDomain *type = [KeyValueDomain domainWithObject:@{kCommonKey: @"0", kCommonValue: @"保函类别"}];
//    [_arr_type addObject:type];
    
//    [self getMenuData];
}

- (NSString *)menuStringForString:(NSString *)string {
    return [NSString stringWithFormat:@"%@ ∧", string];
}

- (void)layoutUI {
    
//    _dropDownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0,SCREEN_HEIGHT-104-44) andHeight:44];
//    _dropDownMenu.directionType=1;
//    _dropDownMenu.dataSource = self;
//    _dropDownMenu.delegate = self;
//    [self.view addSubview:_dropDownMenu];
    
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
        [self getBidLetters];
    }];
    [self.tableView.mj_header beginRefreshing];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self getBidLetters];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"投标保函";
    self.jx_navigationBar.hidden = YES;
    [self initData];
    [self layoutUI];
}

- (void)getMenuData {
    //1, 获取区域
    [self getCityData];
}

- (void)getBidLetters {
    [_letterService getBidLetterListByRegion:_regionDic bank:_bankDic typeDic:_typeDic page:_page result:^(NSInteger code, NSArray<BidLetterDomain *> *list) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (code == 1) {
            if (_page == 1) {
                [_arr_BidLetter removeAllObjects];
            }
            [_arr_BidLetter addObjectsFromArray:list];
            [_tableView reloadData];
            if (list.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }];
}

//#pragma mark - dropDownMenu datasource
//- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
//    return 3;
//}
//
//- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
//    NSInteger count;
//    switch (column) {
//        case 0:
//            count = _arr_region.count;
//            break;
//        case 1:
//            count = _arr_bank.count;
//            break;
//        case 2:
//            count = _arr_type.count;
//            break;
//        default:
//            count = 0;
//            break;
//    }
//    return count;
//}
//
//- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
//    NSString *resultString;
//    
//    switch (indexPath.column) {
//        case 0:
//        {
//            KeyValueDomain *domain =_arr_region[indexPath.row];
//            resultString = domain.Value;
//        }
//            break;
//        case 1:
//        {
//            KeyValueDomain *domain =_arr_bank[indexPath.row];
//            resultString = domain.Value;
//        }
//            break;
//        case 2:
//        {
//            KeyValueDomain *domain =_arr_type[indexPath.row];
//            resultString = domain.Value;
//        }
//            break;
//        default:
//            resultString = @"";
//            break;
//    }
//    return resultString;
//}
//
//#pragma mark - dropDownMenu delegate
//- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
//    //选择的是区域
//    if (indexPath.column == 0) {
//        KeyValueDomain *domain =_arr_region[indexPath.row];
//        if ([_regionDic[kCommonKey] isEqualToString:domain.Key]) {
//            [_dropDownMenu selectWithArray:@[@(_regionIndex), @(_bankIndex), @(_typeIndex)]];
//            return;
//        }
//        _regionIndex = indexPath.row;
//        [_regionDic setDictionary:[domain toDictionary]];
//    }
//    if (indexPath.column == 1) {
//        KeyValueDomain *domain =_arr_bank[indexPath.row];
//        if ([_bankDic[kCommonKey] isEqualToString:domain.Key]) {
//            return;
//        }
//        _bankIndex = indexPath.row;
//        [_bankDic setDictionary:[domain toDictionary]];
//    }
//    if (indexPath.column == 2) {
//        KeyValueDomain *domain =_arr_type[indexPath.row];
//        if ([_typeDic[kCommonKey] isEqualToString:domain.Key]) {
//            return;
//        }
//        _typeIndex = indexPath.row;
//        [_typeDic setDictionary:[domain toDictionary]];
//    }
//    [_tableView.mj_header beginRefreshing];
//}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_BidLetter.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_Letter_Bid_New";
    Cell_Letter_Bid_New *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    BidLetterDomain *bidLetter = [_arr_BidLetter objectAtIndex:indexPath.row];
    cell.bidLetter = bidLetter;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BidLetterDomain *bidLetter = [_arr_BidLetter objectAtIndex:indexPath.row];
    [PageJumpHelper pushToVCID:@"VC_Letter_Detail" storyboard:Storyboard_Main parameters:@{kPageDataDic: bidLetter} parent:self];
}

#pragma mark - 
- (void)getCityData {
    [[BidService sharedService] getRegionToResult:^(NSArray<KeyValueDomain *> *regionList, NSInteger code) {
        if (code != 1) {
            [ProgressHUD showInfo:@"获取区域出错，请稍后再试!" withSucc:NO withDismissDelay:2];
            [self goBack];
            return;
        }
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:regionList];
        KeyValueDomain *native = dataArray.firstObject;
        if ([native.Key isEqualToString:@"0"]) {
            native.Value = @"区域不限";
        }
//        KeyValueDomain *titleRegion = [KeyValueDomain domainWithObject:@{kCommonKey: @"#", kCommonValue: @"银行所在地"}];
//        [dataArray addObject:titleRegion];
        [_arr_region addObjectsFromArray:dataArray];
        //第二步，获取银行类别
        [self getBankType];
    }];
}

- (void)getBankType {
    [_letterService getBankTypeToResult:^(NSInteger code, NSArray *bankList) {
        if (code != 1) {
            [ProgressHUD showInfo:@"获取银行类别出错，请稍后再试!" withSucc:NO withDismissDelay:2];
            [self goBack];
            return;
        }
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:bankList];
        KeyValueDomain *native = dataArray.firstObject;
        if (![native.Key isEqualToString:@"0"]) {
            KeyValueDomain *titleBank = [KeyValueDomain domainWithObject:@{kCommonKey: @"0", kCommonValue: @"银行名称"}];
            [dataArray insertObject:titleBank atIndex:0];
        }
        [_arr_bank addObjectsFromArray:dataArray];
        //第三步，获取保函类别
        [self getLetterType];
        
    }];
}

- (void)getLetterType {
    [_letterService getLetterTypeToResult:^(NSInteger code, NSArray *typeList) {
        if (code != 1) {
            [ProgressHUD showInfo:@"获取保函类别出错，请稍后再试!" withSucc:NO withDismissDelay:2];
            [self goBack];
            return;
        }
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:typeList];
        KeyValueDomain *native = dataArray.firstObject;
        if (![native.Key isEqualToString:@"0"]) {
            KeyValueDomain *titleType = [KeyValueDomain domainWithObject:@{kCommonKey: @"0", kCommonValue: @"保函类别"}];
            [dataArray insertObject:titleType atIndex:0];

        }
        [_arr_type addObjectsFromArray:dataArray];
        
        [self setMenuSelect];
        
        [self.tableView.mj_header beginRefreshing];
        
    }];
}

- (void)setMenuSelect {
    _regionIndex = _arr_region.count-1;
    _bankIndex = _arr_bank.count-1;
    _typeIndex = _arr_type.count - 1;
    [_dropDownMenu selectWithArray:@[@(0), @(0), @(0)]];
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

- (IBAction)btn_region_pressed:(id)sender {
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

- (void)showRegionChoiceView {
    __block typeof(self) weakSelf = self;
    VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
    vc_choice.nav_title = @"选择银行所在地";
    NSMutableArray *selectArray = [NSMutableArray array];
    [selectArray addObject:_regionDic[kCommonKey]];
    [vc_choice setDataArray:_arr_region selectArray:selectArray];
    vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
        [_regionDic setDictionary:resultDic];
        weakSelf.lb_region.text = [self menuStringForString:resultDic[kCommonValue]];
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc_choice animated:YES];
}

- (IBAction)btn_bank_pressed:(id)sender {
    if (_arr_bank.count > 0) {
        [self showBankChoiceView];
    } else {
        [_letterService getBankTypeToResult:^(NSInteger code, NSArray *bankList) {
            if (code != 1) {
                [ProgressHUD showInfo:@"获取银行类别出错，请稍后再试!" withSucc:NO withDismissDelay:2];
                [self goBack];
                return;
            }
            NSMutableArray *dataArray = [NSMutableArray arrayWithArray:bankList];
            KeyValueDomain *native = dataArray.firstObject;
            if (![native.Key isEqualToString:@"0"]) {
                KeyValueDomain *titleBank = [KeyValueDomain domainWithObject:@{kCommonKey: @"0", kCommonValue: @"不限银行"}];
                [dataArray insertObject:titleBank atIndex:0];
            }
            [_arr_bank setArray:dataArray];
            [self showBankChoiceView];
        }];
    }
}

- (void)showBankChoiceView {
    __block typeof(self) weakSelf = self;
    VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
    vc_choice.nav_title = @"选择银行";
    NSMutableArray *selectArray = [NSMutableArray array];
    [selectArray addObject:_bankDic[kCommonKey]];
    [vc_choice setDataArray:_arr_bank selectArray:selectArray];
    vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
        [_bankDic setDictionary:resultDic];
        weakSelf.lb_bank.text = [self menuStringForString:resultDic[kCommonValue]];
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:vc_choice animated:YES];
}

- (IBAction)btn_type_pressed:(id)sender {
    if (_arr_type.count > 0) {
        [self showTypeChoiceView];
    } else {
        [_letterService getLetterTypeToResult:^(NSInteger code, NSArray *typeList) {
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
@end
