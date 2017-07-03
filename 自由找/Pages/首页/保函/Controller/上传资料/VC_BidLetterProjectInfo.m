//
//  VC_BidLetterProjectInfo.m
//  zyz
//
//  Created by 郭界 on 16/11/1.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_BidLetterProjectInfo.h"
#import "VC_TextField.h"
#import "LetterOrderDetailDomain.h"
#import "LetterService.h"
#import "BSModalDatePickerView.h"

@interface VC_BidLetterProjectInfo ()
{
    NSArray *_arr_input;
    NSMutableDictionary *_dic_data;
    LetterOrderDetailDomain *_letterDetail;
    NSInteger _type;
    LetterService *_letterService;
}
@end

@implementation VC_BidLetterProjectInfo

- (void)initData {
    _letterService = [LetterService sharedService];
    _arr_input = @[
                   @{kCellKey: @"ProjectOwner", kCellEditType: EditType_TextField, kCellName: @"招标人", kCellDefaultText: @"请输入招标人单位名称"},
                   @{kCellKey: @"ProjectCompany", kCellEditType: EditType_TextField, kCellName: @"投标企业", kCellDefaultText: @"请输入投标企业名称"},
                   @{kCellKey: @"ProjectTitle", kCellEditType: EditType_TextField, kCellName: @"项目名称", kCellDefaultText: @"请输入项目名称"},
                   @{kCellKey: @"MaterialDt", kCellEditType: EditType_DatePicker, kCellName: @"自由找\n提交保函时间", kCellDefaultText: @"您需要自由找最迟提交保函时间"}
                   ];
    _dic_data = [NSMutableDictionary dictionary];
    _letterDetail = [self.parameters objectForKey:kPageDataDic];
    _type = [[self.parameters objectForKey:kPageType] integerValue];
    if (_letterDetail != nil) {
        [_dic_data setDictionary:[_letterDetail toDictionary]];
    }
}

- (void)layoutUI {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"项目信息";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_input.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_ProjectInfo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
    NSString *key = tmpDic[kCellKey];
    NSString *text = tmpDic[kCellDefaultText];
    cell.textLabel.text = tmpDic[kCellName];
    UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
    NSString *editType = tmpDic[kCellEditType];
    if ([EditType_TextField isEqualToString:editType] || [EditType_DatePicker isEqualToString:editType] ) {
        if (_dic_data[key] != nil && ![_dic_data[key] isEmptyString]) {
            text = _dic_data[key];
            detailTextColor = [UIColor colorWithHex:@"666666"];
        }
    }
    cell.detailTextLabel.text = text;
    cell.detailTextLabel.textColor = detailTextColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
    NSString *editType = tmpDic[kCellEditType];
    if ([EditType_TextField isEqualToString:editType]) {
        [self textFieldWithDic:tmpDic indexPath:indexPath];
    } else if ([EditType_DatePicker isEqualToString:editType]) {
        [self deadLineWithDic:tmpDic indexPath:indexPath];
    }
}

#pragma mark -
- (void)deadLineWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    NSString *key = dic[kCellKey];
    BSModalDatePickerView *datePicker = [[BSModalDatePickerView alloc] initWithDate:[NSDate date]];
    datePicker.mode = UIDatePickerModeDate;
    NSString *selectDate = _dic_data[key];
    if (selectDate != nil && ![selectDate isEmptyString]) {
        datePicker.selectedDate = [CommonUtil dateFromString:_dic_data[dic[kCellKey]]];
    }
    [datePicker presentInWindowWithBlock:^(BOOL madeChoice) {
        if (madeChoice) {
            NSTimeInterval time = [datePicker.selectedDate timeIntervalSinceNow];
            if (time < -80000) {
                [ProgressHUD showInfo:@"不能小于当前日期" withSucc:NO withDismissDelay:2];
                return;
            }
            [_dic_data setObject:[CommonUtil stringFromDate:datePicker.selectedDate] forKey:dic[kCellKey]];
            [self reloadIndexPath:indexPath];
        }
    }];
}

- (void)textFieldWithDic:(NSDictionary *)tmpDic indexPath:(NSIndexPath *)indexPath {
    VC_TextField *vc = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_TextField"];
    vc.type = INPUT_TYPE_NORMAL;
    NSString *text = _dic_data[tmpDic[kCellKey]];
    if (text != nil && ![text.trimWhitesSpace isEmptyString]) {
        vc.text = text.trimWhitesSpace;
    }
    vc.jTitle = tmpDic[kCellDefaultText];
    vc.placeholder = tmpDic[kCellDefaultText];
    vc.inputBlock = ^(NSString *text) {
        [_dic_data setObject:text forKey:tmpDic[kCellKey]];
        [self reloadIndexPath:indexPath];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)reloadIndexPath:(NSIndexPath *)indexPath {
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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

- (IBAction)btn_next_pressed:(id)sender {
    if ([self checkInput]) {
        [CountUtil countBidLetterProjectInfo];
        
        _letterDetail = [LetterOrderDetailDomain domainWithObject:_dic_data];
        NSArray *imgUrls = [NSArray arrayWithArray:_letterDetail.MaterialList];
        [_letterService uploadLetterOrderInfo:_letterDetail imageUrls:imgUrls result:^(NSInteger code) {
            if (code == 1) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OurOrder_Refresh object:nil];
                //更新详情页信息
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_Refresh_LetterDetail" object:nil];
                if (_letterDetail.MaterialList.count > 0) {
                    [PageJumpHelper pushToVCID:@"VC_UploadedImage" storyboard:Storyboard_Main parameters:@{kPageDataDic: _letterDetail} parent:self];
                } else {
                    [PageJumpHelper pushToVCID:@"VC_UploadData" storyboard:Storyboard_Main parameters:@{kPageDataDic: _letterDetail, kPageType: @(_type)} parent:self];
                }
            }
        }];
    }
}

- (BOOL)checkInput {
    if (_dic_data[@"ProjectOwner"] == nil || [_dic_data[@"ProjectOwner"] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入招标人单位名称" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[@"ProjectCompany"] == nil || [_dic_data[@"ProjectCompany"] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入投标企业" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[@"ProjectTitle"] == nil || [_dic_data[@"ProjectTitle"] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入项目名称" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[@"MaterialDt"] == nil || [_dic_data[@"MaterialDt"] isEmptyString]) {
        [ProgressHUD showInfo:@"请选择提交时间" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
}

- (void)backPressed {
    if (_type == 1) {
        [JAlertHelper jAlertWithTitle:@"您还没有填写并上传资料？该信息是开具保函时必须的信息！" message:nil cancleButtonTitle:@"继续填写" OtherButtonsArray:@[@"确认离开"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [PageJumpHelper pushToVCID:@"VC_MineOrders" storyboard:Storyboard_Mine parameters:@{kPageType:@4} parent:self];
            }
        }];
    } else if (_type == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_Refresh_LetterDetail" object:nil];
        NSArray *vcs = self.navigationController.viewControllers;
        if (vcs.count > 2) {
            UIViewController *vc = [vcs objectAtIndex:vcs.count - 3];
            [self.navigationController popToViewController:vc animated:YES];
        }
        
    } else {
        [self goBack];
    }
}

@end
