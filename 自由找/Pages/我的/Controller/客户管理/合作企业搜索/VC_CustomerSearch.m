//
//  VC_CustomerSearch.m
//  自由找
//
//  Created by guojie on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_CustomerSearch.h"
#import "BidService.h"
#import "VC_Choice.h"
#import "VC_Quality.h"
#import "VC_TextField.h"
#import "CustomerService.h"

@interface VC_CustomerSearch ()
{
    NSArray *_arr_input;
    NSMutableDictionary *_dic_data;
    BidService *_bidService;
//    JoinService *_joinService;
    NSMutableDictionary *_dic_qualitySelected;
    CustomerService *_customerService;
}
@end

@implementation VC_CustomerSearch

- (void)initData {
    _arr_input = @[
                   @[
                       @{kCellName: @"企业名称", kCellKey: kCustomerName, kCellDefaultText: @"输入企业名字"},
                       @{kCellName: @"资质一", kCellKey: kCustomerAptitude1, kCellDefaultText: @"请选择资质类型及等级"},
                       @{kCellName: @"资质二", kCellKey: kCustomerAptitude2, kCellDefaultText: @"请选择资质类型及等级"},
                       @{kCellName: @"资质三", kCellKey: kCustomerAptitude3, kCellDefaultText: @"请选择资质类型及等级"},
                       @{kCellName: @"资质四", kCellKey: kCustomerAptitude4, kCellDefaultText: @"请选择资质类型及等级"}
                       ],
                   @[@{kCellName: @"合作情况", kCellKey: kCustomerCooperation, kCellDefaultText: @"请选择合作情况"}],
                   ];
    _dic_qualitySelected = [NSMutableDictionary dictionary];
    _dic_data = [NSMutableDictionary dictionary];
    _bidService = [BidService sharedService];
    _customerService = [CustomerService sharedService];
}

- (void)layoutUI {
    UIView *v_head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 10)];
    v_head.backgroundColor = [CommonUtil zyzBackgroundColor];
    self.tableView.tableHeaderView = v_head;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"合作企业搜索";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

- (NSDictionary *) handleQualityWithDic:(NSDictionary *)tmpDic {
    NSString *limitKey = tmpDic[kCommonKey];
    NSString *topKey = @"";
    NSRange range = [limitKey rangeOfString:@"lv"];
    if (range.location != NSNotFound) {
        topKey = [limitKey substringToIndex:range.location];
    }
    if ([limitKey hasPrefix:@"gljtgc"]) {
        topKey = [topKey substringToIndex:topKey.length-2];
    }
    return @{kTopKey: topKey, kLimitKey: limitKey};
}


#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arr_input.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_arr_input objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = _arr_input[indexPath.section][indexPath.row];
    static NSString *CellIdentifier = @"Cell_Search";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = tmpDic[kCellName];
    NSString *text = tmpDic[kCellDefaultText];
    UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
    NSString *key = tmpDic[kCellKey];
    if ([key hasPrefix:@"Aptitude"]) {
        //资质
        NSDictionary *dic = _dic_data[key];
        if (dic != nil && ![dic[kCommonKey] isEmptyString]) {
            text = dic[kCommonValue];
            detailTextColor = [UIColor colorWithHex:@"333333"];
        }
    } else if ([kCustomerName isEqualToString:key]) {
        if (_dic_data[key] != nil && ![_dic_data[key] isEmptyString]) {
            text = _dic_data[key];
            detailTextColor = [UIColor colorWithHex:@"333333"];
        }
    } else if ([kCustomerCooperation isEqualToString:key]) {
        if (_dic_data[key] != nil && ![_dic_data[key] isEmptyString]) {
            text = [CommonUtil cooperationValueForKey:_dic_data[key]];
            detailTextColor = [UIColor colorWithHex:@"333333"];
        }
    }
    cell.detailTextLabel.textColor = detailTextColor;
    cell.detailTextLabel.text = text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = _arr_input[indexPath.section][indexPath.row];
    NSString *key = tmpDic[kCellKey];
    if ([key hasPrefix:@"Aptitude"]) {
        [self apChoiceWithDic:tmpDic indexPath:indexPath];
    } else if ([kCustomerName isEqualToString:key]) {
        [self textFieldWithDic:tmpDic indexPath:indexPath];
    } else if ([kCustomerCooperation isEqualToString:key]) {
        if (_dic_data[key] == nil) {
            [self cooperationTypeWithDic:tmpDic indexPath:indexPath];
        } else {
            [JAlertHelper jSheetWithTitle:@"您已选择合作情况" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"重新选择" OtherButtonsArray:@[@"删除合作情况"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [self cooperationTypeWithDic:tmpDic indexPath:indexPath];
                } else {
                    [_dic_data removeObjectForKey:key];
                    [self reloadIndexPath:indexPath];
                }
            }];
        }
    }
}

- (void)apChoiceWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    NSString *key = dic[kCellKey];
    if (_dic_data[key] == nil) {
        [self choiceApWithhDic:dic indexPath:indexPath type:1];
    } else {
        [JAlertHelper jSheetWithTitle:@"您已选择资质!" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"重新选择" OtherButtonsArray:@[@"删除该资质"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                //重新选择
                [self choiceApWithhDic:dic indexPath:indexPath type:2];
            } else if (buttonIndex == 2) {
                //删除该资质
                [_dic_data removeObjectForKey:key];
                [_dic_qualitySelected removeObjectForKey:key];
                [self reloadIndexPath:indexPath];
            }
        }];
    }
    
}

/**
 *  选择资质
 *
 *  @param dic       <#dic description#>
 *  @param indexPath <#indexPath description#>
 *  @param type      1 -- 新增, 2 -- 重新选择
 */
- (void)choiceApWithhDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath type:(NSInteger)type{
    NSString *key = dic[kCellKey];
    [_bidService getQualitificationWithType:2 result:^(NSArray *qualityList, NSInteger code) {
        if (code != 1) {
            return ;
        }
        VC_Quality *vc_quality = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Quality"];
        if (type == 1) {
            if (_dic_qualitySelected.count == 0) {
                [vc_quality setDataArray:qualityList disabledArray:nil selectedData:nil];
            } else {
                NSMutableArray *disabledArray = [NSMutableArray arrayWithCapacity:_dic_qualitySelected.count];
                for (NSDictionary *tmpDic in [_dic_qualitySelected allValues]) {
                    [disabledArray addObject:tmpDic[kTopKey]];
                }
                [vc_quality setDataArray:qualityList disabledArray:disabledArray selectedData:nil];
            }
        } else {
            if (_dic_qualitySelected.count == 1) {
                [vc_quality setDataArray:qualityList disabledArray:nil selectedData:_dic_qualitySelected[key]];
            } else {
                NSDictionary *tmpDic = [NSDictionary dictionaryWithDictionary:_dic_qualitySelected[key]];
                NSMutableArray *disabledArray = [NSMutableArray arrayWithCapacity:_dic_qualitySelected.count];
                for (NSString *tmpKey in [_dic_qualitySelected allKeys]) {
                    if (![tmpKey isEqualToString:key]) {
                        NSDictionary *tmpDic2 = _dic_qualitySelected[tmpKey];
                        [disabledArray addObject:tmpDic2[kTopKey]];
                    }
                }
                [vc_quality setDataArray:qualityList disabledArray:disabledArray selectedData:tmpDic];
            }
        }
        [self.navigationController pushViewController:vc_quality animated:YES];
        vc_quality.choiceQualityBlock = ^(NSDictionary * dic) {
            [_dic_data setObject:dic forKey:key];
            [_dic_qualitySelected setObject:@{kTopKey: dic[kTopKey], kLimitKey: dic[kCommonKey]} forKey:key];
            //            [self handleSelectedQualityTipsWithKey:dic[kNewEnunKey]];
            [self reloadIndexPath:indexPath];
        };
    }];
}

- (void)textFieldWithDic:(NSDictionary *)tmpDic indexPath:(NSIndexPath *)indexPath {
    VC_TextField *vc = [self getVC_TextField];
    vc.type = INPUT_TYPE_NORMAL;
    NSString *text = _dic_data[tmpDic[kCellKey]];
    if (text != nil && ![text isEmptyString]) {
        vc.text = text;
    }
    vc.jTitle = tmpDic[kCellDefaultText];
    vc.placeholder = tmpDic[kCellDefaultText];
    vc.inputBlock = ^(NSString *text) {
        [_dic_data setObject:text forKey:tmpDic[kCellKey]];
        [self reloadIndexPath:indexPath];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (VC_TextField *)getVC_TextField {
    return [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_TextField"];
}

- (void)cooperationTypeWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    NSArray *arr_coo = [CommonUtil getCooperationData];
    VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
    NSMutableArray *selectArray = [NSMutableArray array];
    NSString *key = dic[kCellKey];
    if (_dic_data[key] != nil) {
        [selectArray addObject:_dic_data[key]];
    }
    [vc_choice setDataArray:arr_coo selectArray:selectArray];
    vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
        [_dic_data setObject:resultDic[kCommonKey] forKey:key];
        [self reloadIndexPath:indexPath];
    };
    [self.navigationController pushViewController:vc_choice animated:YES];
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

- (IBAction)btn_search_pressed:(id)sender {
    [self getCustomer];
}

- (void)getCustomer {
    [_dic_data setObject:@(1) forKey:kPage];
    [_customerService queryCustomerWithParameters:_dic_data result:^(NSArray<CustomerDomain *> *arr_custom, NSInteger count, NSInteger code) {
        if (code == 1) {
            if (arr_custom.count == 0) {
                [ProgressHUD showInfo:@"未查询到结果" withSucc:NO withDismissDelay:2];
            } else {
                [PageJumpHelper pushToVCID:@"VC_CSearchResult" storyboard:Storyboard_Mine parameters:@{kPageDataDic: _dic_data, @"Count": @(count), @"Data": arr_custom} parent:self];
            }
        }
        
    }];
}
@end
