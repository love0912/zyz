//
//  VC_Score.m
//  自由找
//
//  Created by guojie on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Score.h"
#import "MineService.h"
//获取积分
#define CellGetScore @"GetScore"
//消费积分
#define CellOutScore @"OutScore"
//积分规则
#define CellScoreRule @"ScoreRule"

@interface VC_Score ()
{
    NSArray *_arr_menu;
    MineService *_mineService;
}
@end

@implementation VC_Score

- (void)initData {
    _arr_menu = @[
                  @{kCellName: @"获取积分", kCellKey: CellGetScore, kCellDefaultText: @"查看明细"},
                  @{kCellName: @"消费积分", kCellKey: CellOutScore, kCellDefaultText: @"查看明细"},
                  @{kCellName: @"积分规则", kCellKey: CellScoreRule, kCellDefaultText: @"查看积分规则"}
                  ];
    
    _mineService = [MineService sharedService];
    [ProgressHUD showProgressHUDWithInfo:@""];
    [_mineService autoLoginToresult:^(UserDomain *user, NSInteger code) {
        [ProgressHUD hideProgressHUD];
        if (code == 1) {
            [CommonUtil saveUserDomian:user];
        } else {
            [ProgressHUD showInfo:@"更新积分失败！" withSucc:NO withDismissDelay:2];
        }
        _lb_score.text = [CommonUtil getUserDomain].Score;
    }];
}

- (void)layoutUI {
    CGFloat height = 227;
    if (IS_IPHONE_4_OR_LESS) {
        height = 200;
        _layout_score_top.constant = 20;
    } else if (IS_IPHONE_6P) {
        _layout_score_top.constant = 50;
        height = 247;
    }
    _v_header.frame = CGRectMake(0, 0, ScreenSize.width, height);
    [self hideTableViewFooter:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_navigationBar.hidden = YES;
    [self initData];
    [self layoutUI];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_menu.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_Score";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *tmpDic = [_arr_menu objectAtIndex:indexPath.row];
    cell.textLabel.text = tmpDic[kCellName];
    cell.detailTextLabel.text = tmpDic[kCellDefaultText];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arr_menu objectAtIndex:indexPath.row];
    NSString *key = tmpDic[kCellKey];
    if ([CellGetScore isEqualToString:key]) {
        [PageJumpHelper pushToVCID:@"VC_ScoreDetail" storyboard:Storyboard_Mine parameters:@{kPageType: @1} parent:self];
    } else if ([CellOutScore isEqualToString:key]) {
        [PageJumpHelper pushToVCID:@"VC_ScoreDetail" storyboard:Storyboard_Mine parameters:@{kPageType: @2} parent:self];
    } else {
        [CommonUtil showScoreRuleInController:self];
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

- (IBAction)btn_back_pressed:(id)sender {
    [self goBack];
}
@end
