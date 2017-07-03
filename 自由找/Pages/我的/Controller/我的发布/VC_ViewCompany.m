//
//  VC_ViewCompany.m
//  自由找
//
//  Created by guojie on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_ViewCompany.h"
#import "JoinService.h"
#import "JXRatingView.h"
#define CellDefaultHeight 128
#define CellReturnHeight 83

@interface VC_ViewCompany ()
{
    CGFloat _constraint;
    NSInteger _selectIndex;
    
    //Marker:（int) 0/1/2/4   不同意 ，同意 ，最新，退回
    NSInteger _marker;
    CGFloat _cellHeight;
    NSInteger _page;
    NSString *_projectID;
    
    JoinService *_joinService;
    
    NSMutableArray *_arr_attentionUser;
}

@end

@implementation VC_ViewCompany

- (void)initData {
    _constraint = 0;
    _selectIndex = 0;
    _marker = 2;
    _page = 1;
    if (self.parameters != nil) {
        _projectID = [self.parameters objectForKey:kBidProjectID];
    }
    _arr_attentionUser = [NSMutableArray array];
    _joinService = [JoinService sharedService];
}

- (void)layoutUI {
    [self layoutMenuView];
    [self layoutSendMsgButton];
    [self downRefresh];
    [self upRefresh];
}

- (void)layoutSendMsgButton {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发送短信" style:UIBarButtonItemStylePlain target:self action:@selector(toSendMsgVC)];
    [self setNavigationBarRightItem:rightItem];
}

- (void)layoutMenuView {
    UITapGestureRecognizer *v_new_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(v_new_tap:)];
    [_v_new addGestureRecognizer:v_new_tap];
    UITapGestureRecognizer *v_agree_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(v_agree_tap:)];
    [_v_agree addGestureRecognizer:v_agree_tap];
    UITapGestureRecognizer *v_disagree_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(v_disagree_tap:)];
    [_v_disagree addGestureRecognizer:v_disagree_tap];
    UITapGestureRecognizer *v_return_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(v_return_tap:)];
    [_v_return addGestureRecognizer:v_return_tap];
}
//下拉刷新
- (void)downRefresh
{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getAttentionUserList];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self getAttentionUserList];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"报名企业列表";
    [self zyzOringeNavigationBar];
    
    [self initData];
    [self layoutUI];
}

- (void)toSendMsgVC {
    [PageJumpHelper pushToVCID:@"VC_SendMsg" storyboard:Storyboard_Mine parameters:@{kPageDataDic: _projectID} parent:self];
}

- (void)getAttentionUserList {
    NSDictionary *paramDic = @{kPage: @(_page), kBidProjectID: _projectID, kBidMarker: @(_marker)};;
    [_joinService queryAttentionUserListWithParameters:paramDic result:^(AttentionUserList *userList, NSInteger code) {
        [self endingMJRefreshWithTableView:self.tableView];
        if (code != 1) {
            return ;
        }
        
        if (_page == 1) {
            [_arr_attentionUser removeAllObjects];
        }
        [self setHeadCount:userList.Count];
        [_arr_attentionUser addObjectsFromArray:userList.Items];
        [_tableView reloadData];
        [self scrollLine];
        
        if (userList.Items.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)setHeadCount:(CountDomain *)countDomain {
    _lb_new.text = [NSString stringWithFormat:@"最新(%@)", countDomain.CountLastest == nil ? @"0" : countDomain.CountLastest];
    _lb_agree.text = [NSString stringWithFormat:@"同意(%@)", countDomain.CountAgree == nil ? @"0" : countDomain.CountAgree];
    _lb_disagree.text = [NSString stringWithFormat:@"不同意(%@)", countDomain.CountDisAgree == nil ? @"0" : countDomain.CountDisAgree];
    _lb_return.text = [NSString stringWithFormat:@"退撤回(%@)", countDomain.CountStop == nil ? @"0" : countDomain.CountStop];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_attentionUser.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_ViewCompany";
    Cell_ViewCompany *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.attentionUser = [_arr_attentionUser objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_marker == 4) {
        return CellReturnHeight;
    }
    return CellDefaultHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AttentionUserDomain *attentionUser = [_arr_attentionUser objectAtIndex:indexPath.row];
    [PageJumpHelper pushToVCID:@"VC_CompanyDetail" storyboard:Storyboard_Mine parameters:@{kPageDataDic: attentionUser.Url,kCompanyID:attentionUser.ProjectId,@"Type":@1} parent:self];
}


#pragma mark - cell button click
- (void)clickViewCompany:(AttentionUserDomain *)attentionUser type:(ViewCompanyType)type {
    switch (type) {
        case ViewCompanyCall:
        {
            [self callWithAttention:attentionUser];
        }
            break;
        case ViewCompanyAgree:
        {
            [self agreeWithAttention:attentionUser];
        }
            break;
        case ViewCompanyDisagree:
        {
            if ([attentionUser.PublishRank isEmptyString]) {
                [JAlertHelper jSheetWithTitle:@"您还未评价，请选择不同意的原因" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"评价" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        //去评价
                        [self accessWithAttention:attentionUser finishSelector:@selector(disagreeWithAttention:)];
                    }
                }];
            } else {
                [self disagreeWithAttention:attentionUser];
            }
        }
            break;
        case ViewCompanyReturn:
        {
            if ([attentionUser.PublishRank isEmptyString]) {
                [JAlertHelper jSheetWithTitle:@"您还未评价，请评价退回的原因" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"评价" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                    if (buttonIndex == 0) {
                        //去评价
                        [self accessWithAttention:attentionUser finishSelector:@selector(returnWithAttention:)];
                    }
                }];
            } else {
                [self returnWithAttention:attentionUser];
            }
        }
            break;
        case ViewCompanyAccess:
        {
            [self accessWithAttention:attentionUser finishSelector:nil];
        }
            break;
            
        default:
            break;
    }
}

- (void)callWithAttention:(AttentionUserDomain *)attentionUser {
    [_joinService countCallWithType:1 recordID:attentionUser.ProjectId direction:1 phone:attentionUser.Phone];
    [CommonUtil callWithPhone:attentionUser.Phone];
}

- (void)agreeWithAttention:(AttentionUserDomain *)attentionUser {
    NSDictionary *paramDic = @{kBidMarker: @1, kBidAttentionID: attentionUser.AttentionId};
    [_joinService modifyAttentionUserWithParameters:paramDic result:^(NSInteger code) {
        if (code == 1) {
            _page = 1;
            [self getAttentionUserList];
        }
    }];
}

- (void)disagreeWithAttention:(AttentionUserDomain *)attentionUser {
    NSDictionary *paramDic = @{kBidMarker: @0, kBidAttentionID: attentionUser.AttentionId};
    [_joinService modifyAttentionUserWithParameters:paramDic result:^(NSInteger code) {
        if (code == 1) {
            _page = 1;
            [self getAttentionUserList];
        }
    }];
}

- (void)returnWithAttention:(AttentionUserDomain *)attentionUser {
    [_joinService backAttentionUserWithParameters:@{kBidAttentionID: attentionUser.AttentionId} result:^(NSInteger code) {
        if (code == 1) {
            _page = 1;
            [self getAttentionUserList];
        }
    }];
}

- (void)accessWithAttention:(AttentionUserDomain *)attentionUser  finishSelector:(SEL)sel {
    
    [_joinService getAssesReasonWithType:1 result:^(NSArray<KeyValueDomain *> *info, NSInteger code) {
        if (code == 1) {
            [JXRatingView showInView:self.view reasons:info titleText:@"评价报名用户" rattingScore:^(CGFloat score, NSString *reason) {
                [self assessingWithAttention:attentionUser rating:score reason:reason finishSelector:sel];
            }];
        }
    }];
}

/**
 *  提交评价
 */
- (void)assessingWithAttention:(AttentionUserDomain *)attention rating:(CGFloat)rating reason:(NSString *)reason  finishSelector:(SEL)sel {
    NSDictionary *paramDic = @{kBidAttentionID: attention.AttentionId, kAssessRating: [NSString stringWithFormat:@"%.1f", rating], kAssessReason: reason};
    __block VC_ViewCompany *weakSelf = self;
    [_joinService asseseAttentionUserWithParameters:paramDic result:^(NSInteger code) {
        if (code == 1) {
            [ProgressHUD showInfo:@"评价成功" withSucc:YES withDismissDelay:1];
            if (sel == nil) {
                _page = 1;
                [self getAttentionUserList];
            } else {
                [weakSelf  performSelector:sel withObject:attention afterDelay:0.1];
            }
        }
    }];
    
}

#pragma mark - menu tap
- (void)v_new_tap:(UIGestureRecognizer *)recognizer {
    _constraint = 0;
    _selectIndex = 0;
    _page = 1;
    _marker = 2;
    [self getAttentionUserList];
}
- (void)v_agree_tap:(UIGestureRecognizer *)recognizer {
    _constraint = ScreenSize.width * (1/4.f);
    _selectIndex = 1;
    _page = 1;
    _marker = 1;
    [self getAttentionUserList];
}
- (void)v_disagree_tap:(UIGestureRecognizer *)recognizer {
    _constraint = ScreenSize.width * (1/2.f);
    _selectIndex = 2;
    _page = 1;
    _marker = 0;
    [self getAttentionUserList];
}
- (void)v_return_tap:(UIGestureRecognizer *)recognizer {
    _constraint = ScreenSize.width * (3/4.f);
    _selectIndex = 3;
    _page = 1;
    _marker = 4;
    [self getAttentionUserList];
}

- (void)scrollLine {
    [UIView animateWithDuration:0.2 animations:^{
        _layout_seperate_centerX.constant = _constraint;
        [self.view layoutIfNeeded];
    }];
    [_tableView reloadData];
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
