//
//  VC_NewCompanyPerformance.m
//  zyz
//
//  Created by 郭界 on 16/12/26.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_NewCompanyPerformance.h"
#import "BSModalDatePickerView.h"
#import "HooDatePicker.h"
#import "NewQueryService.h"
#import "VC_Choice.h"


/** 时间段 */
#define kSinceDt @"SinceDt"
#define kEndDt @"EndDt"
/** 工程类别 */
#define kProjectCategory @"ProjectCategory"
/** 工程用途 */
#define kProjectApplication @"ProjectApplication"
/** 数量 */
#define kProjectQty @"ProjectQty"
/** 业绩规模 */
#define kProjectSize @"ProjectSize"
/** 业绩规模单位 */
#define kProjectUnit @"ProjectUnit"




@interface VC_NewCompanyPerformance ()<HooDatePickerDelegate>
{
    NSMutableArray *_arr_Input;
    NSInteger _btnCountSelectTag;
    NSInteger _projectCount;
    NewQueryService *_queryService;
    NSDictionary *_unitDic;
    UITextField *_inputingTextField;
    
    BOOL _isBeginDate;
    
}
@end

@implementation VC_NewCompanyPerformance

- (void)setDic_PerformanceInfo:(NSMutableDictionary *)dic_PerformanceInfo {
    _dic_PerformanceInfo = [NSMutableDictionary dictionaryWithDictionary:dic_PerformanceInfo];
}

- (void)initData {
    _arr_Input = [NSMutableArray arrayWithObjects:
//                  @{kCellKey: kSinceDt, kCellName: @"中标时间段", kCellDefaultText: @"请选择起始", kCellEditType: EditType_DatePicker},
//                  @{kCellKey: kProjectCategory, kCellName: @"工程类别", kCellDefaultText: @"请选择工程类别", kCellEditType: EditType_KeyValueChoice},
                  @{kCellKey: kProjectApplication, kCellName: @"工程用途", kCellDefaultText: @"请选择工程用途", kCellEditType: EditType_KeyValueChoice}, nil];
    _queryService = [NewQueryService sharedService];
    if (_dic_PerformanceInfo == nil) {
        _dic_PerformanceInfo = [NSMutableDictionary dictionary];
    }
    _unitDic = _dic_PerformanceInfo[kProjectUnit];
}

- (void)layoutUI {
    _tf_count.hidden = YES;
    
    if (_dic_PerformanceInfo.count == 0) {
        _btnCountSelectTag = 1001;
        _btn_count_1.selected = YES;
        _projectCount = 1;
    } else {
        if (_dic_PerformanceInfo[kSinceDt] != nil) {
            [_btn_beginDate setTitle:_dic_PerformanceInfo[kSinceDt] forState:UIControlStateNormal];
        }
        if (_dic_PerformanceInfo[kEndDt] != nil) {
            [_btn_endDate setTitle:_dic_PerformanceInfo[kEndDt] forState:UIControlStateNormal];
        }
        
        NSInteger count = [_dic_PerformanceInfo[kProjectQty] integerValue];
        if (count == 0) {
            count = 1;
        }
        _projectCount = count;
        if (count < 4) {
            _btnCountSelectTag = 1000 + count;
            UIButton *button = [self.tableView viewWithTag:_btnCountSelectTag];
            if (button != nil) {
                button.selected = YES;
            }
        } else {
            _btnCountSelectTag = 1004;
            _btn_count_4.selected = YES;
            NSString *countString = [NSString stringWithFormat:@"%ld", count];
            _tf_count.text = countString;
            [_btn_count_4 setTitle:countString forState:UIControlStateSelected];
        }
        
        if (_dic_PerformanceInfo[kProjectSize] != nil) {
            _tf_projectSize.text = _dic_PerformanceInfo[kProjectSize];
            [_btn_unit setTitle:_dic_PerformanceInfo[kProjectUnit][kCommonValue] forState:UIControlStateNormal];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    self.jx_title = @"企业业绩";
    [self initData];
    [self layoutUI];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"清空条件" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    [self setNavigationBarRightItem:rightItem];
}

- (void)clear {
    [_dic_PerformanceInfo removeAllObjects];
    [_tableView reloadData];
    _tf_projectSize.text = @"";
    _unitDic = nil;
    [_btn_unit setTitle:@"请选择单位" forState:UIControlStateNormal];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.swipeBackEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.swipeBackEnabled = YES;
}

#pragma mark - tableView 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_Input.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_Normal";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    NSDictionary *dic_input = [_arr_Input objectAtIndex:indexPath.row];
    NSString *key = dic_input[kCellKey];
    NSString *name = dic_input[kCellName];
    NSString *editType = dic_input[kCellEditType];
    NSString *detailText = dic_input[kCellDefaultText];
    UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
    if ([EditType_DatePicker isEqualToString:editType]) {
        if (_dic_PerformanceInfo[key] != nil) {
            detailText = [NSString stringWithFormat:@"%@ ~ 至今", _dic_PerformanceInfo[key]];
            detailTextColor = [UIColor colorWithHex:@"333333"];
        }
    } else {
        NSDictionary *dic = _dic_PerformanceInfo[key];
        if (dic != nil) {
            detailText = dic[kCommonValue];
            detailTextColor = [UIColor colorWithHex:@"333333"];
        }
    }
    cell.textLabel.text = name;
    cell.detailTextLabel.text = detailText;
    cell.detailTextLabel.textColor = detailTextColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    NSDictionary *dic_input = [_arr_Input objectAtIndex:indexPath.row];
    NSString *editType = dic_input[kCellEditType];
    if ([EditType_DatePicker isEqualToString:editType]) {
        [self deadLineWithDic:dic_input indexPath:indexPath];
    } else if ([EditType_KeyValueChoice isEqualToString:editType]) {
        [self keyValueChoiceWithDic:dic_input indexPath:indexPath];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -

- (void)keyValueChoiceWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    NSString *key = dic[kCellKey];
    if ([key isEqualToString:kProjectCategory]) {
        //工程类别
        [_queryService getNewQueryProjectTypeToResult:^(NSArray<KeyValueDomain *> *projectTypeList, NSInteger code) {
            [self handleKeyValueList:projectTypeList cellDic:dic indexPath:indexPath];
        }];
    } else {
        //工程用途
        [_queryService getNewQueryProjectApplicationToResult:^(NSArray<KeyValueDomain *> *projectApplicationList, NSInteger code) {
            [self handleKeyValueList:projectApplicationList cellDic:dic indexPath:indexPath];
        }];
    }
}

- (void)handleKeyValueList:(NSArray *)list cellDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    NSString *key = dic[kCellKey];
    VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
    NSMutableArray *selectArray = [NSMutableArray array];
    if (_dic_PerformanceInfo[key] != nil) {
        [selectArray addObject:[_dic_PerformanceInfo[key] objectForKey:kCommonKey]];
    }
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:list];
    [vc_choice setDataArray:dataArray selectArray:selectArray];
    vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
        if ([resultDic[kCommonKey] isEqualToString:_dic_PerformanceInfo[key][kCommonKey]]) {
            [_dic_PerformanceInfo removeObjectForKey:key];
        } else {
            [_dic_PerformanceInfo setObject:resultDic forKey:key];
        }
        [_tableView reloadData];
    };
    [self.navigationController pushViewController:vc_choice animated:YES];
    
}

- (void)deadLineWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    HooDatePicker *datePicker = [[HooDatePicker alloc] initWithSuperView:self.view];
    datePicker.delegate = self;
    datePicker.datePickerMode = HooDatePickerModeYearAndMonth;
    [datePicker setHighlightColor:[CommonUtil zyzOrangeColor]];
    datePicker.maximumDate = [NSDate date];
    [datePicker show];
    NSDate *selectDate = _dic_PerformanceInfo[kSinceDateSelect];
    if (selectDate != nil) {
        [datePicker setDate:selectDate animated:YES];
    }
}

- (void)reloadIndexPath:(NSIndexPath *)indexPath {
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - textfield 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_tf_count == textField) {
        if (textField.text.trimWhitesSpace.length == 0) {
            if ([string isEqualToString:@"0"]) {
                return NO;
            }
            return YES;
        }
    } else if (_tf_projectSize == textField) {
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        if (futureString.length > 0) {
            unichar single = [futureString characterAtIndex:0];
            if(single == '.') {
                [ProgressHUD showInfo:@"第一个不能输入小数点" withSucc:NO withDismissDelay:2];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        if (futureString.length == 2) {
            unichar single = [futureString characterAtIndex:0];
            unichar second = [futureString characterAtIndex:1];
            if(single == '0' && second == '0') {
                [textField.text stringByReplacingCharactersInRange:range withString:@"0"];
                return NO;
            }
            if (single == '0' && second != '0' && second != '.') {
                textField.text = [NSString stringWithFormat:@"%c", second];
                return NO;
            }
        }
        NSArray *array = [futureString componentsSeparatedByString:@"."];
        if (array.count > 2) {
            return NO;
        }
        
        NSInteger flag=0;
        const NSInteger limited = 4;  //小数点  限制输入两位
        for (int i = futureString.length-1; i>=0; i--) {
            
            if ([futureString characterAtIndex:i] == '.') {
                
                if (flag > limited) {
                    [ProgressHUD showInfo:@"只能输入4位小数" withSucc:NO withDismissDelay:2];
                    return NO;
                }
                break;
            }
            flag++;
        }

    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _inputingTextField = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidEndEditing:textField];
    if (textField == _tf_count) {
        if (textField.text.trimWhitesSpace.integerValue > 0) {
            if ([textField.text.trimWhitesSpace hasPrefix:@"0"]) {
            }
            [_btn_count_4 setTitle:_tf_count.text forState:UIControlStateSelected];
            _btn_count_4.selected = YES;
            _projectCount = textField.text.integerValue;
        } else {
            _btn_count_4.selected = NO;
            UIButton *button = [self.tableView viewWithTag:_btnCountSelectTag];
            button.selected = YES;
        }
        _btn_count_4.hidden = NO;
        _tf_count.hidden = YES;
    }
}

#pragma mark - datepicker 
- (void)datePicker:(HooDatePicker *)dataPicker didSelectedDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [self monthDateFormatter];
    if (_isBeginDate) {
        NSString *beginDateString = [dateFormatter stringFromDate:date];
        if (_dic_PerformanceInfo[kEndDt] != nil) {
            NSDate *endDate = [CommonUtil dateFromString1:_dic_PerformanceInfo[kEndDt]];
            if ([date compare:endDate] == NSOrderedDescending) {
                [ProgressHUD showInfo:@"开始时间不能大于结束时间" withSucc:NO withDismissDelay:2];
                return;
            }
//            if (beginDateString > _dic_PerformanceInfo[kEndDt]) {
//                [ProgressHUD showInfo:@"开始时间不能大于结束时间" withSucc:NO withDismissDelay:2];
//                return;
//            }
        }
        [_btn_beginDate setTitle:beginDateString forState:UIControlStateNormal];
        [_dic_PerformanceInfo setObject:beginDateString forKey:kSinceDt];
        [_dic_PerformanceInfo setObject:date forKey:kSinceDateSelect];
    } else {
        NSString *endDateString = [dateFormatter stringFromDate:date];
        if (_dic_PerformanceInfo[kSinceDt] != nil) {
            NSDate *beginDate = [CommonUtil dateFromString1:_dic_PerformanceInfo[kSinceDt]];
            if ([beginDate compare:date] == NSOrderedDescending) {
                [ProgressHUD showInfo:@"结束时间不能小于开始时间" withSucc:NO withDismissDelay:2];
                return;
            }
            
            
//            if (endDateString < _dic_PerformanceInfo[kSinceDt]) {
//                [ProgressHUD showInfo:@"结束时间不能小于开始时间" withSucc:NO withDismissDelay:2];
//                return;
//            }
        }
        [_btn_endDate setTitle:endDateString forState:UIControlStateNormal];
        [_dic_PerformanceInfo setObject:endDateString forKey:kEndDt];
        [_dic_PerformanceInfo setObject:date forKey:kEndDateSelect];
    }
//    [_tableView reloadData];
}

- (NSDateFormatter *)monthDateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    return dateFormatter;
}

- (IBAction)btn_count_pressed:(id)sender {
    [self.view endEditing:YES];
    UIButton *button = (UIButton *)sender;
    if (!button.isSelected && button.tag != 1004) {
        _btnCountSelectTag = button.tag;
        if (button.tag == 1001) {
            _btn_count_1.selected = YES;
            _btn_count_2.selected = NO;
            _btn_count_3.selected = NO;
            _btn_count_4.selected = NO;
            _btn_count_4.hidden = NO;
            _tf_count.hidden = YES;
            _projectCount = 1;
        } else if (button.tag == 1002) {
            _btn_count_1.selected = NO;
            _btn_count_2.selected = YES;
            _btn_count_3.selected = NO;
            _btn_count_4.selected = NO;
            _btn_count_4.hidden = NO;
            _tf_count.hidden = YES;
            _projectCount = 2;
        } else if (button.tag == 1003) {
            _btn_count_1.selected = NO;
            _btn_count_2.selected = NO;
            _btn_count_3.selected = YES;
            _btn_count_4.selected = NO;
            _btn_count_4.hidden = NO;
            _tf_count.hidden = YES;
            _projectCount = 3;
        }
    }
    if (button.tag == 1004) {
        if (!button.isSelected) {
            _btn_count_1.selected = NO;
            _btn_count_2.selected = NO;
            _btn_count_3.selected = NO;
        }
        _btn_count_4.hidden = YES;
        _tf_count.hidden = NO;
        [_tf_count becomeFirstResponder];
    }
}

- (void)backPressed {
    __block typeof(self) weakSelf = self;
    [JAlertHelper jAlertWithTitle:@"是否保存业绩设置" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"保存"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self btn_finishSetting_pressed:nil];
        } else {
            [weakSelf goBack];
        }
    }];
    
}

- (IBAction)btn_unit_pressed:(id)sender {
    [self.view endEditing:YES];
    [_queryService getNewQueryUnitWithType:1 result:^(NSArray<KeyValueDomain *> *unitList, NSInteger code) {
        VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
        NSMutableArray *selectArray = [NSMutableArray array];
        if (_unitDic != nil) {
            [selectArray addObject:[_unitDic objectForKey:kCommonKey]];
        }
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:unitList];
        [vc_choice setDataArray:dataArray selectArray:selectArray];
        vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
            _unitDic = [NSDictionary dictionaryWithDictionary:resultDic];
            [_btn_unit setTitle:_unitDic[kCommonValue] forState:UIControlStateNormal];
        };
        [self.navigationController pushViewController:vc_choice animated:YES];
    }];
}

- (void)finishEditing {
    if (_inputingTextField == _tf_projectSize && [_tf_projectSize.text isNotEmptyString]) {
        [self performSelector:@selector(btn_unit_pressed:) withObject:nil afterDelay:0.2];
    }
    [self.view endEditing:YES];
}

- (IBAction)btn_finishSetting_pressed:(id)sender {
//    if (_dic_PerformanceInfo[kProjectCategory] == nil) {
//        [self finishSettingByTitleString:@"未选择工程类别，将清除设置"];
//        return;
//    }
//    if (_dic_PerformanceInfo[kProjectApplication] == nil) {
//        [self finishSettingByTitleString:@"未选择工程用途，将清除设置"];
//        return;
//    }
    if (_dic_PerformanceInfo[kSinceDt] != nil && _dic_PerformanceInfo[kEndDt] == nil) {
        [ProgressHUD showInfo:@"请选择结束时间" withSucc:NO withDismissDelay:2];
        return;
    }
    if (_dic_PerformanceInfo[kEndDt] != nil && _dic_PerformanceInfo[kSinceDt] == nil) {
        [ProgressHUD showInfo:@"请选择开始时间" withSucc:NO withDismissDelay:2];
        return;
    }
    
    [_dic_PerformanceInfo setObject:@(_projectCount) forKey:kProjectQty];
    if ([_tf_projectSize.text.trimWhitesSpace isEqualToString:@""] ||[_tf_projectSize.text.trimWhitesSpace isEqualToString:@"0"]) {
        [self finishSettingByTitleString:@"未输入业绩规模，将清除设置"];
        return;
    }
    [_dic_PerformanceInfo setObject:_tf_projectSize.text.trimWhitesSpace forKey:kProjectSize];
    if (_unitDic == nil) {
        [self finishSettingByTitleString:@"未选择单位，将清除设置"];
        return;
    }
    [_dic_PerformanceInfo setObject:_unitDic forKey:kProjectUnit];
    self.performanceResult(_dic_PerformanceInfo);
    [self goBack];
}

- (void)finishSettingByTitleString:(NSString *)titleString {
    [JAlertHelper jAlertWithTitle:titleString message:nil cancleButtonTitle:@"重新输入" OtherButtonsArray:@[@"清除并退出"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            self.performanceResult(nil);
            [self goBack];
        }
    }];
}

- (void)showDatePicker {
    HooDatePicker *datePicker = [[HooDatePicker alloc] initWithSuperView:self.view];
    datePicker.delegate = self;
    datePicker.datePickerMode = HooDatePickerModeYearAndMonth;
    [datePicker setHighlightColor:[CommonUtil zyzOrangeColor]];
    datePicker.maximumDate = [NSDate date];
    [datePicker show];
    NSDate *selectDate;
    if (_isBeginDate) {
        selectDate = _dic_PerformanceInfo[kSinceDateSelect];
    } else {
        selectDate = _dic_PerformanceInfo[kEndDateSelect];
    }
    if (selectDate != nil) {
        [datePicker setDate:selectDate animated:YES];
    }
}

- (IBAction)btn_beginDate_pressed:(id)sender {
    _isBeginDate = YES;
    [self showDatePicker];
    
}
- (IBAction)btn_endDate_pressed:(id)sender {
    _isBeginDate = NO;
    [self showDatePicker];
}
@end
