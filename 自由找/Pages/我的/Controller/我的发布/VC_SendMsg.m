//
//  VC_SendMsg.m
//  自由找
//
//  Created by guojie on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_SendMsg.h"
#import "JoinService.h"

@interface VC_SendMsg ()
{
    NSInteger _page;
    NSMutableArray *_arr_person;
    NSMutableArray *_arr_phones;
    JoinService *_joinService;
}
@end

@implementation VC_SendMsg

- (void)initData {
    _projectId = [self.parameters objectForKey:kPageDataDic];
    _joinService = [JoinService sharedService];
    _page = 1;
    _arr_person = [NSMutableArray array];
    _arr_phones = [NSMutableArray array];
    
    if (_projectId != nil) {
        [self requestFocusUser];
    }
}

- (void)layoutUI {
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendMsg)];
    [self setNavigationBarRightItem:sendItem];
    [self upRefresh];
}

- (void)requestFocusUser {
    NSDictionary *paramDic = @{kPage: @(_page), kBidProjectID: _projectId, kBidMarker: @(3)};;
    [_joinService queryAttentionUserListWithParameters:paramDic result:^(AttentionUserList *userList, NSInteger code) {
        [self endingMJRefreshWithTableView:self.tableView];
        if (code != 1) {
            return ;
        }
        if (_page == 1) {
            [_arr_person removeAllObjects];
        }
        [_arr_person addObjectsFromArray:userList.Items];
        [_tableView reloadData];
        
        if (userList.Items.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self requestFocusUser];
    }];
}
- (void)sendMsg {
    if (_arr_phones.count == 0) {
        [ProgressHUD showInfo:@"您还未选择联系人" withSucc:NO withDismissDelay:2];
    } else {
        [self showMessageView:_arr_phones title:@"" body:_tv_content.text];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"输入内容，选择联系人";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - tableview 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_person.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_Person";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    AttentionUserDomain *user = _arr_person[indexPath.row];
    cell.textLabel.text = user.CompanyName;
    if ([_arr_phones indexOfObject:user.Phone] == NSNotFound) {
        cell.accessoryView = [self noneImageView];
    } else {
        cell.accessoryView = [self selectImageView];
    }
    return cell;
}

- (UIImageView *)selectImageView {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sendmsg_sel"]];
}

- (UIImageView *)noneImageView {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sendmsg_none"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tv_content resignFirstResponder];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    AttentionUserDomain *user = _arr_person[indexPath.row];
    if ([_arr_phones indexOfObject:user.Phone] == NSNotFound) {
        cell.accessoryView = [self selectImageView];
        [_arr_phones addObject:user.Phone];
    } else {
        cell.accessoryView = [self noneImageView];
        [_arr_phones removeObject:user.Phone];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"选择联系人";
    }
    return @"";
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_tv_content resignFirstResponder];
}

#pragma mark - send message
- (void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        //        controller.navigationBar.tintColor = [UIColor orangeColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        //        [[[controller viewControllers] lastObject] navigationItem].title = title;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

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

#pragma mark - textview
- (void)textViewDidChange:(UITextView *)textView {
    if (textView == _tv_content) {
        if (_tv_content.text.length > 0) {
            _lb_tips.hidden = YES;
        } else {
            _lb_tips.hidden = NO;
        }
    }
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
