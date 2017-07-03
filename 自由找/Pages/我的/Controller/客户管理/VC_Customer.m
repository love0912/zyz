//
//  VC_Customer.m
//  自由找
//
//  Created by guojie on 16/7/5.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Customer.h"
#import "ZKSegment.h"
#import "CustomerService.h"
#import "JJDBService.h"

@interface VC_Customer ()
{
    ZKSegment *_segment;
    /**
     *  1 -- 合作企业， 2 -- 项目记录
     */
    NSInteger _type;
    
    NSMutableArray *_arr_customer;
    NSMutableArray *_arr_project;
    NSInteger _page;
    CustomerService *_customerService;
    JJDBService *_dbService;
    NSString *_companyTips;
    NSString *_projectTips;
    
}
@end

@implementation VC_Customer

- (void)initData {
    _type = 1;
    _page = 1;
    _arr_customer = [NSMutableArray array];
    _arr_project = [NSMutableArray array];
    _customerService = [CustomerService sharedService];
    _dbService = [JJDBService sharedJJDBService];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCustomer) name:Notification_Customer_Refresh object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProjectList) name:Notification_CProject_Refresh object:nil];
    
    _companyTips = @"这里您可以管理您熟悉的企业";
    _projectTips = @"这里您可以管理您报名的项目";
    
    [self changeTipsText];
}

- (void)changeTipsText {
    NSString *text = @"点击下方“添加企业”按钮添加";
    if (_type == 1) {
        _lb_tips.text = _companyTips;
    } else {
        _lb_tips.text = _projectTips;
        text = @"点击下方“添加项目”按钮添加";
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[CommonUtil zyzOrangeColor] range:NSMakeRange(4,6)];
    _lb_tips2.attributedText = attributeString;
}

- (void)refreshCustomer {
    _page = 1;
    [_tableView.mj_footer resetNoMoreData];
    [self getCustomer];
}

- (void)refreshProjectList {
    NSString *userId = @"";
    if ([CommonUtil isLogin]) {
        userId = [CommonUtil getUserDomain].UserId;
    }
    NSArray *tmpArray = [_dbService getProjectByUserId:userId];
    if (tmpArray != nil) {
        [_arr_project removeAllObjects];
        [_arr_project addObjectsFromArray:tmpArray];
    }
    [_tableView reloadData];
    if (_arr_project.count == 0) {
        _tableView.hidden = YES;
    } else {
        _tableView.hidden = NO;
    }
}

- (void)layoutUI {
//    [self addSegmentView];
    
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 10)];
    tableViewHeaderView.backgroundColor = [CommonUtil zyzBackgroundColor];
    self.tableView.tableHeaderView = tableViewHeaderView;
    [self hideTableViewFooter:self.tableView];
    
    [self layoutAddButtonTitle];
    [self layoutSearchButton];
    
    [self upRefresh];
    [self downRefresh];
    
    [self getCustomer];
    
}

- (void)layoutAddButtonTitle {
    if (_type == 1) {
        [_btn_add setTitle:@"添加企业" forState:UIControlStateNormal];
        [self upRefresh];
        [self downRefresh];
        if (_arr_customer.count > 0) {
            _tableView.hidden = NO;
        } else {
            _tableView.hidden = YES;
        }
        [self layoutSearchButton];
    } else {
        [_btn_add setTitle:@"添加项目" forState:UIControlStateNormal];
        [self cleanRefreshControl];
        [self refreshProjectList];
        if (_arr_project.count > 0) {
            _tableView.hidden = NO;
        } else {
            _tableView.hidden = YES;
        }
        [self resetRightItem];
    }
    [_tableView reloadData];
}

- (void)addSegmentView {
    _segment = [ZKSegment zk_segmentWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44) style:ZKSegmentLineStyle];
    [_segment zk_setItems:@[@"合作企业", @"项目记录"]];
    _segment.zk_itemSelectedColor = [UIColor orangeColor];
    _segment.zk_itemStyleSelectedColor = [UIColor orangeColor];
    __block VC_Customer *weakSelf = self;
    _segment.zk_itemClickBlock=^(NSString *itemName , NSInteger itemIndex){
        _type = itemIndex + 1;
        [weakSelf layoutAddButtonTitle];
        [weakSelf changeTipsText];
    };
    [_v_top addSubview:_segment];
}

- (void)layoutSearchButton {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Customer_Search"] style:UIBarButtonItemStylePlain target:self action:@selector(toSearchVC)];
    [self setNavigationBarRightItem:rightItem];
}

- (void)resetRightItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self setNavigationBarRightItem:item];
}

- (void)toSearchVC {
    [PageJumpHelper pushToVCID:@"VC_CustomerSearch" storyboard:Storyboard_Mine parent:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"合作企业";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

//下拉刷新
- (void)downRefresh
{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getCustomer];
    }];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self getCustomer];
    }];
}

- (void)cleanRefreshControl {
    self.tableView.mj_footer = nil;
    self.tableView.mj_header = nil;
}

- (void)getCustomer {
    [_customerService queryCustomerWithParameters:@{kPage: @(_page)} result:^(NSArray<CustomerDomain *> *arr_custom, NSInteger count, NSInteger code) {
        [self endingMJRefreshWithTableView:_tableView];
        if (code == 1) {
            if (_page == 1) {
                [_arr_customer removeAllObjects];
            }
            [_arr_customer addObjectsFromArray:arr_custom];
            [_tableView reloadData];
            if (arr_custom.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        if (_page == 1 && arr_custom.count == 0) {
            _tableView.hidden = YES;
        } else {
            _tableView.hidden = NO;
        }
    }];
}

#pragma mark - 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_type == 1) {
        return _arr_customer.count;
    }
    return _arr_project.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_Customer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (_type == 1) {
        CustomerDomain *domain = [_arr_customer objectAtIndex:indexPath.row];
        cell.textLabel.text = domain.CustomerName;
    } else {
        Project *project = [_arr_project objectAtIndex:indexPath.row];
        NSString *title = project.name;
        if (title == nil || [title isEqualToString:@""]) {
            title = [NSString stringWithFormat:@"%@号", project.projectId];
        }
        cell.textLabel.text = title;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 1) {
        //合作企业
        CustomerDomain *domain = [_arr_customer objectAtIndex:indexPath.row];
        [PageJumpHelper pushToVCID:@"VC_CustomerDetail" storyboard:Storyboard_Mine parameters:@{kPageDataDic: domain.CustomerId} parent:self];
        
    } else {
        //项目记录
        Project *project = [_arr_project objectAtIndex:indexPath.row];
        [PageJumpHelper pushToVCID:@"VC_CProject_Detail" storyboard:Storyboard_Mine parameters:@{kPageDataDic: project} parent:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (IBAction)btn_add_pressed:(id)sender {
    NSString *vcID = @"VC_AddCustomer";
    if (_type == 2) {
        vcID = @"VC_AddProject";
    }
    [PageJumpHelper pushToVCID:vcID storyboard:Storyboard_Mine parent:self];
}
@end
