//
//  VC_ChoiceProject.m
//  自由找
//
//  Created by guojie on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_ChoiceProject.h"
#import "JoinService.h"
#import "JJDBManager.h"

@interface VC_ChoiceProject ()
{
    JoinService *_joinService;
    NSInteger _page;
    NSInteger _status;
    NSMutableArray *_arr_bids;
}

@end

@implementation VC_ChoiceProject

- (void)initData {
    _joinService = [JoinService sharedService];
    _page = 1;
    _status = 1;
    _arr_bids = [NSMutableArray array];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self getOurAttention];
    }];
}

- (void)getOurAttention {
    NSDictionary *paramDic = @{kPage: @(_page), kBidStatus: @(_status)};
    [_joinService queryAttentionBidListWithParameters:paramDic result:^(NSArray<AttentionBidDomain *> *bidList, NSInteger code) {
        [self endingMJRefreshWithTableView:_tableView];
        if (code == 1) {
            if (bidList.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (_page == 1) {
                [_arr_bids removeAllObjects];
            }
            [_arr_bids addObjectsFromArray:bidList];
            [_tableView reloadData];
            
            if (_page == 1 && _arr_bids.count == 0) {
                [JAlertHelper jAlertWithTitle:@"您没有进行中的项目，请报名后再添加项目管理!" message:nil cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                    [self goBack];
                }];
            }
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"选择项目";
    [self zyzOringeNavigationBar];
    [self initData];
    [self upRefresh];
    [self getOurAttention];
    [self hideTableViewFooter:self.tableView];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_bids.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_ChoiceProject";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    AttentionBidDomain *project = [_arr_bids objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@ %@", project.ProjectNo, project.ProjectName];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AttentionBidDomain *projectList = [_arr_bids objectAtIndex:indexPath.row];
    Project *project = [[Project alloc] initWithEntity:[NSEntityDescription entityForName:@"Project" inManagedObjectContext:[JJDBManager sharedJJDBManager].context] insertIntoManagedObjectContext:nil];
    project.userId = [CommonUtil getUserDomain].UserId;
    project.projectId = [NSNumber numberWithInteger:[projectList.ProjectId integerValue]];
    project.name = projectList.ProjectName;
    if (projectList.IsOpenPhone == 1) {
        project.phone = projectList.Phone;
    }
    self.choiceProject(project);
    [self.navigationController popViewControllerAnimated:YES];
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
