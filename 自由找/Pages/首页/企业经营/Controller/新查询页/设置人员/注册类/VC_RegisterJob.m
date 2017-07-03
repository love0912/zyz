//
//  VC_RegisterJob.m
//  zyz
//
//  Created by 郭界 on 16/12/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_RegisterJob.h"
#import "NewQueryService.h"
#import "VC_Choice.h"
#import "VC_ChoiceIndex.h"

@interface VC_RegisterJob ()<CellRegisterJobDelegate>
{
    NSMutableArray *_arr_memberType;
    NSMutableArray *_arr_memberCount;
    NewQueryService *_queryService;
    BOOL _isCheckInput;
}
@end

@implementation VC_RegisterJob

- (void)initData {
    if (_arr_registerJobInfo == nil) {
        _arr_registerJobInfo = [NSMutableArray arrayWithObject:[NSMutableDictionary dictionary]];
    }
    
    _queryService = [NewQueryService sharedService];
    
}

- (void)layoutUI {
    if (_titleType == 1) {
        self.jx_title = @"注册类人员";
    } else if (_titleType == 2) {
        self.jx_title = @"职称类人员";
    } else {
        self.jx_title = @"现场管理类人员";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

- (void)setTitleType:(NSInteger)titleType {
    _titleType = titleType;
}

- (void)setArr_registerJobInfo:(NSMutableArray *)arr_registerJobInfo {
    _arr_registerJobInfo = [NSMutableArray array];
    [arr_registerJobInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_arr_registerJobInfo addObject:[obj mutableCopy]];
    }];
}

#pragma mark - tableviewz
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_registerJobInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_RegisterJob";
    Cell_RegisterJob *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.delegate = self;
    NSMutableDictionary *tmpDic = _arr_registerJobInfo[indexPath.row];
    cell.dataDic = tmpDic;
    if (indexPath.row == 0) {
        cell.showDelete = NO;
    } else {
        cell.showDelete = YES;
    }
    if (_titleType == 4) {
        cell.hideLevel = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_titleType == 4) {
        return 142;
    }
    return 190;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - cell delegate
- (void)handleDataDic:(NSMutableDictionary *)dataDic type:(RegisterJobType)type {
    switch (type) {
        case RegisterJob_Name:
            [self nameChoiceByDic:dataDic];
            break;
        case RegisterJob_Level:
            [self levelChoiceByDic:dataDic];
            break;
        case RegisterJob_Count:
            [self countChoiceByDic:dataDic];
            break;
        case RegisterJob_Delete:
            [self deleteDataByDic:dataDic];
            break;
        case RegisterJob_Clear:
            [self clearDataByDic:dataDic];
            break;
        default:
            break;
    }
}

- (void)nameChoiceByDic:(NSMutableDictionary *)dataDic {
    
    if (_arr_memberType == nil) {
        [_queryService getMemberTypeWityType:_titleType result:^(NSArray *typeArray, NSInteger code) {
            if (code != 1) {
                return ;
            }
            _arr_memberType = [NSMutableArray arrayWithArray:typeArray];
            [self choiceByDataDic:dataDic key:kTechCategory dataArray:_arr_memberType];
        }];
    } else {
        [self choiceByDataDic:dataDic key:kTechCategory dataArray:_arr_memberType];
    }
}

- (void)choiceByDataDic:(NSMutableDictionary *)dataDic key:(NSString *)key dataArray:(NSArray *)dataArray {
    
    if ([key isEqualToString:kTechCategory]) {
        VC_ChoiceIndex *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_ChoiceIndex"];
        NSMutableArray *selectArray = [NSMutableArray array];
        if (dataDic[key] != nil) {
            [selectArray addObject:[dataDic[key] objectForKey:kCommonKey]];
        }
        [vc_choice setDataArray:dataArray selectArray:selectArray];
        vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
            [dataDic removeAllObjects];
            [dataDic setObject:resultDic forKey:key];
            if ([key isEqualToString:kTechCategory] && _titleType != 4) {
                NSArray *tmpArray = resultDic[kQualitySubCollection];
                if (tmpArray.count == 0) {
                    [dataDic setObject:@{kCommonKey:@"", kCommonValue:@"无等级"} forKey:kTechLevel];
                } else {
                    if (_arr_memberCount == nil) {
                        _arr_memberCount = [NSMutableArray arrayWithCapacity:0];
                    }
                    [_arr_memberCount setArray:tmpArray];
                }
            }
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:vc_choice animated:YES];
    } else {
        VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
        NSMutableArray *selectArray = [NSMutableArray array];
        if (dataDic[key] != nil) {
            [selectArray addObject:[dataDic[key] objectForKey:kCommonKey]];
        }
        [vc_choice setDataArray:dataArray selectArray:selectArray];
        vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
            [dataDic setObject:[resultDic mutableCopy] forKey:key];
            if ([key isEqualToString:kTechCategory] && _titleType != 4) {
                NSArray *tmpArray = resultDic[kQualitySubCollection];
                if (tmpArray.count == 0) {
                    [dataDic setObject:@{kCommonKey:@"", kCommonValue:@"无等级"} forKey:kTechLevel];
                } else {
                    if (_arr_memberCount == nil) {
                        _arr_memberCount = [NSMutableArray arrayWithCapacity:0];
                    }
                    [_arr_memberCount setArray:tmpArray];
                }
            }
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:vc_choice animated:YES];
    }
}

- (void)levelChoiceByDic:(NSMutableDictionary *)dataDic {
    if (dataDic[kTechCategory] == nil) {
        [ProgressHUD showInfo:@"请选择专业名称" withSucc:NO withDismissDelay:2];
        return;
    } else {
        NSDictionary *tmpDic = dataDic[kTechLevel];
        if (tmpDic != nil) {
            if ([tmpDic[kCommonKey] isEmptyString]) {
                return;
            }
            if (_arr_memberCount == nil) {
                _arr_memberCount = [NSMutableArray arrayWithArray:dataDic[kTechCategory][kQualitySubCollection]];
            }
        }
        
    }
    [self choiceByDataDic:dataDic key:kTechLevel dataArray:_arr_memberCount];
}

- (void)countChoiceByDic:(NSMutableDictionary *)dataDic {
    if (dataDic[kTechCategory] == nil) {
        [ProgressHUD showInfo:@"请先选择专业名称" withSucc:NO withDismissDelay:2];
        return;
    }
    NSString *key = dataDic[kTechCategory][kCommonKey];
    [_queryService getMemberTypeCountWithTypeKey:key result:^(NSArray<KeyValueDomain *> *countList, NSInteger code) {
        if (code != 1) {
            return;
        }
        [self choiceByDataDic:dataDic key:kMinQty dataArray:countList];
    }];
}

- (void)deleteDataByDic:(NSMutableDictionary *)dataDic {
    [_arr_registerJobInfo removeObject:dataDic];
    [_tableView reloadData];
}

- (void)clearDataByDic:(NSMutableDictionary *)dataDic {
    [dataDic removeAllObjects];
    [_tableView reloadData];
}

#pragma mark -

- (void)backPressed {
    __block typeof(self) weakSelf = self;
    [JAlertHelper jAlertWithTitle: @"是否保存人员设置" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"保存"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf finish];
        }
        [weakSelf goBack];
    }];
}

- (void)finish {
    [_arr_registerJobInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *tmpDic = obj;
        if (_titleType == 4) {
            if (tmpDic.count < 2) {
                [_arr_registerJobInfo removeObject:tmpDic];
            }
        } else {
            if (tmpDic.count < 3) {
                [_arr_registerJobInfo removeObject:tmpDic];
            }
        }
    }];
    self.qualityResult(_arr_registerJobInfo);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_add_pressed:(id)sender {
    _isCheckInput = YES;
    __block BOOL check = _isCheckInput;
    [_arr_registerJobInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dic = obj;
        if (_titleType == 4) {
            if (dic.count < 2) {
                 check = NO;
                *stop = YES;
            }
        } else {
            if (dic.count < 3) {
                check = NO;
                *stop = YES;
            }
        }
    }];
    if (check) {
        [_arr_registerJobInfo addObject:[NSMutableDictionary dictionary]];
        [_tableView reloadData];
    } else {
        [ProgressHUD showInfo:@"请设置完条件再继续添加" withSucc:NO withDismissDelay:2];
    }
}
- (IBAction)btn_finish_pressed:(id)sender {
    _isCheckInput = YES;
    __block BOOL check = _isCheckInput;
    [_arr_registerJobInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dic = obj;
        if (dic.count == 0) {
            [_arr_registerJobInfo removeObject:dic];
            return;
        }
        if (_titleType == 4) {
            if (dic.count < 2) {
                check = NO;
                *stop = YES;
            }
        } else {
            if (dic.count < 3) {
                check = NO;
                *stop = YES;
            }
        }
    }];
    if (!check) {
        [ProgressHUD showInfo:@"请设置完条件" withSucc:NO withDismissDelay:2];
        return;
    }
    [self finish];
    [self goBack];
}
@end
