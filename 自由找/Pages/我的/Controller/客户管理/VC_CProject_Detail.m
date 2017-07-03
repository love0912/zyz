//
//  VC_CProject_Detail.m
//  自由找
//
//  Created by guojie on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_CProject_Detail.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JJDBService.h"
#import "Cell_CProjectDetail.h"

@interface VC_CProject_Detail ()
{
    NSArray *_arr_input;
}
@end

@implementation VC_CProject_Detail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
    self.jx_title = @"项目详情";
    [self zyzOringeNavigationBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:Notification_CProject_Detail_Refresh object:nil];
    _arr_input = @[
                   @[@{kCellName: @"项目编号",
                       kCellKey: @"ProjectId"},
                     @{kCellName: @"项目名称",
                       kCellKey: @"Name"},
                     @{kCellName: @"项目概述",
                       kCellKey: @"Desc"},
                     @{kCellName: @"联系人",
                       kCellKey: @"Contact"},
                     @{kCellName: @"联系电话",
                       kCellKey: @"Phone"}],
                   @[@{kCellName: @"开标时间",
                       kCellKey: @"openDate"},
                     @{kCellName: @"保证金额",
                       kCellKey: @"Money"},
                     @{kCellName: @"备注",
                       kCellKey: @"Remark"}]
                   ];
    
    _project = [self.parameters objectForKey:kPageDataDic];
}

- (void)layoutUI {
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 0.1)];
    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)refreshView:(NSNotification *)notification {
    _project = nil;
    _project = notification.object;
    [_tableView reloadData];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arr_input.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_arr_input objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_CProjectDetail";
    Cell_CProjectDetail *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.delegate = self;
    NSDictionary *tmpDic = _arr_input[indexPath.section][indexPath.row];
    NSString *key = tmpDic[kCellKey];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *name = tmpDic[kCellName];
    NSString *value = NoneText;
    if ([key isEqualToString:@"ProjectId"]) {
        value = [NSString stringWithFormat:@"%@号", _project.projectId];
    } else if ([key isEqualToString:@"Name"] && _project.name != nil) {
        value = _project.name;
    } else if ([key isEqualToString:@"Desc"] && _project.desc!=nil) {
        value = _project.desc;
    } else if ([key isEqualToString:@"Contact"] && _project.contact != nil) {
        value = _project.contact;
    } else if ([key isEqualToString:@"Phone"] && _project.phone != nil) {
        value = _project.phone;
    } else if ([key isEqualToString:@"openDate"] && _project.openDate != nil) {
        value = _project.openDate;
    } else if ([key isEqualToString:@"Money"] && _project.money != nil) {
        value = _project.money == nil ? @"暂无" : [NSString stringWithFormat:@"%@ 万元", _project.money];
    } else if ([key isEqualToString:@"Remark"] && _project.remark != nil) {
        value = _project.remark;
    }
    [dic setObject:name forKey:kCellName];
    [dic setObject:value forKey:kCellDefaultText];
    [cell configureCellWithDic:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"Cell_CProjectDetail" cacheByIndexPath:indexPath configuration:^(Cell_CProjectDetail *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    if (height < 48) {
        height = 48;
    }
    return height;
}

- (void)configureCell:(Cell_CProjectDetail *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    NSDictionary *tmpDic = _arr_input[indexPath.section][indexPath.row];
    NSString *key = tmpDic[kCellKey];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *name = tmpDic[kCellName];
    NSString *value = NoneText;
    if ([key isEqualToString:@"ProjectId"]) {
        value = [NSString stringWithFormat:@"%@号", _project.projectId];
    } else if ([key isEqualToString:@"Name"] && _project.name != nil) {
        value = _project.name;
    } else if ([key isEqualToString:@"Desc"] && _project.desc!=nil) {
        value = _project.desc;
    } else if ([key isEqualToString:@"Contact"] && _project.contact != nil) {
        value = _project.contact;
    } else if ([key isEqualToString:@"Phone"] && _project.phone != nil) {
        value = _project.phone;
    } else if ([key isEqualToString:@"openDate"] && _project.openDate != nil) {
        value = _project.openDate;
    } else if ([key isEqualToString:@"Money"] && _project.money != nil) {
        value = _project.money;
    } else if ([key isEqualToString:@"Remark"] && _project.remark != nil) {
        value = _project.remark;
    }
    [dic setObject:name forKey:kCellName];
    [dic setObject:value forKey:kCellDefaultText];
    [cell configureCellWithDic:dic];
}

- (void)phone {
    if (_project.phone != nil && ![_project.phone isEqualToString:@""]) {
        [CommonUtil callWithPhone:_project.phone];
    } else {
        [ProgressHUD showInfo:@"您未输入电话" withSucc:NO withDismissDelay:2];
    }
}

- (void)message {
    if (_project.phone != nil && ![_project.phone isEqualToString:@""]) {
        [self showMessageView:@[_project.phone] title:@"" body:@""];
    }
}

- (void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - message delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
        {
            //成功
            [ProgressHUD showInfo:@"发送成功" withSucc:YES withDismissDelay:1];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case MessageComposeResultFailed:
        {
            //失败
            [ProgressHUD showInfo:@"发送失败" withSucc:YES withDismissDelay:1];
            
        }
            break;
        case MessageComposeResultCancelled:
            //用户取消发送
            break;
        default:
            break;
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

- (IBAction)btn_edit_pressed:(id)sender {
    NSDictionary *tmpDic = @{kPageType: @1, kPageDataDic: _project};
    [PageJumpHelper pushToVCID:@"VC_AddProject" storyboard:Storyboard_Mine parameters:tmpDic parent:self];
}

- (IBAction)btn_delete_pressed:(id)sender {
    [JAlertHelper jSheetWithTitle:@"确定删除？" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"删除" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            if ([[JJDBService sharedJJDBService] removeProjectByProjectId:[NSString stringWithFormat:@"%@", _project.projectId] userId:[CommonUtil getUserDomain].UserId]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CProject_Refresh object:nil];
                [ProgressHUD showInfo:@"删除成功" withSucc:YES withDismissDelay:1];
                [self goBack];
            } else {
                [ProgressHUD showInfo:@"删除失败,请稍后重试" withSucc:NO withDismissDelay:2];
            }
        }
    }];
}
@end
