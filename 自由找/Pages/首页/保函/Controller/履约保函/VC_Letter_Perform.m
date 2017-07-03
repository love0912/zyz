//
//  VC_Letter_Perform.m
//  自由找
//
//  Created by 郭界 on 16/9/27.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Letter_Perform.h"
#import "Cell_Letter_Perform.h"
#import "UserDomain.h"
#import "ProductService.h"
#import "LetterService.h"

#define kLetterPerformSelectProjectTypeDic @"LetterPerformSelectProjectTypeDic"
#define kLetterPerformSelectRegionDic @"LetterPerformSelectRegionDic"

@interface VC_Letter_Perform ()
{
    NSMutableArray *_arr_Province;
    NSMutableArray *_arr_Type;
    //查询条件
    NSString *_regionID;
    NSString *_typeID;
    NSDictionary *_projectTypeDic;
    NSDictionary *_regionDic;
    
    ProductService *_productService;
    NSInteger _page;
    LetterService *_letterService;
    
    NSMutableArray *_arr_letterPerform;
}
@end

@implementation VC_Letter_Perform

- (void)initData {
    _arr_Province=[[NSMutableArray alloc]init];
    _arr_Type=[[NSMutableArray alloc]init];
    _arr_letterPerform = [NSMutableArray arrayWithCapacity:0];
    _regionID = @"0";
    _typeID = @"0";
    _productService = [ProductService sharedService];
    _letterService = [LetterService sharedService];
    _regionDic = (NSDictionary *)[CommonUtil objectForUserDefaultsKey:kLetterPerformSelectRegionDic];
    _projectTypeDic = (NSDictionary *)[CommonUtil objectForUserDefaultsKey:kLetterPerformSelectProjectTypeDic];
    
    [self requestProvinceData];
    
//    KeyValueDomain *p = [KeyValueDomain domainWithObject:@{@"Key": @"0", @"Value": @"全部地区"}];
//    [_arr_Province addObject:p];
//    KeyValueDomain *t = [KeyValueDomain domainWithObject:@{@"Key": @"0", @"Value": @"所有类别"}];
//    [_arr_Type addObject:t];
}

- (void)layoutUI {
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [self hideTableViewFooter:_tableView];
    
    _dropDownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, SCREEN_HEIGHT-104-44) andHeight:44];
    _dropDownMenu.directionType=1;
    _dropDownMenu.dataSource = self;
    _dropDownMenu.delegate = self;
    [self.view addSubview:_dropDownMenu];
    
    [self downRefresh];
    [self upRefresh];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLetterPerform) name:Notification_LetterPerform_Refresh object:nil];
    
//    [_dropDownMenu selectWithArray:@[@(0), @(0)]];
//    [_dropDownMenu reloadData];
}

- (void)refreshLetterPerform {
    [self.tableView.mj_header beginRefreshing];
}

//下拉刷新
- (void)downRefresh
{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self resetNoMoreStatusWithTableView:_tableView];
        _page = 1;
        [self getLetterPerformList];
    }];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self getLetterPerformList];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"履约保函";
    self.jx_navigationBar.hidden = YES;
    [self initData];
    [self layoutUI];
}

- (void)getLetterPerformList {
    [_letterService getLetterPerformListByArea:_regionDic category:_projectTypeDic page:_page result:^(NSInteger code, NSArray<LetterPerformDomain *> *list) {
        [self endingMJRefreshWithTableView:_tableView];
        if (code != 1) {
            return;
        }
        if (_page == 1) {
            [_arr_letterPerform removeAllObjects];
        }
        [_arr_letterPerform addObjectsFromArray:list];
        
        if (list.count == 0) {
            [self endingNoMoreWithTableView:_tableView];
        }
        [_tableView reloadData];
    }];
}

- (void)handleMenuSelected {
    int regionIndex = 0;
    if (_regionDic != nil) {
        _regionID = _regionDic[kCommonKey];
        for (int i = 0; i < _arr_Province.count; i++) {
            KeyValueDomain *domain = _arr_Province[i];
            if ([_regionID isEqualToString:domain.Key]) {
                regionIndex = i;
                break;
            }
        }
    }
    int projectTypeIndex = 0;
    if (_projectTypeDic != nil) {
        _typeID = _projectTypeDic[kCommonKey];
        for (int i = 0; i < _arr_Type.count; i++) {
            KeyValueDomain *domain = _arr_Type[i];
            if ([_typeID isEqualToString:domain.Key]) {
                projectTypeIndex = i;
                break;
            }
        }
        
    }
    [_dropDownMenu selectWithArray:@[@(regionIndex), @(projectTypeIndex)]];
}

- (void)requestProvinceData {
    [_productService getProductRegionToResult:^(NSInteger code, NSArray<KeyValueDomain *> *list) {
        if (code != 1) {
            return;
        }
        KeyValueDomain *allRegion = [[KeyValueDomain alloc] init];
        allRegion.Key = @"0";
        allRegion.Value = @"所有区域";
        [_arr_Province addObject:allRegion];
        [_arr_Province addObjectsFromArray:list];
        if (_regionDic == nil) {
            _regionDic = [_arr_Province.firstObject toDictionary];
        }
        [self requestProjectTypeData];
    }];
}
- (void)requestProjectTypeData {
    [_productService getProjectCatoryToResult:^(NSInteger code, NSArray<KeyValueDomain *> *list) {
        if (code != 1) {
            return ;
        }
        
        KeyValueDomain *allType = [[KeyValueDomain alloc] init];
        allType.Key = @"0";
        allType.Value = @"所有类别";
        [_arr_Type addObject:allType];
        [_arr_Type addObjectsFromArray:list];
        
        if (_projectTypeDic == nil) {
            _projectTypeDic = [_arr_Type.firstObject toDictionary];
        }
        [_dropDownMenu reloadData];
        [self handleMenuSelected];
        
        // 马上进入刷新状态
        [self.tableView.mj_header beginRefreshing];
        
    }];
    
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_letterPerform.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_Letter_Perform";
    Cell_Letter_Perform *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    LetterPerformDomain *letterPerform = [_arr_letterPerform objectAtIndex:indexPath.row];
    cell.letterPerform = letterPerform;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LetterPerformDomain *letterPerform = [_arr_letterPerform objectAtIndex:indexPath.row];
    [PageJumpHelper pushToVCID:@"VC_LetterPerformDetail" storyboard:Storyboard_Main parameters:@{kPageDataDic:letterPerform} parent:self];
}

#pragma mark - dropDownMenu datasource
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 2;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    NSInteger count;
    switch (column) {
        case 0:
            count = _arr_Province.count;
            break;
        case 1:
            count = _arr_Type.count;
            break;
        default:
            count = 0;
            break;
    }
    return count;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    NSString *resultString;
    
    switch (indexPath.column) {
        case 0:
        {
            KeyValueDomain *domain =_arr_Province[indexPath.row];
            resultString = domain.Value;
        }
            break;
        case 1:
        {
            KeyValueDomain *domain =_arr_Type[indexPath.row];
            resultString = domain.Value;
        }
            break;
        default:
            resultString = @"";
            break;
    }
    return resultString;
}

#pragma mark - dropDownMenu delegate
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    //选择的是区域
    if (indexPath.column == 0) {
        KeyValueDomain *domain =_arr_Province[indexPath.row];
        if ([_regionID isEqualToString:domain.Key]) {
            return;
        }
        _regionID = domain.Key;
        _regionDic = [domain toDictionary];
        [CommonUtil saveObject:_regionDic forUserDefaultsKey:kLetterPerformSelectRegionDic];
    }
    if (indexPath.column == 1) {
        KeyValueDomain *domain =_arr_Type[indexPath.row];
        if ([_typeID isEqualToString:domain.Key]) {
            return;
        }
        _typeID = domain.Key;
        _projectTypeDic = [domain toDictionary];
        [CommonUtil saveObject:_projectTypeDic forUserDefaultsKey:kLetterPerformSelectProjectTypeDic];
    }
    [_tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)btn_release_pressed:(id)sender {
    [PageJumpHelper pushToVCID:@"VC_ReleaseLetterPerform" storyboard:Storyboard_Main parent:self];
}
@end
