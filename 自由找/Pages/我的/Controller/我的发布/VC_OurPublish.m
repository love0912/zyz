//
//  VC_OurPublish.m
//  自由找
//
//  Created by guojie on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_OurPublish.h"
#import "JoinService.h"
#import "BidService.h"
#import "LetterService.h"

@interface VC_OurPublish ()
{
    JoinService *_joinService;
    BidService *_bidService;
    NSInteger _page;
    NSMutableArray *_arr_ourPublish;
    BOOL _is401Error;
    
    LetterService *_letterService;
}
@end

@implementation VC_OurPublish

- (void)initData {
    _joinService = [JoinService sharedService];
    _bidService = [BidService sharedService];
    _page = 1;
    _arr_ourPublish = [NSMutableArray array];
    _is401Error = NO;
    
    _letterService = [LetterService sharedService];
}

- (void)layoutUI {
    [self downRefresh];
    [self upRefresh];
    NSString *text = @"当前没发布保函需求，请前往”银行保函“发布！";
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[CommonUtil zyzOrangeColor] range:NSMakeRange(13,6)];
    _lb_tips.attributedText = attributeString;
    _lb_tips.userInteractionEnabled = YES;
    [_lb_tips addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toReleaseBid)]];
}

- (void)toReleaseBid {
    [PageJumpHelper pushToVCID:@"VC_ReleaseLetterPerform" storyboard:Storyboard_Main parameters:@{@"Page_Status": @1} parent:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOurPublish) name:Notification_OurPublish_Refresh object:nil];
    
    self.jx_title = @"我的发布";
    [self zyzOringeNavigationBar];
    
    [self initData];
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self statusBarLightContent];
    
    if (_is401Error) {
        if ([CommonUtil isLogin]) {
            [self refreshOurPublish];
        } else {
            [self goBack];
        }
    }
}

- (void)refreshOurPublish {
    self.tableView.hidden = NO;
    [self.tableView.mj_header beginRefreshing];
}

//下拉刷新
- (void)downRefresh
{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getOurPublish];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self getOurPublish];
    }];
}

- (void)getOurPublish {
//    _is401Error = NO;
//    [_joinService queryOurIssueBidWithParameters:@{kPage: @(_page)} result:^(NSArray<BidListDomain *> *bidList, NSInteger code) {
//        [self endingMJRefreshWithTableView:_tableView];
//        if (code == 1) {
//            if (_page == 1) {
//                [_arr_ourPublish removeAllObjects];
//                if (bidList.count == 0) {
//                    _tableView.hidden = YES;
//                    _lb_tips.hidden=NO;
//                    _image_none.hidden=NO;
//                } else {
//                    _tableView.hidden = NO;
//                    _lb_tips.hidden=YES;
//                    _image_none.hidden=YES;
//                }
//            }
//            [_arr_ourPublish addObjectsFromArray:bidList];
//            [self.tableView reloadData];
//            if (bidList.count == 0) {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        } else if (code == 401) {
//            _is401Error = YES;
//        }
//    }];
    
    _is401Error = NO;
    [_letterService getOurPublishWityPage:_page result:^(NSInteger code, NSArray *list) {
        [self endingMJRefreshWithTableView:_tableView];
        if (code == 1) {
            if (_page == 1) {
                [_arr_ourPublish removeAllObjects];
                if (list.count == 0) {
                    _tableView.hidden = YES;
                    _lb_tips.hidden=NO;
                    _image_none.hidden=NO;
                } else {
                    _tableView.hidden = NO;
                    _lb_tips.hidden=YES;
                    _image_none.hidden=YES;
                }
            }
//            [_arr_ourPublish addObjectsFromArray:bidList];
            [self handleDataWithArray:list];
            
            
            [self.tableView reloadData];
            if (list.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else if (code == 401) {
            _is401Error = YES;
        }

    }];
}

- (void)handleDataWithArray:(NSArray *)list {
    for (NSDictionary *tmpDic in list) {
        NSString *type = tmpDic[@"Type"];
        if ([type isEqualToString:@"1"]) {
            //投标合作
//            BidListDomain *bidList = [BidListDomain domainWithObject:tmpDic];
//            [_arr_ourPublish addObject:bidList];
        } else {
            //履约保函
            LetterPerformDomain *letterPerform = [LetterPerformDomain domainWithObject:tmpDic];
            [_arr_ourPublish addObject:letterPerform];
        }
    }
}

#pragma mark - uitableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_ourPublish.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_OurPublish";
    Cell_OurPublish *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.delegate = self;
    static NSString *CellID2 = @"Cell_OurPublisLetterPerform";
    Cell_OurPublisLetterPerform *cell2 = [tableView dequeueReusableCellWithIdentifier:CellID2];
    cell2.delegate = self;
    BaseDomain *obj = [_arr_ourPublish objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[BidListDomain class]]) {
        cell.bidList = (BidListDomain *)obj;
        return cell;
    } else {
        cell2.letterPerform = (LetterPerformDomain *)obj;
        return cell2;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseDomain *obj = [_arr_ourPublish objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[BidListDomain class]]) {
//        BidListDomain *bidList = (BidListDomain *)obj;
//        [PageJumpHelper pushToVCID:@"VC_Bid_Detail" storyboard:Storyboard_Main parameters:@{kPageDataDic: bidList.ProjectId} parent:self];
    } else {
        LetterPerformDomain *letterPerform = (LetterPerformDomain *)obj;
        [PageJumpHelper pushToVCID:@"VC_LetterPerformDetail" storyboard:Storyboard_Main parameters:@{kPageDataDic:letterPerform} parent:self];
    }
    
    
//    BidListDomain *bidList = [_arr_ourPublish objectAtIndex:indexPath.row];
//    [PageJumpHelper pushToVCID:@"VC_Bid_Detail" storyboard:Storyboard_Main parameters:@{kPageDataDic: bidList.ProjectId} parent:self];
}

#pragma mark - cell button click
- (void)clickWithBidList:(BidListDomain *)bidList type:(OurPublishType)type {
    switch (type) {
        case OurPublishDelete:
            [self deleteBidList:bidList];
            break;
        case OurPublishEdit:
            [self editBidList:bidList];
            break;
        case OurPublishExportCompany:
            [self exportCompanyBidList:bidList];
            break;
        case OurPublishViewCompany:
            [self viewCompanyBidList:bidList];
            break;
        default:
            break;
    }
}

- (void)deleteBidList:(BidListDomain *)bidList {
    NSString *title = [NSString stringWithFormat:@"确定删除%@项目", bidList.ProjectNo];
    [JAlertHelper jAlertWithTitle:title message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"删除"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        //删除
        if (buttonIndex == 1) {
            NSDictionary *paramDic = @{kBidProjectID: bidList.ProjectId};
            [_joinService delIssueBidWithParameters:paramDic result:^(NSInteger code) {
                if (code == 1) {
                    //更新列表
                    [_arr_ourPublish removeObject:bidList];
                    [_tableView reloadData];
                }
            }];
        }
    }];
    
    
    
}

- (void)editBidList:(BidListDomain *)bidList {
    [_bidService queryBidDetailWithParameters:@{kBidProjectID: bidList.ProjectId} result:^(NSDictionary *bidDic, NSInteger code) {
        //        VC_PublishBid *vc_publishBid = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_PublishBid"];
        //        vc_publishBid.type = 1;
        //        vc_publishBid.dataDic = [bid toDictionary];
        //        [self.navigationController pushViewController:vc_publishBid animated:YES];
        if (code != 1) {
            return ;
        }
        
        [PageJumpHelper pushToVCID:@"VC_PublishBid" storyboard:Storyboard_Main parameters:@{kPageType: @(1), @"DataDic": bidDic} parent:self];
        
    }];
}

- (void)exportCompanyBidList:(BidListDomain *)bidList {
    [_joinService exportAttentionUserWithProjectID:bidList.ProjectId result:^(NSArray<ExpCompanyDomain *> *attentionUser, NSInteger code) {
        if (code == 1) {
            if (attentionUser.count == 0) {
                [ProgressHUD showInfo:@"暂时还没有用户报名" withSucc:NO withDismissDelay:2];
            } else {
                NSString *title = [NSString stringWithFormat:@"%@-%@", bidList.ProjectNo, bidList.ProjectName];
                NSDictionary *parameters = @{kExportType: @"1", kExportArray: attentionUser, kExportTitle: title};
                [PageJumpHelper pushToVCID:@"VC_Export" storyboard:Storyboard_Mine parameters:parameters parent:self];
            }
        }
    }];
}

- (void)viewCompanyBidList:(BidListDomain *)bidList {
    [CommonUtil subMineCount:bidList.SignUpUnread];
    bidList.SignUpUnread = 0;
    [_tableView reloadData];
    [PageJumpHelper pushToVCID:@"VC_ViewCompany" storyboard:Storyboard_Mine parameters:@{kBidProjectID: bidList.ProjectId} parent:self];
}



#pragma mark - letterPerform 
- (void)clickWithLetterPerform:(LetterPerformDomain *)letterPerform type:(OurPublisLetterPerformType)type {
    if (OurPublisLetterPerform_Delete == type) {
        [self deleteLetterPerform:letterPerform];
    } else if (OurPublisLetterPerform_Edit == type) {
        [self editLetterPerform:letterPerform];
    } else {
        //完成
        [self finishLetterPerform:letterPerform];
    }
}

- (void)deleteLetterPerform:(LetterPerformDomain *)letterPerform {
    [JAlertHelper jAlertWithTitle:@"确定删除？" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"删除"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [_letterService deleteLetterPerformByID:letterPerform.SerialNo result:^(NSInteger code) {
                if (code == 1) {
                    //更新列表
                    [ProgressHUD showInfo:@"删除成功" withSucc:YES withDismissDelay:2];
                    [_arr_ourPublish removeObject:letterPerform];
                    [_tableView reloadData];
                    if (_arr_ourPublish.count == 0) {
                        _tableView.hidden = YES;
                    }
                }
            }];
        }
    }];
}

- (void)editLetterPerform:(LetterPerformDomain *)letterPerform {
    [PageJumpHelper pushToVCID:@"VC_ReleaseLetterPerform" storyboard:Storyboard_Main parameters:@{kPageType: @1, kPageDataDic: letterPerform} parent:self];
}

- (void)finishLetterPerform:(LetterPerformDomain *)letterPerform {
    [JAlertHelper jAlertWithTitle:@"确定完成项目?" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"确定"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [_letterService finishLetterPerformByID:letterPerform.SerialNo result:^(NSInteger code) {
                if (code == 1) {
                    [ProgressHUD showInfo:@"项目已完成" withSucc:YES withDismissDelay:2];
                    [self refreshOurPublish];
                }
            }];
        }
    }];
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

@end
