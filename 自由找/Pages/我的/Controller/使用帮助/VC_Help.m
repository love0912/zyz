//
//  VC_Help.m
//  自由找
//
//  Created by guojie on 16/7/15.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Help.h"
#import "HelpService.h"

//如何设置所在企业
//#define Help_SetCompany @"Help_SetCompany"
////如何更正所在企业信息
//#define Help_ModifyCompany @"Help_ModifyCompany"
////如何合作报名
//#define Help_Attention @"Help_Attention"
////资质需求发布者如何联系报名者
//#define Help_Contact_Attention @"Help_Contact_Attention"
////合作报名者如何联系资质需求发布者
//#define Help_Contact_Release @"Help_Contact_Release"

@interface VC_Help ()
{
    NSMutableArray *_arr_help;
    HelpService *_helpService;
}
@end

@implementation VC_Help

- (void)initData {
//    _arr_input = @[
//                   @{kCellName: @"如何设置所在企业", kCellKey:Help_SetCompany},
//                   @{kCellName: @"如何更正所在企业信息", kCellKey:Help_ModifyCompany},
//                   @{kCellName: @"如何合作报名", kCellKey:Help_Attention},
//                   @{kCellName: @"资质需求发布者如何联系报名者", kCellKey:Help_Contact_Attention},
//                   @{kCellName: @"合作报名者如何联系资质需求发布者", kCellKey:Help_Contact_Release}
//                   ];
    _arr_help = [NSMutableArray array];
    _helpService = [HelpService sharedService];
    
    [_helpService getHelpPageToResult:^(NSArray *arr_help, NSInteger code) {
        if (code == 1) {
            [_arr_help addObjectsFromArray:arr_help];
            [_tabeView reloadData];
        } else {
            [ProgressHUD showInfo:@"获取帮助信息失败，请稍后重试!" withSucc:NO withDismissDelay:2];
            [self goBack];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"使用帮助";
    [self zyzOringeNavigationBar];
    [self initData];
    
    [self hideTableViewFooter:_tabeView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_help.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_Help";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *tmpDic = [_arr_help objectAtIndex:indexPath.row];
    cell.textLabel.text = tmpDic[kCommonKey];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arr_help objectAtIndex:indexPath.row];
    if (tmpDic[kCommonValue] == nil || [tmpDic[kCommonValue] isEmptyString]) {
        [ProgressHUD showInfo:@"获取帮助详情失败，请稍后重试" withSucc:NO withDismissDelay:2];
    } else {
        [PageJumpHelper pushToVCID:@"VC_HelpDetail" storyboard:Storyboard_Mine parameters:@{@"Name": tmpDic[kCommonKey], @"Url": tmpDic[kCommonValue]} parent:self];
    }
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
