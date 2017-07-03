//
//  VC_QueryQualification.m
//  自由找
//
//  Created by xiaoqi on 16/7/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_QueryQualification.h"
#import "VC_Choice.h"
#import "BidService.h"
#import "VC_Quality.h"
#import "VC_CreditScore.h"
#import "VC_CreditType.h"

#define PublishBid_AP1 @"Aptitude1"
#define PublishBid_AP2 @"Aptitude2"
#define PublishBid_AP3 @"Aptitude3"

@interface VC_QueryQualification (){
    NSMutableArray *_arr_Input;
    NSInteger _IsMatchAny;
    NSMutableDictionary *_dic_data;
     BidService *_bidService;
    NSMutableDictionary *_dic_qualitySelected;
    QualificaService *_qualificaService;
    CompanyListDomian *companyListDomian;
     NSMutableArray *_arr_newCompany;
    NSMutableArray *credit2_list ;
    int _page;
     NSInteger _RequiredAttention;
}

@end

@implementation VC_QueryQualification
-(void)initData{
    _arr_Input = [NSMutableArray arrayWithObjects:@{kCellKey: kBidRegion, kCellName: @"选择省市", kCellDefaultText: @"请选择企业所在省市", kCellEditType: EditType_RegionChoice},
        @{kCellKey: kBidRegionType, kCellName: @"本外地企业", kCellDefaultText: @"", kCellEditType: EditType_None},
                  @{kCellKey: kBidIsMatchAny, kCellName: @"企业资质", kCellDefaultText: @"", kCellEditType: EditType_None},
                  @{kCellKey: PublishBid_AP1, kCellName: @"资质一", kCellDefaultText: @"请选择资质类型及等级", kCellEditType: EditType_APChoice},
                  @{kCellKey: PublishBid_AP2, kCellName: @"资质二", kCellDefaultText: @"请选择资质类型及等级", kCellEditType: EditType_APChoice},
                  @{kCellKey: PublishBid_AP3, kCellName: @"资质三", kCellDefaultText: @"请选择资质类型及等级", kCellEditType: EditType_APChoice},
                  @{kCellKey: KCredit, kCellName: @"诚信得分", kCellDefaultText: @"选择诚信得分要求", kCellEditType: EditType_CSChoice}, nil];
    _page=1;
    _RequiredAttention = 0;
    _dic_data = [NSMutableDictionary dictionaryWithCapacity:_arr_Input.count];
    _bidService = [BidService sharedService];
    _qualificaService=[QualificaService sharedService];
    _arr_newCompany=[[NSMutableArray alloc]init];
    credit2_list=[[NSMutableArray alloc]init];
    _dic_qualitySelected = [NSMutableDictionary dictionary];
//    [self CompanyData];
}
-(void)layoutUI{
    _tableView.rowHeight=48;
    [self hideTableViewFooter:_tableView];
    if (IS_IPHONE_4_OR_LESS) {
        _layout_companyHeight.constant=45;
        _layout_btnBottom.constant=2;
    }else if(IS_IPHONE_6P){
        _layout_btnBottom.constant=32;
    }else if(IS_IPHONE_5){
        _layout_btnBottom.constant=8.5;
        
    }
    
    [_tf_companyName setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
  
}
-(void)CompanyData{
   [_qualificaService companyRegistresult:^(NSArray<CompanyListDomian *> *bidList, NSInteger code) {
       if (code != 1) {
           return ;
       }
       [_arr_newCompany addObjectsFromArray:bidList];
       NewCompanyView *newCompany = [NewCompanyView viewWithArray:_arr_newCompany delegate:self];
       newCompany.frame = CGRectMake(0, 64, self.view.bounds.size.width, 40);
       [newCompany startRuning];
       self.topView.hidden=YES;
       [self.view addSubview:newCompany];
   } ] ;
}
#pragma mark - Top Company View Click Delegate
- (void)showNewCompanyWithDomain:(CompanyListDomian *)domain {
    [CommonUtil jxWebViewShowInController:self loadUrl:domain.Url backTips:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"资质查询";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arr_Input count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID2 = @"Cell_QueryOtherAttribute";
    static NSString *CellID3 = @"Cell_PublishBid_Radio";
    static NSString *CellID4 = @"Cell_PublishBidRadio3";

    NSDictionary *dic_input = [_arr_Input  objectAtIndex:indexPath.row];
    NSString *key = dic_input[kCellKey];
    NSString *name = dic_input[kCellName];
    NSString *editType = dic_input[kCellEditType];
    Cell_QueryOtherAttribute *cell_otherattribute = [tableView dequeueReusableCellWithIdentifier:CellID2];
    Cell_PublishBidRadio *cell_radio = [tableView dequeueReusableCellWithIdentifier:CellID3];

   if ([key isEqualToString:kBidIsMatchAny]){
        cell_radio.delegate = self;
        cell_radio.type = _IsMatchAny;
        return cell_radio;

   } else if ([key isEqualToString:kBidRegionType]) {
       //企业要求
       Cell_PublishBidRadio3 *cell = [tableView dequeueReusableCellWithIdentifier:CellID4];
       cell.dic=_dic_data[kBidRegion];
       cell.pushType=1;
       cell.delegate = self;
       cell.type = _RequiredAttention;
       return cell;
       
   }
   else{
        UIColor *detailTextColor = [UIColor colorWithHex:@"333333"];
        NSString *text = _dic_data[key];
        if (text == nil || [text isEmptyString]) {
            text = dic_input[kCellDefaultText];
            detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
        }
       
       if ([EditType_CSChoice isEqualToString:editType]) {
           text = @"请输入诚信得分";
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
                   text = [NSString stringWithFormat:@"已输入%d项", i];
                   detailTextColor = [UIColor colorWithHex:@"333333"];
               }
           }
//           NSArray *tmpArray = _dic_data[key];
////           if (tmpArray != nil && tmpArray.count > 0) {
////               text = [NSString stringWithFormat:@"已选择%lu项", tmpArray.count];
////               
////           }
//            int i = 0;
//         for (NSDictionary *paramDic in tmpArray) {
//               if (![paramDic[kCommonValue] isEqualToString:@"请选择"]) {
//                   i++;
//               }
//           }
//           if (i == 0) {
//               text=[NSString stringWithFormat:@"请输入诚信得分"];
//               detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
//           }else{
//            text=[NSString stringWithFormat:@"已输入%d项", i];
//           }

       } else if ([EditType_RegionChoice isEqualToString:editType] ) {
           NSDictionary *dic = _dic_data[key];
           if (dic != nil) {
               text = dic[kCommonValue];
           }
       }
       else if ([EditType_APChoice isEqualToString:editType]) {
           NSDictionary *dic = _dic_data[key];
           if (dic != nil && ![dic[kCommonKey] isEmptyString]) {
               text = dic[kCommonValue];
           }
       }
       cell_otherattribute.lb_name.text=name;
       cell_otherattribute.lb_detailText.textColor = detailTextColor;
        cell_otherattribute.lb_detailText.text = text;
        return cell_otherattribute;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arr_Input objectAtIndex:indexPath.row];
    NSString *editType = tmpDic[kCellEditType];
    if ([EditType_CSChoice isEqualToString:editType]) {
        [self handelkCreditWithIndexPath:indexPath withDic:tmpDic];
    }else if ([EditType_RegionChoice isEqualToString:editType]) {
        [self regionChoiceWithDic:tmpDic indexPath:indexPath];
    }else if ([EditType_APChoice isEqualToString:editType]) {
        [self apChoiceWithDic:tmpDic indexPath:indexPath];
    }
    
}
- (void)regionChoiceWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    [_bidService getRegionToResult:^(NSArray<KeyValueDomain *> *regionList, NSInteger code) {
        if (code != 1) {
            return;
        }
        VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
//        vc_choice.type=@"0";
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
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:vc_choice animated:YES];
    }];
}
- (void)handelkCreditWithIndexPath:(NSIndexPath *)indexPath withDic:(NSDictionary *)dic {
    if (_dic_data[kBidRegion] == nil) {
        [ProgressHUD showInfo:@"请先选择区域" withSucc:NO withDismissDelay:2];
        return;
    }
    NSString *editType = dic[kCellEditType];
    NSString *key = dic[kCellKey];
    if ([EditType_CSChoice isEqualToString:editType]){
        if (_dic_data[key] != nil) {
            [credit2_list addObject:_dic_data[key]];
        }

    [self handleCredit2WithIndexPath:indexPath key:key credit2:credit2_list];
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


/**
 *  资质选择---同时具备和任意满足
 *
 */
- (void)choiceRadioResult:(NSInteger)result {
    _IsMatchAny = result;
}
/**
 *  本外地企业区分
 */
- (void)choiceRadio3Result:(NSInteger)result {
     _RequiredAttention = result;
}
- (void)reloadIndexPath:(NSIndexPath *)indexPath {
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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

- (IBAction)btn_query_press:(id)sender {
    
    if ([CommonUtil isLogin]) {
        [CountUtil countSearchCompany];
        
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        if (_dic_data[PublishBid_AP1] == nil) {
            [paramDic setObject:@"" forKey:PublishBid_AP1];
        }else{
            [paramDic setObject:_dic_data[PublishBid_AP1][kCommonKey] forKey:PublishBid_AP1];
        }
        if (_dic_data[PublishBid_AP2] == nil) {
            [paramDic setObject:@"" forKey:PublishBid_AP2];
        }else{
            [paramDic setObject:_dic_data[PublishBid_AP2][kCommonKey] forKey:PublishBid_AP2];
        }
        if (_dic_data[PublishBid_AP3] == nil) {
            [paramDic setObject:@"" forKey:PublishBid_AP3];
        }else{
            [paramDic setObject:_dic_data[PublishBid_AP3][kCommonKey] forKey:PublishBid_AP3];
        }
//        for (NSDictionary *tmpDic in _dic_data[KCredit]) {
//            NSString *key = tmpDic.allKeys.firstObject;
//            if (![tmpDic[kCommonValue] isEqualToString:@"请选择" ]) {
//                [paramDic setObject:tmpDic[key]  forKey:key];
//            }
//            
//        }
        if (_dic_data[KCredit] != nil) {
            [paramDic setObject:_dic_data[KCredit] forKey:KCredit];
        }
        
        [paramDic setObject:@(_page) forKey:kPage];
        NSDictionary *region = _dic_data[kBidRegion];
        if (region != nil) {
            [paramDic setObject:region[kCommonKey] forKey:kBidRegionCode];
        }
        
       [paramDic setObject:@(_RequiredAttention) forKey:KRegionType];
        [paramDic setObject:@(_IsMatchAny) forKey:kBidIsMatchAny];
        if (![self.tf_companyName.text.trimWhitesSpace isEqualToString:@""]) {
            [paramDic setObject:self.tf_companyName.text.trimWhitesSpace forKey:kCompanyName];
            [_dic_data setObject:self.tf_companyName.text.trimWhitesSpace forKey:kCompanyName];
        }else{
            [paramDic removeObjectForKey:kCommonKey];
            [_dic_data removeObjectForKey:kCompanyName];
        }
        if ([self checkMustInput]) {
            [_qualificaService queryQualificaListWithParameters:paramDic result:^(QualificaDomian *responseBid, NSInteger code) {
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
    } else {
        [PageJumpHelper presentLoginViewController];
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
    
//    if (_dic_data[PublishBid_AP1]==nil || _dic_data[PublishBid_AP2]==nil|| _dic_data[PublishBid_AP3]==nil|| _dic_data[KCredit]==nil) {
//        [ProgressHUD showInfo:@"" withSucc:NO withDismissDelay:2];
//        return NO;
//    }
    
    return YES;
}
@end
