//
//  VC_CreditType.m
//  自由找
//
//  Created by guojie on 16/7/22.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_CreditType.h"
#import "QualificaService.h"
#import "VC_CreditResult.h"
#import "VC_TextField.h"

#define kCellKeyAlias @"KeyAlias"

@interface VC_CreditType ()
{
    NSMutableArray *_arr_input;
    QualificaService *_qualificaService;
}
@end

@implementation VC_CreditType

- (void)initData {
    _qualificaService = [QualificaService sharedService];
    [self getCreditType];
}

- (void)layoutUI {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(commitPressed)];
    [self setNavigationBarRightItem:rightItem];
    [self hideTableViewFooter:self.tableView];
}

- (void)commitPressed {
    self.resultDictionary(_dic_data);
    [self goBack];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"诚信得分";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

- (void)getCreditType {
    [_qualificaService getCreditTypeWithRegionCode:_regionCode type:_type result:^(NSArray *creditTypes, NSInteger code) {
        if (code == 1) {
            _arr_input = [NSMutableArray arrayWithArray:creditTypes];
            [_tableView reloadData];
        } else {
            [ProgressHUD showInfo:@"获取诚信得分类别失败" withSucc:NO withDismissDelay:2];
        }
    }];
}

- (void)setDic_data:(NSMutableDictionary *)dic_data {
    _dic_data = [NSMutableDictionary dictionaryWithDictionary:dic_data];
}

#pragma mark - tableview 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_input.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_CreditType";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
     NSInteger classType = [[tmpDic objectForKey:@"ClassType"] integerValue];
    cell.textLabel.text = tmpDic[@"ClassDisplayName"];
    UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
    NSString *detailText = @"请选择";
    NSObject *obj = [_dic_data objectForKey:tmpDic[@"ClassName"]];
    if (obj != nil && [obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *selectCreditDic = (NSDictionary *)obj;
        NSString *key = selectCreditDic[kCommonKey];
        if (key != nil && ![key isEmptyString] && ![key isEqualToString:@"0.00"]) {
            detailTextColor = [UIColor colorWithHex:@"333333"];
            detailText = selectCreditDic[kCommonValue];
        }else{
            if (classType == 0) {
               detailText=@"请选择";
            }else{
               detailText=@"请输入";
            }
        }
    }
    cell.detailTextLabel.textColor = detailTextColor;
    cell.detailTextLabel.text = detailText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
//    if (self.type == 0) {
//        [self searchCreditWithInputDic:tmpDic atIndexPath:indexPath];
//    } else {
//        [self editCreditWithInputDic:tmpDic atIndexPath:indexPath];
//    }
    NSString *key = [tmpDic objectForKey:@"ClassName"];
    NSInteger classType = [[tmpDic objectForKey:@"ClassType"] integerValue];
    if (classType == 0) {
        [self choiceCreditWithKey:key dataArray:[tmpDic objectForKey:@"ClassOptions"] atIndexPath:indexPath];
    } else {
        NSDictionary *rangeDic = [tmpDic objectForKey:@"ClassRange"];
        [self editCreditWithKey:key minValue:[[rangeDic objectForKey:@"Min"] floatValue] maxValue:[[rangeDic objectForKey:@"Max"] floatValue] atIndexPath:indexPath];
    }
}

- (void)choiceCreditWithKey:(NSString *)key dataArray:(NSArray *)array atIndexPath:(NSIndexPath *)indexPath {
    VC_CreditResult *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"VC_CreditResult"];
    NSString *selectKey = @"";
    NSObject *obj = [_dic_data objectForKey:key];
    if (obj != nil && [obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *selectCreditDic = (NSDictionary *)obj;
        selectKey = selectCreditDic[kCommonKey];
    }
    [vc setInputArray:array selectKey:selectKey];
    vc.creditChoice = ^(NSDictionary *resultDic) {
        if (resultDic == nil) {
            [_dic_data setObject:@"" forKey:key];
        } else {
            [_dic_data setObject:resultDic forKey:key];
        }
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editCreditWithKey:(NSString *)key minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue atIndexPath:(NSIndexPath *)indexPath {
    VC_TextField *vc_textfield = [[self storyboard] instantiateViewControllerWithIdentifier:@"VC_TextField"];
    vc_textfield.type = INPUT_TYPE_DECIMAL;
    NSString *placeholder = [NSString stringWithFormat:@"请输入诚信得分，范围%.2f到%.2f", minValue, maxValue];
    vc_textfield.placeholder = placeholder;
    vc_textfield.minValue = minValue;
    vc_textfield.maxValue = maxValue;
    vc_textfield.jUnit = @"分";
    NSObject *obj = [_dic_data objectForKey:key];
    if (obj != nil && [obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *selectCreditDic = (NSDictionary *)obj;
        vc_textfield.text = selectCreditDic[kCommonKey];
    }
    vc_textfield.inputBlock = ^(NSString *text) {
        if ([text isEmptyString]) {
            [_dic_data setObject:@"" forKey:key];
        } else {
            NSDictionary *tmpDic = @{kCommonKey:[NSString stringWithFormat:@"%.2f", [text floatValue]], kCommonValue: [NSString stringWithFormat:@"%.2f分", [text floatValue]]};
            [_dic_data setObject:tmpDic forKey:key];
        }
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:vc_textfield animated:YES];
}

//- (void)searchCreditWithInputDic:(NSDictionary *)inputDic atIndexPath:(NSIndexPath *)indexPath {
//    NSString *key = inputDic[kCommonKey];
//    NSDictionary *paramDic = @{kCommonType: key, @"RegionCode": _regionCode};
//    [_qualificaService creditsettingWithParameters:paramDic result:^(NSArray<KeyValueDomain *> *responseBid, NSInteger code) {
//        if (code == 1) {
//            VC_CreditResult *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"VC_CreditResult"];
//            NSString *selectKey = @"";
//            NSObject *obj = [_dic_data objectForKey:key];
//            if (obj != nil && [obj isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *selectCreditDic = (NSDictionary *)obj;
//                selectKey = selectCreditDic[kCommonKey];
//            }
//            [vc setInputArray:responseBid selectKey:selectKey];
//            vc.creditChoice = ^(NSDictionary *resultDic) {
//                if (resultDic == nil) {
//                    [_dic_data setObject:@"" forKey:key];
//                } else {
//                    [_dic_data setObject:resultDic forKey:key];
//                }
//                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            };
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        }
//    }];
//}


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
