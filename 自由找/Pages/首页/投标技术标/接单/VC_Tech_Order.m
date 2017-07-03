//
//  VC_Tech_Order.m
//  自由找
//
//  Created by guojie on 16/7/28.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Tech_Order.h"
#import "BidService.h"
#import "ProjectOrderService.h"
#import "ProductService.h"
#define kProjectOrderSelectProjectTypeDic @"ProjectOrderSelectProjectTypeDic"
#define kProjectOrderSelectRegionDic @"ProjectOrderSelectRegionDic"


static NSString *CellSearchID = @"Cell_Tech_SearchOrder";
@interface VC_Tech_Order (){
    CGFloat _headerHeight;
    NSMutableArray *_arr_Input;
    NSInteger _page;
    //查询条件
    NSString *_regionID;
    NSString *_typeID;
    NSMutableArray *_arr_Province;
    NSMutableArray *_arr_Type;
    
    BidService *_bidService;
    ProductService *_productService;
    ProjectOrderService *_projectService;
    
    NSDictionary *_projectTypeDic;
    NSDictionary *_regionDic;

}

@end

@implementation VC_Tech_Order
//下拉刷新
- (void)downRefresh
{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self resetNoMoreStatusWithTableView:_tableView];
        _page = 1;
        [self getProjectList];
    }];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self getProjectList];
    }];
}

- (void)getProjectList {
    NSString *orderType = [NSString stringWithFormat:@"%ld", _type];
    [_projectService getProjectOrderByProductType:orderType region:_regionDic projectType:_projectTypeDic page:_page result:^(NSInteger code, NSArray<ProjectOrderDomain *> *orders) {
        [self endingMJRefreshWithTableView:_tableView];
        if (code != 1) {
            return;
        }
        if (_page == 1) {
            [_arr_Input removeAllObjects];
        }
        [_arr_Input addObjectsFromArray:orders];
        
        if (orders.count == 0) {
            [self endingNoMoreWithTableView:_tableView];
        }
        [_tableView reloadData];
    }];
}
-(void)backPressed{
    if (_pushType==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mine_collection" object:nil];
    }else if (_pushType==2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mine_order" object:nil];
    }
    [self goBack];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"接单";
    self.jx_navigationBar.hidden = YES;
    [self upRefresh];
    [self downRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:Notification_OrderReceive_Refresh object:nil];
//    self.type = [[self.parameters objectForKey:kPageType] integerValue];
//    [self setType:_type];
    
}

- (void)refreshTable {
    [_tableView.mj_header beginRefreshing];
}

- (void)setType:(NSInteger)type {
    _type = type;
    [self loadData];
    [self layoutUI];
    
}

- (void)setPushType:(NSInteger)pushType {
    _pushType = pushType;
    if (pushType == 1 || pushType == 2) {
        self.jx_navigationBar.hidden = NO;
        [self zyzOringeNavigationBar];
        _layout_tableView_top.constant = 64;
        if (_dropDownMenu !=nil) {
            [_dropDownMenu removeFromSuperview];
        }
        _dropDownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0,SCREEN_HEIGHT-44) andHeight:44];
        _dropDownMenu.directionType=1;
        _dropDownMenu.dataSource = self;
        _dropDownMenu.delegate = self;
        [self.view addSubview:_dropDownMenu];
        self.v_bottom_back=_dropDownMenu;
        
        
        _tableView.rowHeight=120;
        self.iv_headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, _headerHeight)];
        self.iv_headerView.userInteractionEnabled = YES;
        self.iv_headerView.userInteractionEnabled = YES;
        self.iv_headerView.image=[UIImage imageNamed:@"banner_hztg"];
        [self.tableView addSubview:self.iv_headerView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showReiciveReadme)];
        [self.iv_headerView addGestureRecognizer:tap];
        
        UIView *backView = [[UIView alloc] initWithFrame:self.iv_headerView.bounds];
        self.tableView.tableHeaderView =backView;
        backView.hidden = YES;
    }
}

- (void)showReiciveReadme {
    [CommonUtil showReiciveOrderReadmeProtocalInController:self];
}

-(void)loadData{
//    if (IS_IPHONE_5_OR_LESS) {
//        _headerHeight = 120;
//    }else{
//        _headerHeight = 140;
//    }
    _headerHeight = 104.f/375.f * SCREEN_WIDTH;
    _page = 1;
    _regionID = @"0";
    _typeID = @"0";
    _arr_Province=[[NSMutableArray alloc]init];
    _arr_Type=[[NSMutableArray alloc]init];
    _arr_Input=[[NSMutableArray alloc]init];
//    _type = [[self.parameters objectForKey:kPageType] integerValue];
    if (_type == 1) {
        self.jx_title = @"投标技术标方案接单";
    } else {
        self.jx_title = @"预算方案接单";
    }
    
    _regionDic = (NSDictionary *)[CommonUtil objectForUserDefaultsKey:kProjectOrderSelectRegionDic];
    _projectTypeDic = (NSDictionary *)[CommonUtil objectForUserDefaultsKey:kProjectOrderSelectProjectTypeDic];
    _bidService=[BidService sharedService];
    _projectService = [ProjectOrderService sharedService];
    _productService=[ProductService sharedService];
    [self requestProvinceData];


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

-(void)layoutUI{
//    _tableView.rowHeight=120;
    self.iv_headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, ScreenSize.width, _headerHeight)];
    self.iv_headerView.userInteractionEnabled = YES;
    self.iv_headerView.image=[UIImage imageNamed:@"banner_hztg"];
    [self.tableView addSubview:self.iv_headerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showReiciveReadme)];
    [self.iv_headerView addGestureRecognizer:tap];

    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _headerHeight + 8)];
//    [backView addSubview:self.iv_headerView];
    self.tableView.tableHeaderView =backView;
    backView.hidden = YES;
    
    _dropDownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, SCREEN_HEIGHT-104-44) andHeight:44];
    _dropDownMenu.directionType=1;
    _dropDownMenu.dataSource = self;
    _dropDownMenu.delegate = self;
    [self.view addSubview:_dropDownMenu];
    self.v_bottom_back=_dropDownMenu;
    [self hideTableViewFooter:self.tableView];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_Input.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell_Tech_SearchOrder *cell_Tech_SearchOrder = [tableView dequeueReusableCellWithIdentifier:CellSearchID];
    if (IS_IPHONE_5_OR_LESS) {
        cell_Tech_SearchOrder.lb_price.font=[UIFont systemFontOfSize:12.0];
        cell_Tech_SearchOrder.lb_time.font=[UIFont systemFontOfSize:10.0];
    }
    cell_Tech_SearchOrder.delegate=self;
    ProjectOrderDomain *projectOrder = [_arr_Input objectAtIndex:indexPath.row];
    cell_Tech_SearchOrder.projectOrder = projectOrder;
    
    return cell_Tech_SearchOrder;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectOrderDomain *projectOrder = [_arr_Input objectAtIndex:indexPath.row];
    [PageJumpHelper pushToVCID:@"VC_Tech_OrderDetail" storyboard:Storyboard_Main parameters:@{kPageDataDic: projectOrder,kPageType:@(_type)} parent:self];
    
}
#pragma mark - SearchOrderDelegate delegate
- (void)collectionResult:(NSInteger )result projectID:(NSString *)projectID{
    if (result == 1) {
        [_projectService collectProjectByProjectID:projectID result:^(NSInteger code) {
            if (code == 1) {
                [ProgressHUD showInfo:@"收藏成功" withSucc:YES withDismissDelay:2];
                [_tableView.mj_header beginRefreshing];
            }
        }];
    }
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
        [CommonUtil saveObject:_regionDic forUserDefaultsKey:kProjectOrderSelectRegionDic];
    }
    if (indexPath.column == 1) {
        KeyValueDomain *domain =_arr_Type[indexPath.row];
        if ([_typeID isEqualToString:domain.Key]) {
            return;
        }
        _typeID = domain.Key;
        _projectTypeDic = [domain toDictionary];
        [CommonUtil saveObject:_projectTypeDic forUserDefaultsKey:kProjectOrderSelectProjectTypeDic];
    }
    [_tableView.mj_header beginRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
