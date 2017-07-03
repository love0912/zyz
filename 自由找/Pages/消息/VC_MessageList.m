//
//  VC_MessageList.m
//  自由找
//
//  Created by xiaoqi on 16/6/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_MessageList.h"
#import "Cell_Message.h"
#import "MessageService.h"
#import "MessageDomain.h"
#import "VC_MainTab.h"
static NSString *CellIdentifier = @"CellMessageIdentifier";
@interface VC_MessageList (){
    CGFloat _cellHeight;
    MessageService *_messageService;
    int _page;
     BOOL _firstEnter;
    NSMutableArray *_messageArray;
}

@end

@implementation VC_MessageList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"消息";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessage) name:@"RE_LOGIN_NOTIFICATION" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMessage) name:@"LOGOUT_CLEAR_MESSAGE" object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_firstEnter) {
        if ([CommonUtil isLogin]) {
            [self downRefresh];
            _firstEnter = NO;
        } else {
            [PageJumpHelper presentLoginVCWithParameter:@{kPageType: @2}];
            
            [self removeNotification];
            [self addNotification];
        }
    }
}
-(void)layoutUI{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"message_right"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItem_press)];
    rightItem.tintColor=[UIColor whiteColor];
    [self setNavigationBarRightItem:rightItem];
    [self upRefresh];
//    [self downRefresh];
}
- (void)clearMessage {
    _firstEnter = YES;
    _page = 1;
    [_messageArray removeAllObjects];
    [_tableView reloadData];
}
- (void)refreshMessage {
    _page = 1;
    [self requestMessages];
}
-(void)initData{
    if (IS_IPHONE_6P) {
        _cellHeight = 77;
    } else if (IS_IPHONE_4_OR_LESS) {
        _cellHeight = 50;
    } else {
        _cellHeight = 70;
    }
    _page = 1;
    _firstEnter = YES;
    _messageArray=[[NSMutableArray alloc]init];
    _messageService=[MessageService sharedService];
    [self hideTableViewFooter:_tableView];
    
}
-(void)rightItem_press{
    __block VC_MessageList *weakSelf = self;
    [JAlertHelper jSheetWithTitle:@"" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"全部标记已读" OtherButtonsArray:@[@"删除所有会话"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            //全部已读
            [_messageService setMessageReadedByID:0 success:^(NSInteger code) {
                if (code == 1) {
                    _page = 1;
                    [weakSelf requestMessages];
                    [CommonUtil setMsgCount:0];
                }
            }];
            
        } else if (buttonIndex == 2) {
            //删除全部
            [_messageService deleteMessageByID:0 success:^(NSInteger code) {
                if (code == 1) {
                    [_messageArray removeAllObjects];
                    [CommonUtil setMsgCount:0];
                    [_tableView reloadData];
                }
            }];
        }
    }];
}
//下拉刷新
- (void)downRefresh
{
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self requestMessages];
    }];
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}
//上拉加载更多
- (void)upRefresh
{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self requestMessages];
    }];

}

- (void)requestMessages {
    NSDictionary *paramDic = @{kPage:@(_page)};
//    NSDictionary *dic=@{kCondition: [paramDic JSONStringRepresentation]};
    [_messageService requestMessages:paramDic success:^(NSArray<MessageDomain *> *messagedomain, NSInteger code) {
        [self endingMJRefreshWithTableView:_tableView];
        if (code != 1) {
            return ;
        }
        if (_page==1) {
            [_messageArray removeAllObjects];
        }
        if (messagedomain.count==0) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_messageArray addObjectsFromArray:messagedomain];
            [_tableView reloadData];

        }
    }];

}
#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     MessageDomain *domain = [_messageArray objectAtIndex:indexPath.row];
    Cell_Message*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    cell.messagedomain=domain;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     MessageDomain *domain = [_messageArray objectAtIndex:indexPath.row];
    if ([domain.State isEqualToString:@"USED"]) {
        Cell_Message *cell = (Cell_Message *)[tableView cellForRowAtIndexPath:indexPath];
        
        [_messageService setMessageReadedByID:domain.Id success:^(NSInteger code) {
            if (code == 1) {
                //设置为已读
                domain.State = @"CLOSED";
                [cell setReadedStatus];
                [CommonUtil subMsgCount];
            }
            
        }];
    }
    
    NSInteger type = [domain.RelevancyType integerValue];
    switch (type) {
        case 14:
            //有新项目
            [self jumpToBidDetailWithID:domain.RelevancyId];
            break;
        case 16:
            //有新项目
            [self jumpToBidDetailWithID:domain.RelevancyId];
            break;
        case 101:
            [self jumpToTech];
            break;
        case 102:
            [self jumpToBudge];
            break;
        default:
            break;
    }
}

- (void) jumpToTech {
    [PageJumpHelper pushToVCID:@"VC_Technology" storyboard:Storyboard_Main parameters:@{kPageType:@1} parent:self];
}

- (void)jumpToBudge {
    [PageJumpHelper pushToVCID:@"VC_Budget" storyboard:Storyboard_Main parameters:@{kPageType:@1} parent:self];
}

- (void)jumpToBidDetailWithID:(NSString *)projectID {
//    [PageJumpHelper pushToVCID:@"VC_Bid_Detail" storyboard:Storyboard_Main parameters:@{kPageDataDic: projectID} parent:self];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView

           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MessageDomain *messageDomain = _messageArray[indexPath.row];
        [_messageService deleteMessageByID:messageDomain.Id success:^(NSInteger code) {
            if (code==1) {
                if ([messageDomain.State isEqualToString:@"USED"]) {
                    [CommonUtil subMsgCount];
                }
                [_messageArray removeObjectAtIndex:indexPath.row];
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView endUpdates];
            }
            [ProgressHUD showInfo:@"删除成功" withSucc:YES withDismissDelay:1];
        }];
  }
}
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelectViewController) name:@"USERNOTLOGINNOTIFICATION" object:nil];
}
- (void)changeSelectViewController {
    VC_MainTab *tabbarController = (VC_MainTab *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabbarController setSelectedIndex:[CommonUtil getSelectIndex]];
}
- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"USERNOTLOGINNOTIFICATION" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeNotification];
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
