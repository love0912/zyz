//
//  VC_NewQuery.m
//  zyz
//
//  Created by 郭界 on 16/12/21.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_NewQuery.h"
#import "ZKSegment.h"
#import "VC_TextField.h"
#import "VC_Choice.h"
#import "BidService.h"
#import "VC_NewQuality.h"
#import "VC_CreditType.h"
#import "VC_NewCompanyPerformance.h"
#import "VC_PeopleSetter.h"
#import "NewQueryService.h"
#import "MLMOptionSelectView.h"


#define EditType_Performance @"EditType_Performance"
#define EditType_Member @"EditType_Member"

#define kAptitudeFilters @"AptitudeFilters"
#define kAptitudeFilters_Info @"AptitudeFilters_Info"

#define DefaultTextSetting @"请设置"

@interface VC_NewQuery ()
{
    NSMutableArray *_arr_Input;
    NSMutableDictionary *_dic_data;
    NSInteger _RequiredAttention;
    BidService *_bidService;
    
    NSMutableArray *_credit2_list;
    NSString *_otherCompanyName;
    
    NewQueryService *_queryService;
    
    //业绩查询
    NSMutableArray *_searchTypeArray;
    NSInteger _searchType;
}
@property (nonatomic, strong) MLMOptionSelectView *cellView;
@end

@implementation VC_NewQuery

- (void)initData {
    _dic_data = [NSMutableDictionary dictionary];
    _RequiredAttention = 0;
    _bidService = [BidService sharedService];
    
    _credit2_list=[[NSMutableArray alloc]init];
    _queryService = [NewQueryService sharedService];
    _arr_Input = [NSMutableArray arrayWithObjects:
//  @{kCellKey: kCompanyName, kCellName: @"企业名称", kCellDefaultText: @"请输入要搜索的企业名称", kCellEditType: EditType_TextField},
        @{kCellKey: kBidRegion, kCellName: @"选择省市", kCellDefaultText: @"请选择要搜索的企业经营所在省市", kCellEditType: EditType_RegionChoice},
        @{kCellKey: kBidRegionType, kCellName: @"本外地企业", kCellDefaultText: @"", kCellEditType: EditType_None},
        @{kCellKey: kAptitudeFilters_Info, kCellName: @"设置资质搜索条件", kCellDefaultText: @"请设置", kCellEditType: EditType_APChoice},
        @{kCellKey: @"PerformanceFilters", kCellName: @"设置业绩搜索条件", kCellDefaultText: @"请设置", kCellEditType: EditType_Performance},
        @{kCellKey: @"MemberFilters", kCellName: @"设置人员搜索条件", kCellDefaultText: @"请设置", kCellEditType: EditType_Member},
        @{kCellKey: KCredit, kCellName: @"设置诚信得分搜索条件", kCellDefaultText: @"请设置", kCellEditType: EditType_CSChoice}, nil];
    
    _searchTypeArray = [NSMutableArray arrayWithObjects:@"建造师",@"项目名称", nil];
}

- (void)layoutUI {
    [self.v_menu layoutIfNeeded];
    [self addSegmentView];
    [self layoutCompanyUI];
    [self layoutPersonUI];
}

- (void)layoutCompanyUI {
    if (IS_IPHONE_4_OR_LESS) {
        _layout_tableView_height.constant = 280;
        _layout_serachButton_top.constant = 5;
    }
}

- (void)layoutPersonUI {
    self.v_person.hidden = YES;
     _cellView = [[MLMOptionSelectView alloc] initOptionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"资质/人员/业绩查询";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

- (void)addSegmentView {
    ZKSegment *segment = [ZKSegment zk_segmentWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _v_menu.height) style:ZKSegmentLineStyle];
    [segment zk_setItems:@[@"企业查询", @"业绩查询"]];
    segment.zk_itemSelectedColor = [UIColor orangeColor];
    segment.zk_itemStyleSelectedColor = [UIColor orangeColor];
    //    __block typeof(self) weakSelf = self;
    segment.zk_itemClickBlock=^(NSString *itemName , NSInteger itemIndex){
        if (itemIndex == 0) {
            [self showCompanyView];
        } else {
            [self showPersonView];
        }
    };
    [_v_menu addSubview:segment];
}

- (void)showCompanyView {
    if (_v_company.isHidden) {
        _v_company.hidden = NO;
        _v_person.hidden = YES;
    }
}

- (void)showPersonView {
    if (_v_person.isHidden) {
        _v_person.hidden = NO;
        _v_company.hidden = YES;
    }
}

#pragma mark - tableView 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_Input.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_Normal";
    static NSString *CellID2 = @"Cell_PublishBidRadio3";
    
    NSDictionary *dic_input = [_arr_Input objectAtIndex:indexPath.row];
    NSString *key = dic_input[kCellKey];
    NSString *name = dic_input[kCellName];
    NSString *editType = dic_input[kCellEditType];
    if ([key isEqualToString:kBidRegionType]) {
        //企业要求
        Cell_PublishBidRadio3 *cell = [tableView dequeueReusableCellWithIdentifier:CellID2];
        cell.dic=_dic_data[kBidRegion];
        cell.pushType=1;
        cell.delegate = self;
        cell.type = _RequiredAttention;
        cell.otherCompanyName = _otherCompanyName;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        cell.textLabel.text = name;
        NSString *detailText = dic_input[kCellDefaultText];
        UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
        if ([EditType_TextField isEqualToString:editType]) {
            if (_dic_data[key] != nil) {
                detailText = _dic_data[key];
                detailTextColor = [UIColor colorWithHex:@"333333"];
            }
        } else if ([EditType_APChoice isEqualToString:editType]) {
            NSMutableDictionary *tmpDic = _dic_data[key];
            if (tmpDic == nil) {
                detailText = DefaultTextSetting;
            } else {
                detailTextColor = [UIColor colorWithHex:@"333333"];
                NSArray *apArray = tmpDic[kQualityData];
                NSMutableString *text = [NSMutableString stringWithFormat:@"已设置%ld个资质", apArray.count];
                if (apArray.count > 1) {
                    NSInteger isMatchAny = [tmpDic[kIsMatchAny] integerValue];
                    if (isMatchAny == 0) {
                        [text appendString:@"  同时具备"];
                    } else {
                        [text appendString:@"  任意均可"];
                    }
                }
                detailText = [text toString];
            }
        } else if ([EditType_RegionChoice isEqualToString:editType] ) {
            NSDictionary *dic = _dic_data[key];
            if (dic != nil) {
                detailText = dic[kCommonValue];
                detailTextColor = [UIColor colorWithHex:@"333333"];
            }
        } else if ([EditType_Performance isEqualToString:editType]) {
            NSDictionary *dic = _dic_data[key];
            if (dic != nil) {
                detailText = @"已设置";
                detailTextColor = [UIColor colorWithHex:@"333333"];
            } else {
                detailText = DefaultTextSetting;
            }
        } else if ([EditType_Member isEqualToString:editType]) {
            NSDictionary *dic = _dic_data[key];
            if (dic != nil) {
                detailText = [NSString stringWithFormat:@"已设置 %ld项", dic.count];
                detailTextColor = [UIColor colorWithHex:@"333333"];
            } else {
                detailText = DefaultTextSetting;
            }
        } else if ([EditType_CSChoice isEqualToString:editType]) {
            detailText = @"请输入诚信得分";
            detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
            if (_dic_data[key] != nil) {
                NSDictionary *tmpDic = _dic_data[key];
                int i = 0;
                for (NSString *creditKey in tmpDic.allKeys) {
                    NSObject *obj = tmpDic[creditKey];
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        i ++;
                    }
                }
                if (i > 0) {
                    detailText = [NSString stringWithFormat:@"已输入%d项", i];
                    detailTextColor = [UIColor colorWithHex:@"333333"];
                }
            }
        }
        cell.detailTextLabel.text = detailText;
        cell.detailTextLabel.textColor = detailTextColor;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    NSDictionary *tmpDic = [_arr_Input objectAtIndex:indexPath.row];
    NSString *editType = tmpDic[kCellEditType];
    if ([EditType_TextField isEqualToString:editType]) {
        [self textFieldWithDic:tmpDic indexPath:indexPath];
    } else if ([EditType_RegionChoice isEqualToString:editType]) {
        [self regionChoiceWithDic:tmpDic indexPath:indexPath];
    } else if ([EditType_APChoice isEqualToString:editType]) {
        [self apChoiceWithDic:tmpDic indexPath:indexPath];
    } else if ([EditType_CSChoice isEqualToString:editType]) {
        [self handelkCreditWithIndexPath:indexPath withDic:tmpDic];
    } else if ([EditType_Performance isEqualToString:editType]) {
        [self handlePerformanceWithDic:tmpDic indexPath:indexPath];
    } else if ([EditType_Member isEqualToString:editType]) {
        [self handleMemberWithDic:tmpDic indexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IPHONE_4_OR_LESS) {
        return 40;
    } else {
        return 48;
    }
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _tf_personName) {
        //搜索建造师
    }
    return YES;
}

#pragma mark - 本外地企业区分
/**
 *  本外地企业区分
 */
- (void)choiceRadio3Result:(NSInteger)result {
    _RequiredAttention = result;
}

#pragma mark - 
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
        if (text.isEmptyString) {
            [_dic_data removeObjectForKey:tmpDic[kCellKey]];
        } else {
            [_dic_data setObject:text forKey:tmpDic[kCellKey]];
        }
        [self reloadIndexPath:indexPath];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)regionChoiceWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    [_queryService getAlisRegionToResult:^(NSArray<KeyValueDomain *> *regionList, NSInteger code) {
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
            if ([resultDic[kCommonKey] isEqualToString:_dic_data[key][kCommonKey]]) {
                [_dic_data removeObjectForKey:key];
                _RequiredAttention = 0;
                _otherCompanyName = @"";
            } else {
                [_dic_data setObject:resultDic forKey:key];
                _otherCompanyName = resultDic[@"Alias"];
            }
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:vc_choice animated:YES];
    }];
}

- (void)apChoiceWithDic:(NSDictionary *)tmpDic indexPath:(NSIndexPath *)indexPath {
    NSString *key = tmpDic[kCellKey];
    VC_NewQuality *vc_newQuality = [self.storyboard instantiateViewControllerWithIdentifier:@"VC_NewQuality"];
    NSMutableDictionary *dic = _dic_data[key];
    if (dic != nil) {
        vc_newQuality.dic_QualityInfo = dic;
    }
    __block NSMutableDictionary *weakDic = _dic_data;
    vc_newQuality.qualityResult = ^(NSMutableDictionary *resultDic) {
        if (resultDic == nil || resultDic.count == 0) {
            [weakDic removeObjectForKey:key];
        } else {
            [weakDic setObject:resultDic forKey:key];
        }
        [self reloadIndexPath:indexPath];
    };
    [self.navigationController pushViewController:vc_newQuality animated:YES];
}

- (void)handelkCreditWithIndexPath:(NSIndexPath *)indexPath withDic:(NSDictionary *)dic {
    if (_dic_data[kBidRegion] == nil) {
        [ProgressHUD showInfo:@"请先选择省市" withSucc:NO withDismissDelay:2];
        return;
    }
    NSString *editType = dic[kCellEditType];
    NSString *key = dic[kCellKey];
    if ([EditType_CSChoice isEqualToString:editType]){
        if (_dic_data[key] != nil) {
            [_credit2_list addObject:_dic_data[key]];
        }
        
        [self handleCredit2WithIndexPath:indexPath key:key credit2:_credit2_list];
    }
}

- (void)handleCredit2WithIndexPath:(NSIndexPath *)indexPath key:(NSString *)key credit2:(NSMutableArray *)credit2List {
    //    VC_CreditScore *vc_CreditScore=[self.storyboard instantiateViewControllerWithIdentifier:@"VC_CreditScore"];
    //
    //     vc_CreditScore.selectArray = _dic_data[key];
    //     vc_CreditScore.credit2Result = ^(NSArray *resultArray){
    //        [_dic_data setObject:resultArray forKey:key];
    //          [self reloadIndexPath:indexPath];
    //      };
    //    [self.navigationController pushViewController:vc_CreditScore animated:YES];
    
    VC_CreditType *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"VC_CreditType"];
    vc.dic_data = _dic_data[key] == nil ? @{} : _dic_data[key];
    vc.regionCode = _dic_data[kBidRegion][kCommonKey];
    vc.type = 0;
    vc.resultDictionary = ^(NSDictionary *resultDic) {
        if (resultDic.allKeys.count == 0) {
            [_dic_data removeObjectForKey:key];
        } else {
            [_dic_data setObject:resultDic forKey:key];
        }
        [self reloadIndexPath:indexPath];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handlePerformanceWithDic:(NSDictionary *)tmpDic indexPath:(NSIndexPath *)indexPath {
    if (_dic_data[kBidRegion] == nil) {
        [ProgressHUD showInfo:@"请先选择省市" withSucc:NO withDismissDelay:2];
        return;
    }
    
    VC_NewCompanyPerformance *vc_NewCompanyPerformance = [self.storyboard instantiateViewControllerWithIdentifier:@"VC_NewCompanyPerformance"];
    NSString *key = tmpDic[kCellKey];
    NSMutableDictionary *dic = _dic_data[key];
    if (dic != nil) {
        vc_NewCompanyPerformance.dic_PerformanceInfo = dic;
    }
    vc_NewCompanyPerformance.performanceResult = ^(NSMutableDictionary *resultDic) {
        if (resultDic == nil || resultDic.count == 0) {
            [_dic_data removeObjectForKey:key];
        } else {
            [_dic_data setObject:resultDic forKey:key];
        }
        [self reloadIndexPath:indexPath];
    };
    [self.navigationController pushViewController:vc_NewCompanyPerformance animated:YES];

    
    
//    [PageJumpHelper pushToVCID:@"VC_NewCompanyPerformance" storyboard:Storyboard_Main parent:self];
}

- (void)handleMemberWithDic:(NSDictionary *)tmpDic indexPath:(NSIndexPath *)indexPath {
    if (_dic_data[kBidRegion] == nil) {
        [ProgressHUD showInfo:@"请先选择省市" withSucc:NO withDismissDelay:2];
        return;
    }
    
    VC_PeopleSetter *vc_peopleSetter = [self.storyboard instantiateViewControllerWithIdentifier:@"VC_PeopleSetter"];
    NSString *key = tmpDic[kCellKey];
    vc_peopleSetter.regionDic = _dic_data[kBidRegion];
    NSMutableDictionary *dic = _dic_data[key];
    if (dic != nil) {
        vc_peopleSetter.dic_MemberInfo = dic;
    }
    vc_peopleSetter.memberResult = ^(NSMutableDictionary *resultDic) {
        if (resultDic == nil || resultDic.count == 0) {
            [_dic_data removeObjectForKey:key];
        } else {
            [_dic_data setObject:resultDic forKey:key];
        }
        [self reloadIndexPath:indexPath];
    };
    [self.navigationController pushViewController:vc_peopleSetter animated:YES];
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
#pragma mark - 资质查询
- (IBAction)btn_queryAP_pressed:(id)sender {
//    [PageJumpHelper pushToVCID:@"VC_BuyQuery" storyboard:Storyboard_Main parent:self];
//    return;
    
    if ([self checkMustInput]) {
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        if (_dic_data[kCompanyName] != nil) {
            [paramDic setObject:_dic_data[kCompanyName] forKey:kCompanyName];
        }
        //区域
        NSString *regionKey = nil;
        if (_dic_data[kBidRegion] != nil) {
            regionKey = _dic_data[kBidRegion][kCommonKey];
            [paramDic setObject:regionKey forKey:kBidRegionCode];
        }
        [paramDic setObject:@(_RequiredAttention) forKey:kBidRegionType];
        //资质
        NSMutableDictionary *apDic = nil;
        if (_dic_data[kAptitudeFilters_Info] != nil) {
            apDic = [NSMutableDictionary dictionary];
            NSArray *tmpArray = _dic_data[kAptitudeFilters_Info][kQualityData];
            NSMutableArray *apArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *tmpDic in tmpArray) {
                [apArray addObject:tmpDic[kCommonKey]];
            }
            [apDic setObject:apArray forKey:kQualityData];
            if (tmpArray.count > 1) {
                [apDic setObject:_dic_data[kAptitudeFilters_Info][kIsMatchAny] forKey:kIsMatchAny];
            }
        }
        if (apDic != nil) {
            [paramDic setObject:apDic forKey:kQualityData];
        }
        if (_dic_data[@"PerformanceFilters"] != nil) {
            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:_dic_data[@"PerformanceFilters"]];
            [tmpDic removeObjectForKey:kSinceDateSelect];
            [tmpDic removeObjectForKey:kEndDateSelect];
            [paramDic setObject:tmpDic forKey:@"PerformanceFilters"];
        }
        if (_dic_data[@"MemberFilters"] != nil) {
            NSMutableDictionary *tmpDic = _dic_data[@"MemberFilters"];
            NSMutableDictionary *finalDic = [NSMutableDictionary dictionaryWithCapacity:tmpDic.count];
            [tmpDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSArray *tmpArray = obj;
                NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:tmpArray.count];
                [tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableDictionary *tmpDic2 = obj;
                    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:tmpDic2.count];
                    [tmpDic2 enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([key isEqualToString:@"TechCategory"]) {
                            NSMutableDictionary *tmpDic3 = obj;
                            NSMutableDictionary *resultDic1 = [NSMutableDictionary dictionaryWithCapacity:0];
                            [tmpDic3 enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                                if (![key isEqualToString:kQualitySubCollection]) {
                                    [resultDic1 setObject:obj forKey:key];
                                }
                            }];
                            [resultDic setObject:resultDic1 forKey:key];
                        } else {
                            [resultDic setObject:obj forKey:key];
                        }
                    }];
                    [resultArray addObject:resultDic];
                }];
                [finalDic setObject:resultArray forKey:key];
            }];
//            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:[_dic_data[@"MemberFilters"] mutableCopy]];
//            [tmpDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//                NSArray *tmpArray = obj;
//                [tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    NSMutableDictionary *tmpDic2 = obj[@"TechCategory"];
//                    [tmpDic2 removeObjectForKey:kQualitySubCollection];
//                }];
//            }];
            [paramDic setObject:finalDic forKey:@"MemberFilters"];
        }
        if (_dic_data[KCredit] != nil) {
            [paramDic setObject:_dic_data[KCredit] forKey:KCredit];
        }
        [_queryService getCompanyByName:_dic_data[kCompanyName] regionKey:regionKey regionType:_RequiredAttention aptitudeFilterOfDic:apDic performanceFilterOfDic:paramDic[@"PerformanceFilters"] memberFilterOfDic:paramDic[@"MemberFilters"] creditsOfDic:_dic_data[KCredit] pageOfNumber:1 result:^(QualificaDomian *responseBid, NSInteger code) {
            if (code == 4001) {
                NSString *string = [NSString stringWithFormat:@"%@需要开通会员才可查询，或者去购买方案、预算、保函可免费延长搜索期限", _dic_data[kBidRegion][kCommonValue]];
                //充值
                [JAlertHelper jAlertWithTitle:string message:@"是否前往开通" cancleButtonTitle:@"不用了" OtherButtonsArray:@[@"开通"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [PageJumpHelper pushToVCID:@"VC_BuyQuery" storyboard:Storyboard_Main parent:self];
                    }
                }];
                
            }
            
            if (code != 1) {
                return ;
            }
            if ([responseBid.Count integerValue]==0) {
                [ProgressHUD showInfo:@"暂时没有符合该要求的企业" withSucc:NO withDismissDelay:2];
                
            } else{
                [JAlertHelper jAlertWithTitle:[NSString stringWithFormat:@"共查询到%@家企业",responseBid.Count] message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"去查看"]  showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                    if(buttonIndex==0){
                        
                    }else{
                        [CountUtil countSearchToView];
                        
                        [PageJumpHelper pushToVCID:@"VC_QualificationList" storyboard:Storyboard_Main parameters:@{kPageType: @0, kPageDataDic: paramDic} parent:self];
                    }
                }];
            }
        }];
    }
    
}

- (BOOL)checkMustInput {
    if (_dic_data[kCompanyName]!=nil && ![_dic_data[kCompanyName] isEmptyString]) {
        return YES;
    }
    if (_dic_data[kBidRegion] == nil) {
        [ProgressHUD showInfo:@"必须选择省市" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
}


#pragma mark - 业绩查询

- (IBAction)btn_searchType_pressed:(id)sender {
    [self defaultCell];
    _cellView.vhShow = NO;
    _cellView.edgeInsets = UIEdgeInsetsMake(64, 10, 10, 10);
    _cellView.optionType = MLMOptionSelectViewTypeCustom;
//    _cellView.backColor = [UIColor colorWithHex:@"000000"];
//    _cellView.alpha = 0.7f;
    CGPoint point = CGPointMake(_btn_searchType.origin.x, _btn_searchType.origin.y + _btn_searchType.height);
    CGPoint P = [_btn_searchType.superview convertPoint:point toView:self.view];
    [_cellView showTapPoint:P viewWidth:200 direction:MLMOptionSelectViewBottom];
}

- (void)defaultCell {
    WEAK(weaklistArray, _searchTypeArray);
    WEAK(weakSelf, self);
    _cellView.canEdit = YES;
    [_cellView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCell"];
    _cellView.cell = ^(NSIndexPath *indexPath){
        UITableViewCell *cell = [weakSelf.cellView dequeueReusableCellWithIdentifier:@"DefaultCell"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",weaklistArray[indexPath.row]];
        return cell;
    };
    _cellView.optionCellHeight = ^{
        return 40.f;
    };
    _cellView.rowNumber = ^(){
        return (NSInteger)weaklistArray.count;
    };
    __block NSArray *weakArray = _searchTypeArray;
    _cellView.selectedOption = ^(NSIndexPath *indexPath){
        _searchType = indexPath.row;
        [weakSelf.btn_searchType setTitle:weakArray[indexPath.row] forState:UIControlStateNormal];
        if (indexPath.row == 0) {
            weakSelf.tf_personName.placeholder = @"请输入建造师名称";
        } else {
            weakSelf.tf_personName.placeholder = @"请输入项目名称关键字";
        }
    };
    
}
- (IBAction)btn_performanceQuery_pressed:(id)sender {
    if (_tf_personName.text.trimWhitesSpace.isEmptyString) {
        NSString *title = @"请输入建造师名称";
        if (_searchType == 1) {
            title = @"请输入项目名称";
        }
        [ProgressHUD showInfo:title withSucc:NO withDismissDelay:2];
    } else {
        [_queryService getProjectPerformanceWithSearchType:_searchType name:_tf_personName.text companyOId:nil page:1 result:^(NSArray<PerformanceDoamin *> *performList, NSInteger code) {
            if (code != 1) {
                return;
            }
            if (performList.count == 0) {
                [ProgressHUD showInfo:@"没有查询到数据!" withSucc:NO withDismissDelay:2];
                return;
            }
            [PageJumpHelper pushToVCID:@"VC_PerformanceList" storyboard:Storyboard_Main parameters:@{kPageDataDic:performList, kPage:@(1), @"queryType": @(_searchType), @"Name": _tf_personName.text} parent:self];
        }];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [super textFieldDidBeginEditing:textField];
    if (_tf_companyName == textField) {
        _tf_companyName.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [super textFieldDidBeginEditing:textField];
    if (_tf_companyName == textField) {
        _tf_companyName.textAlignment = NSTextAlignmentRight;
        if (textField.text.trimWhitesSpace.isEmptyString) {
            [_dic_data removeObjectForKey:kCompanyName];
        } else {
            [_dic_data setObject:textField.text forKey:kCompanyName];
        }
    }
}

@end
