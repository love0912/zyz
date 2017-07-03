//
//  VC_ReleaseLetterPerform.m
//  自由找
//
//  Created by 郭界 on 16/10/17.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_ReleaseLetterPerform.h"
#import "VC_TextField.h"
#import "BidService.h"
#import "VC_Choice.h"
#import "LetterPerformDomain.h"
#import "LetterService.h"

@interface VC_ReleaseLetterPerform ()
{
    NSArray *_arr_input;
    NSMutableDictionary *_dic_data;
    BidService *_bidService;
    LetterService *_letterService;
    
    // 0 -- 新建, 1 -- 编辑
    NSInteger _type;
}
@end

@implementation VC_ReleaseLetterPerform

- (void)initData {
    _arr_input = @[
                   @{kCellKey: @"ProjectName", kCellEditType: EditType_TextField, kCellName: @"项目名称", kCellDefaultText: @"请输入履约保函的项目名称"},
                   @{kCellKey: @"Company", kCellEditType: EditType_TextField, kCellName: @"中标企业", kCellDefaultText: @"请输入您中标企业公司名称"},
                   @{kCellKey: @"OwnerName", kCellEditType: EditType_TextField, kCellName: @"业主名称", kCellDefaultText: @"请输入业主名称"},
                   @{kCellKey: @"ProjectArea", kCellEditType: EditType_RegionChoice, kCellName: @"项目所在区域", kCellDefaultText: @"请选择您项目所在区域"},
                   @{kCellKey: @"ProjectCategory", kCellEditType: EditType_ProjectType, kCellName: @"项目类别", kCellDefaultText: @"请选择项目类别"},
                   @{kCellKey: @"Amount", kCellEditType: EditType_TextField, kCellName: @"保函金额", kCellDefaultText: @"请输入保函金额"},
                   @{kCellKey: @"Period", kCellEditType: EditType_TextField, kCellName: @"保函期限", kCellDefaultText: @"请输入保函期限"},
                   @{kCellKey: @"Remark", kCellEditType: EditType_TextField, kCellName: @"备注", kCellDefaultText: @"请输入其他要求(选填)"}
                   ];
    _dic_data = [NSMutableDictionary dictionaryWithCapacity:_arr_input.count];
    _bidService = [BidService sharedService];
    _letterService = [LetterService sharedService];
    
    _type = [[self.parameters objectForKey:kPageType] integerValue];
    if (_type == 1) {
        LetterPerformDomain *letterPerform = [self.parameters objectForKey:kPageDataDic];
        letterPerform.Amount = [CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%f", (letterPerform.Amount.floatValue / 10000)]];
        [_dic_data setDictionary:[letterPerform toDictionary]];
    }
}

- (void)layoutUI {
    [self hideTableViewFooter:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"发布履约保函";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_input.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_ReleaseLetterPerform";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
    NSString *key = tmpDic[kCellKey];
    NSString *text = tmpDic[kCellDefaultText];
    cell.textLabel.text = tmpDic[kCellName];
    UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
    NSString *editType = tmpDic[kCellEditType];
    if ([EditType_Text isEqualToString:editType] || [EditType_TextField isEqualToString:editType]) {
        if (_dic_data[key] != nil && ![_dic_data[key] isEmptyString]) {
            text = _dic_data[key];
            detailTextColor = [UIColor colorWithHex:@"666666"];
            if ([key isEqualToString:@"Amount"]) {
                
                text = [text stringByAppendingString:@"万元"];
            } else if ([key isEqualToString:@"Period"]) {
                text = [text stringByAppendingString:@"天"];
            }
        }
    } else if ([EditType_RegionChoice isEqualToString:editType] || [EditType_ProjectType isEqualToString:editType]) {
        if (_dic_data[key] != nil && ![_dic_data[key] isEmptyString]) {
            text = _dic_data[key][kCommonValue];
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
    } else if ([EditType_RegionChoice isEqualToString:editType]) {
        //选择框
        [self regionChoiceWithDic:tmpDic indexPath:indexPath];
    } else if ([EditType_ProjectType isEqualToString:editType]) {
        [self projectTypeWithDic:tmpDic indexPath:indexPath];
    }
}

#pragma mark - 
- (void)textFieldWithDic:(NSDictionary *)tmpDic indexPath:(NSIndexPath *)indexPath {
    VC_TextField *vc = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_TextField"];
    vc.type = INPUT_TYPE_NORMAL;
    if ([tmpDic[kCellKey] isEqualToString:@"Amount"]) {
        vc.type = INPUT_TYPE_MONEY_WAN;
        vc.jUnit = @"万元";
    } else if ([tmpDic[kCellKey] isEqualToString:@"Period"]) {
        vc.type = INPUT_TYPE_NUMBER;
        vc.jUnit = @"天";
    }
    NSString *text = _dic_data[tmpDic[kCellKey]];
    if (text != nil && ![text.trimWhitesSpace isEmptyString]) {
        vc.text = text.trimWhitesSpace;
    }
    vc.jTitle = tmpDic[kCellDefaultText];
    vc.placeholder = tmpDic[kCellDefaultText];
    vc.inputBlock = ^(NSString *text) {
        if ([tmpDic[kCellKey] isEqualToString:@"Amount"]) {
            if ([text isEqualToString:@"0"]) {
                text = @"";
            }
        }
        [_dic_data setObject:text forKey:tmpDic[kCellKey]];
        [self reloadIndexPath:indexPath];        
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)regionChoiceWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    [_bidService getRegionToResult:^(NSArray<KeyValueDomain *> *regionList, NSInteger code) {
        if (code != 1) {
            return;
        }
        VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
        NSMutableArray *selectArray = [NSMutableArray array];
        NSString *key = dic[kCellKey];
        if (_dic_data[key] != nil) {
            [selectArray addObject:[_dic_data[key] objectForKey:kCommonKey]];
        }
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:regionList];
        KeyValueDomain *native = dataArray.firstObject;
        if ([native.Key isEqualToString:@"0"]) {
            [dataArray removeObjectAtIndex:0];
        }
        [vc_choice setDataArray:dataArray selectArray:selectArray];
        vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
            [_dic_data setObject:resultDic forKey:key];
            [self reloadIndexPath:indexPath];
        };
        [self.navigationController pushViewController:vc_choice animated:YES];
    }];
}

- (void)projectTypeWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    [_bidService getProjectTypeToResult:^(NSArray<KeyValueDomain *> *regionList, NSInteger code) {
        if (code != 1) {
            return ;
        }
        VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
        NSMutableArray *selectArray = [NSMutableArray array];
        NSString *key = dic[kCellKey];
        if (_dic_data[key] != nil) {
            [selectArray addObject:[_dic_data[key] objectForKey:kCommonKey]];
        }
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:regionList];
        KeyValueDomain *domain = dataArray.firstObject;
        if ([domain.Key isEqualToString:@"0"]) {
            [dataArray removeObject:domain];
        }
        [vc_choice setDataArray:dataArray selectArray:selectArray];
        vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
            [_dic_data setObject:resultDic forKey:key];
            [self reloadIndexPath:indexPath];
        };
        [self.navigationController pushViewController:vc_choice animated:YES];
    }];
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

- (BOOL)checkMustInput {
    LetterPerformDomain *letterPerform = [LetterPerformDomain domainWithObject:_dic_data];
    
    if (letterPerform.ProjectName == nil || [letterPerform.ProjectName isEmptyString]) {
        [ProgressHUD showInfo:@"请输入项目名" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (letterPerform.Company == nil || [letterPerform.Company isEmptyString]) {
        [ProgressHUD showInfo:@"请输入中标企业" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (letterPerform.OwnerName == nil || [letterPerform.OwnerName isEmptyString]) {
        [ProgressHUD showInfo:@"请输入业主名称" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (letterPerform.ProjectArea == nil) {
        [ProgressHUD showInfo:@"请选择区域" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (letterPerform.ProjectCategory == nil) {
        [ProgressHUD showInfo:@"请选择项目类别" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (letterPerform.Amount == nil || [letterPerform.Amount isEmptyString]) {
        [ProgressHUD showInfo:@"请输入保函金额" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (letterPerform.Period == nil || [letterPerform.Period isEmptyString]) {
        [ProgressHUD showInfo:@"请输入保函期限" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
}

- (IBAction)btn_commit_pressed:(id)sender {
    if ([self checkMustInput]) {
        LetterPerformDomain *letterPerform = [LetterPerformDomain domainWithObject:_dic_data];
        letterPerform.Amount = [CommonUtil removeFloatAllZero:[NSString stringWithFormat:@"%f", letterPerform.Amount.floatValue * 10000]];
        if (_type == 0) {
            [_letterService releaseLetterPerformByLetterDomain:letterPerform result:^(NSInteger code) {
                if (code == 1) {
                    [ProgressHUD showInfo:@"发布成功" withSucc:YES withDismissDelay:2];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LetterPerform_Refresh object:nil];
                    [self goBack];
                    if ([[self.parameters objectForKey:@"Page_Status"] integerValue] == 1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OurPublish_Refresh object:nil];
                    }
                }
            }];
        } else {
            [_letterService editLetterPerformByLetterDomain:letterPerform result:^(NSInteger code) {
                [ProgressHUD showInfo:@"修改成功" withSucc:YES withDismissDelay:2];
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OurPublish_Refresh object:nil];
                [self goBack];
                if ([[self.parameters objectForKey:@"Page_Status"] integerValue] == 1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OurPublish_Refresh object:nil];
                }
            }];
        }
    }
}

- (void)backPressed {
    NSString *title = @"您还未保存，是否保存？";
    [JAlertHelper jAlertWithTitle:title message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"保存"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self goBack];
        } else {
            [self btn_commit_pressed:nil];
        }
    }];
}
@end
