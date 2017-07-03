//
//  VC_AddEditCompany.m
//  自由找
//
//  Created by xiaoqi on 16/7/8.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_AddEditCompany.h"

#import "VC_AddCompany.h"
#import "VC_TextInput.h"
#import "VC_Choice.h"
#import "VC_APList.h"
#import "BidService.h"
#import "MineService.h"
#import "VC_CreditScore.h"
#import "InCompanyService.h"
#import "VC_TextField.h"
#import "VC_CreditType.h"
static NSString *CellIdentifier = @"Cell_AddEditCompany";
@interface VC_AddEditCompany (){
    NSMutableArray *_arr_Input;
    NSMutableDictionary *_dic_data;
    BidService *_bidService;
    MineService *_mineService;
    InCompanyService *_inCompanyService;
    UIBarButtonItem *_rightItem;
    UserDomain *_user;
    SiteDomain *_site;
    AptitudesDomain *_aptitudes;
    EnterpriseDomain *_enterpriseDomain;
    NSMutableArray *_aptitudesArray;

    /**
     *  1 -- 从资质需求报名处进来，选择后可直接进行报名, 0 -- 从我所在的企业处进来, 3 -- 从资质查询详情中进来,
     */
    NSInteger _type;
}
@end

@implementation VC_AddEditCompany

- (void)viewDidLoad {
    [super viewDidLoad];
     if ([self.parameters[@"type"]integerValue] ==1) {
      self.jx_title = @"添加企业";
     }else{
      self.jx_title = @"更正信息";
     }
    
    _type = [[self.parameters objectForKey:kPageType] integerValue];
    
    
    [self zyzOringeNavigationBar];
    [self loadData];
    [self layoutUI];
    
    
    
    if (_type == 3) {
        NSString *companyName = [self.parameters objectForKey:kPageDataDic];
        [self searchByName:companyName];
    }
}

- (void)searchByName:(NSString *)companyName {
    NSDictionary *paramDic=@{kCompanyName:companyName,kPage:@(1)};
    [_inCompanyService inCompanywithParamters:paramDic result:^(NSArray<InCompanyDomain *> *user, NSInteger code) {
        if (code != 1) {
            return ;
        }
        
        if (user.count>0) {
            
            VC_AddCompany *vc_AddCompany =[self.storyboard instantiateViewControllerWithIdentifier:@"VC_AddCompany"];
            NSDictionary *dic=@{kCompanyName:companyName};
            vc_AddCompany.parameters=@{kPageDataDic:dic, kPageType: @(_type),kContainAptitudes:@(1)};
            vc_AddCompany.addCompanyBlock=^(NSString *companyString){
                if (companyString.length>0) {
                    [_dic_data setObject:companyString forKey:kCompanyName];
                    [_tableView reloadData];
                }
            };
            [self.navigationController pushViewController:vc_AddCompany animated:YES];
            
        }else{
            [_dic_data setObject:companyName forKey:kCompanyName];
            [_tableView reloadData];
        }
    }];
}

-(void)loadData{
    _user = [CommonUtil getUserDomain];
   _site=_user.Sites.firstObject;
    _enterpriseDomain=_site.Enterprise;
    _aptitudesArray=[NSMutableArray arrayWithArray:_enterpriseDomain.CompanyAptitudes];
    
    if ([self.parameters[@"type"]integerValue] ==1) {
        _arr_Input = [NSMutableArray arrayWithObjects:
                      @{kCellKey: kCompanyName, kCellName: @"企业名称", kCellDefaultText:@"请输入企业全称", kCellEditType: EditType_TextField},
                      @{kCellKey: kPlaceOfOrign, kCellName: @"注册地", kCellDefaultText: @"请选择注册地", kCellEditType: EditType_RegisterAdress},
                      @{kCellKey: kCustomerAptitudes, kCellName: @"企业资质", kCellDefaultText: @"请选择企业资质", kCellEditType: EditType_APChoice},
                      @{kCellKey: kFilingArea, kCellName: @"经营区域", kCellDefaultText: @"请选择经营区域", kCellEditType: EditType_RegionChoice} ,@{kCellKey: KCredit, kCellName: @"诚信得分", kCellDefaultText: @"请选择诚信得分要求", kCellEditType: EditType_CSChoice},nil];
        _dic_data = [NSMutableDictionary dictionaryWithCapacity:_arr_Input.count];
    }else{
            _arr_Input = [NSMutableArray arrayWithObjects:
                       @{kCellKey: kFilingArea, kCellName: @"经营区域", kCellDefaultText:_site.Location.Value, kCellEditType: EditType_RegionChoice},
                      @{kCellKey: kCustomerAptitudes, kCellName: @"企业资质", kCellDefaultText: @"请选择企业资质", kCellEditType: EditType_APChoice},
                      @{kCellKey: KCredit, kCellName: @"诚信得分", kCellDefaultText:@"请选择诚信得分", kCellEditType: EditType_CSChoice},
                      nil];
        _dic_data = [NSMutableDictionary dictionaryWithCapacity:_arr_Input.count];
        [_dic_data setObject:[_site.Location toDictionary] forKey:kFilingArea];
        if (_aptitudesArray.count >0) {
            [self aptitudesData];
        }
        if (_site.Credits.count >0) {
             [self creditsData];
        }
        
    }

    _bidService=[BidService sharedService];
    _mineService=[MineService sharedService];
    _inCompanyService=[InCompanyService sharedService];
   

}
-(void)creditsData{
    
//     NSMutableArray *array=[[NSMutableArray alloc]init];
//    for (NSDictionary *dic in _site.Credits) {
//        NSMutableDictionary *creditsdic = [[NSMutableDictionary alloc]init];
//        NSMutableString *checkString=[NSMutableString stringWithFormat:@"%@",dic[kCommonKey]];
//        [checkString deleteCharactersInRange:NSMakeRange(0,6)];
//        [creditsdic setObject:dic[kCredit2DisplayName] forKey:kCredit2DisplayName];
//        [creditsdic setObject:dic[kCommonValue] forKey:kCommonValue];
//        if (dic[kCommonValue] != nil && ![dic[kCommonValue] isEqualToString:@""]  ) {
//            NSMutableDictionary *dicc=[[NSMutableDictionary alloc]init];
//            [dicc setObject:creditsdic forKey:checkString];
//            [array addObject:dicc];
//        }
//        
//    }
    [_dic_data setObject:_site.Credits forKey:KCredit];
   
}
-(void)aptitudesData{
    NSMutableArray *array=[[NSMutableArray alloc]init];
      for (int i=0; i<_aptitudesArray.count; i++) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        _aptitudes=[_aptitudesArray objectAtIndex:i];
        [dic setObject:_aptitudes.AptitudeKey forKey:kCommonKey];
        NSString *valueString=[NSString stringWithFormat:@"%@/%@",_aptitudes.AptitudeName,_aptitudes.AptitudeGrade];
        [dic setObject:valueString forKey:kCommonValue];
         [dic setObject:_aptitudes.AptitudeKey forKey:kTopKey];
        [array addObject:dic];
    }
    [_dic_data setObject:array forKey:kCustomerAptitudes];
}
-(void)layoutUI{
    _tableView.rowHeight=48;
    if ([self.parameters[@"type"]integerValue] ==1) {
    _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightItem_press)];
    
    }else{
     _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItem_typezero_press)];
    }
    _rightItem.tintColor=[UIColor whiteColor];
    [self setNavigationBarRightItem:_rightItem];
    [self hideTableViewFooter:_tableView];
}
#pragma mark -更正信息
-(void)rightItem_typezero_press{
    if ([self resultCheck2]) {
        [self creditOraptt];
    }
}
#pragma mark -更正经营区域
-(void)changeRegion{
    if (_dic_data[kFilingArea] !=nil) {
        NSDictionary *dicregion=@{kBidRegionCode:[_dic_data[kFilingArea] objectForKey:kCommonKey]};
        [_inCompanyService userchangecompanyregion:dicregion result:^(NSUInteger code) {
            if(code != 1) {
                return;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_Deatil_DATA" object:nil];
            [ProgressHUD showInfo:@"经营区域更正成功" withSucc:YES withDismissDelay:2];
            [self goBack];
     }];
  }

}
-(void)creditOraptt{
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
    [paramDic setObject:_site.CompanyId forKey:kCompanyID];
    if([_dic_data.allKeys containsObject:kCustomerAptitudes]){
        [paramDic setObject:_dic_data[kCustomerAptitudes] forKey:kAptitude];
    }
    NSMutableDictionary *creditDic=[[NSMutableDictionary alloc]init];
    
    for (NSString *creditKey in [_dic_data[KCredit] allKeys]) {
        NSDictionary *tmpDic = _dic_data[KCredit][creditKey];
        if ([tmpDic isKindOfClass:[NSDictionary class]]) {
            [creditDic setObject:tmpDic[kCommonKey] forKey:creditKey];
        } else {
            [creditDic setObject:@"" forKey:creditKey];
        }
    }
    
//        for (NSDictionary *tmpDic in _dic_data[KCredit]) {
//            for ( NSString *checkString in tmpDic.allKeys) {
//                if ([tmpDic[checkString] isKindOfClass:[NSString class]]) {
//                    [creditDic setObject:@""  forKey:checkString];
//                } else {
//                    NSString *keyString=[[tmpDic objectForKey:checkString]objectForKey:kCommonKey];
//                    if (keyString !=nil) {
//                        [creditDic setObject:keyString  forKey:checkString];
//                    }
//                }
//            }
//        }
        [paramDic setObject:creditDic forKey:KCredit];

        [_mineService modifyCompanyWithParameters:paramDic result:^(NSInteger code) {
            if (code != 1) {
                return ;
            }
            if (_type == 3 || _type == 4) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Reload_Company_Detail" object:nil];
                [ProgressHUD showInfo:@"修改成功" withSucc:YES withDismissDelay:2];
            }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_Deatil_DATA" object:nil];
            [ProgressHUD showInfo:@"更正成功" withSucc:YES withDismissDelay:2];
            [self goBack];
        }];
   
}
#pragma mark -添加企业－编辑资料
-(void)rightItem_press{
    if([self resultCheck]){
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
    [paramDic setObject:_dic_data[kCompanyName] forKey:kEntName];
    [paramDic setObject:_user.Phone forKey:kCustomerPhone];
    [paramDic setObject:_dic_data[kCustomerAptitudes] forKey:kAptitude];
    [paramDic setObject:_dic_data[kFilingArea] forKey:kFilingArea];
    [paramDic setObject:_dic_data[kPlaceOfOrign] forKey:kPlaceOfOrign];
    NSMutableDictionary *creditDic=[[NSMutableDictionary alloc]init];
        for (NSString *creditKey in [_dic_data[KCredit] allKeys]) {
            NSDictionary *tmpDic = _dic_data[KCredit][creditKey];
            if ([tmpDic isKindOfClass:[NSDictionary class]]) {
                [creditDic setObject:tmpDic[kCommonKey] forKey:creditKey];
            }
        }
//    NSMutableDictionary *creditDic=[[NSMutableDictionary alloc]init];
//        for (NSString *creditKey in [_dic_data[KCredit] allKeys]) {
//            NSDictionary *tmpDic = creditDic[creditKey];
//            if ([tmpDic isKindOfClass:[NSDictionary class]]) {
//                [creditDic setObject:tmpDic[kCommonKey] forKey:creditKey];
//            }
//        }
//
//        for (NSDictionary *tmpDic in _dic_data[KCredit]) {
//            for ( NSString *checkString in tmpDic.allKeys) {
//                    NSString *keyString=[[tmpDic objectForKey:checkString]objectForKey:kCommonKey];
//                [creditDic setObject:keyString  forKey:checkString];
//                }
//                
//            }
    
     
//        NSMutableDictionary *creditDic=[[NSMutableDictionary alloc]init];
//        
//        for (NSString *creditKey in [_dic_data[KCredit] allKeys]) {
//            NSDictionary *tmpDic = _dic_data[KCredit][creditKey];
//            if ([tmpDic isKindOfClass:[NSDictionary class]]) {
//                [creditDic setObject:tmpDic[kCommonKey] forKey:creditKey];
//            } else {
//                [creditDic setObject:@"" forKey:creditKey];
//            }
//        }
//        NSMutableDictionary *creditDic=[[NSMutableDictionary alloc]init];
//        for (NSString *creditKey in [_dic_data[KCredit] allKeys]) {
//            NSDictionary *tmpDic = _dic_data[KCredit][creditKey];
//            if ([tmpDic isKindOfClass:[NSDictionary class]]) {
//                if(![tmpDic[kCommonKey] isEqualToString:@"0.00"]){
//                    [creditDic setObject:tmpDic[kCommonKey] forKey:creditKey];
//                }else{
//                    [creditDic setObject:@"" forKey:creditKey];
//                }
//            } else {
//                [creditDic setObject:@"" forKey:creditKey];
//            }
//        }
         [paramDic setObject:creditDic forKey:KCredit];
        
        [paramDic setObject:[CommonUtil getUserDomain].Phone forKey:@"Phone"];
        __block VC_AddEditCompany *weakSelf = self;
        if (_user.Sites != nil && _user.Sites.count>0) {
//            [_mineService unbindCompanyToResult:^(NSInteger code) {
//                if (code==1) {
//                    [_mineService addNewCompanyWithParameters:paramDic result:^(NSInteger code) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_ARR_DATA" object:nil];
//                        if (_type == 1) {
//                            [JAlertHelper jAlertWithTitle:@"添加企业成功，待审核通过后才可报名，请耐心等待" message:nil cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:weakSelf clickAtIndex:^(NSInteger buttonIndex) {
//                                [weakSelf goBack];
//                            }];
//                        } else {
//                            if (_type == 3 || _type == 4) {
//                                [[NSNotificationCenter defaultCenter] postNotificationName:@"Reload_Company_Detail" object:nil];
//                                [ProgressHUD showInfo:@"修改成功" withSucc:YES withDismissDelay:2];
//                            } else {
//                                [ProgressHUD showInfo:@"添加成功" withSucc:YES withDismissDelay:2];
//                            }
//                            [weakSelf goBack];
//                        }
//                    
//                    }];
//                }
//            }];
            
            [_mineService addNewCompanyWithParameters:paramDic result:^(NSInteger code) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_ARR_DATA" object:nil];
                if (_type == 1) {
                    [JAlertHelper jAlertWithTitle:@"添加企业成功，待审核通过后才可报名，请耐心等待" message:nil cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:weakSelf clickAtIndex:^(NSInteger buttonIndex) {
                        [weakSelf goBack];
                    }];
                } else {
                    if (_type == 3 || _type == 4) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"Reload_Company_Detail" object:nil];
                        [ProgressHUD showInfo:@"修改成功" withSucc:YES withDismissDelay:2];
                    } else {
                        [ProgressHUD showInfo:@"添加成功" withSucc:YES withDismissDelay:2];
                    }
                    [weakSelf goBack];
                }
                
            }];
        }else{
            [_mineService addNewCompanyWithParameters:paramDic result:^(NSInteger code) {
                if (code != 1) {
                    return ;
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RE_ARR_DATA" object:nil];
                if (_type == 1) {
                    [JAlertHelper jAlertWithTitle:@"添加企业成功，待审核通过后才可报名，请耐心等待" message:nil cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:weakSelf clickAtIndex:^(NSInteger buttonIndex) {
                        [weakSelf goBack];
                    }];
                } else {
                    [ProgressHUD showInfo:@"添加成功" withSucc:YES withDismissDelay:2];
                    [weakSelf goBack];
                }
                
            }];
        }
      
    }
}
#pragma mark - tableviewx datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_Input.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell_AddEditCompany*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *tmpDic = [_arr_Input objectAtIndex:indexPath.row];
    NSString *key = tmpDic[kCellKey];
    NSString *text = tmpDic[kCellDefaultText];
    cell.lb_name.text = tmpDic[kCellName];
    NSString *editType = tmpDic[kCellEditType];
    if ([self.parameters[@"type"]integerValue] ==1) {
         if ([EditType_RegisterAdress isEqualToString:editType] ) {
            NSDictionary *dic = _dic_data[key];
            if (dic != nil) {
                text = dic[kCommonValue];
            }
         }else if ([EditType_CSChoice isEqualToString:editType] ) {
             text=[NSString stringWithFormat:@"请输入诚信得分"];
             UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
             NSInteger count = 0;
             if (_dic_data[key] != nil) {
                 NSDictionary *tmpDic = _dic_data[key];
                 for (NSString *creditKey in tmpDic.allKeys) {
                     NSObject *obj = tmpDic[creditKey];
                     if ([obj isKindOfClass:[NSDictionary class]]) {
                         NSDictionary *tmpDic1 =tmpDic[creditKey];
                         if (![tmpDic1[kCommonKey] isEqualToString:@"0.00"]) {
                             count ++;

                         }
                    }
                 }
                 if (count > 0) {
                     text=[NSString stringWithFormat:@"已输入%lu项",(long)count];
                     detailTextColor = [UIColor colorWithHex:@"333333"];
                 }
             }
             cell.lb_detail.textColor = detailTextColor;
//             NSArray *tmpArray = _dic_data[key];
//             NSInteger count = 0;
//            for (int i = 0; i < tmpArray.count; i++) {
//                 NSDictionary *dic = tmpArray[i];
//                 NSObject *obj = dic.allValues.firstObject;
//                 if ([obj isKindOfClass:[NSDictionary class]]) {
//                     count ++;
//                 }
//             }
//             if (count>0) {
//                   text=[NSString stringWithFormat:@"已输入%lu项",count];
//             }else{
//                 text=[NSString stringWithFormat:@"请输入诚信得分"];
//                 cell.lb_detail.textColor = [UIColor colorWithHex:@"bbbbbb"];
//
//             }
             
         } else if ([EditType_APChoice isEqualToString:editType ]) {
             NSArray *tmpArray = _dic_data[key];
             int i = 0;
             if (tmpArray != nil && tmpArray.count > 0) {
                 for (NSDictionary *paramDic in tmpArray) {
                     if (![paramDic[kCommonValue] isEqualToString:@"请选择"] && paramDic[kCommonValue] !=nil) {
                         i++;
                     }
                 }
                 if (i == 0) {
                     text=@"请选择资质";
                     cell.lb_detail.textColor = [UIColor colorWithHex:@"bbbbbb"];
                 }else{
                     text = [NSString stringWithFormat:@"已选择%lu项资质", (unsigned long)tmpArray.count];
                 }
             }
         }else if ([EditType_TextField isEqualToString:editType] ) {
             if (_dic_data[key] != nil && ![_dic_data[key] isEmptyString]) {
                 text = _dic_data[key];
             }
         }else if ([EditType_RegionChoice isEqualToString:editType] ) {
             NSDictionary *dic = _dic_data[key];
             if (dic != nil) {
                 text = dic[kCommonValue];
             }
         }
    }else{
        if ([EditType_RegionChoice isEqualToString:editType] ) {
            NSDictionary *dic = _dic_data[key];
            if (dic != nil) {
                text = dic[kCommonValue];
            }
        }
        else if ([EditType_CSChoice isEqualToString:editType] ) {
            text=[NSString stringWithFormat:@"请输入诚信得分"];
            UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
            NSInteger count = 0;
            if (_dic_data[key] != nil) {
                NSDictionary *tmpDic = _dic_data[key];
                for (NSString *creditKey in tmpDic.allKeys) {
                    NSObject *obj = tmpDic[creditKey];
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *tmpDic2 = (NSDictionary *)obj;
                        if (![tmpDic2[kCommonKey] isEmptyString]) {
                            if (![tmpDic2[kCommonKey] isEqualToString:@"0.00"]) {
                                count ++;
                                
                            }
                        }
                    }
                }
                if (count > 0) {
                    text=[NSString stringWithFormat:@"已输入%lu项",(long)count];
                    detailTextColor = [UIColor colorWithHex:@"333333"];
                }
            }
            cell.lb_detail.textColor = detailTextColor;
//            NSArray *tmpArray = _dic_data[key];
//            NSInteger count = 0;
//            for (int i = 0; i < tmpArray.count; i++) {
//                NSDictionary *dic = tmpArray[i];
//                NSObject *obj = dic.allValues.firstObject;
//                if ([obj isKindOfClass:[NSDictionary class]]) {
//                    count ++;
//                }
//            }
//            if (count>0) {
//                text=[NSString stringWithFormat:@"已输入%lu项",count];
//            }else{
//                
//                text=[NSString stringWithFormat:@"请输入诚信得分"];
//                cell.lb_detail.textColor = [UIColor colorWithHex:@"bbbbbb"];
//                
//            }
            
        }else if ([EditType_APChoice isEqualToString:editType]) {
            NSArray *tmpArray = _dic_data[key];
            int i = 0;
            if (tmpArray != nil && tmpArray.count > 0) {
                for (NSDictionary *paramDic in tmpArray) {
                    if (![paramDic[kCommonValue] isEqualToString:@"请选择"] && paramDic[kCommonValue] !=nil) {
                        i++;
                    }
                }
                if (i == 0) {
                    text=@"请选择资质";
                    cell.lb_detail.textColor = [UIColor colorWithHex:@"bbbbbb"];
                }else{
                  text = [NSString stringWithFormat:@"已选择%lu项资质", (unsigned long)tmpArray.count];
                }
            }
        }
        

    }
    
    cell.lb_detail.text = text;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arr_Input objectAtIndex:indexPath.row];
    NSString *editType = tmpDic[kCellEditType];
    if ([self.parameters[@"type"]integerValue] ==1) {
         if ([EditType_RegisterAdress isEqualToString:editType]) {
            [self regionChoiceWithDic:tmpDic indexPath:indexPath];
         }else if ([EditType_TextField isEqualToString:editType]){
          [self textFieldWithDic:tmpDic indexPath:indexPath];
         }else if ([EditType_RegionChoice isEqualToString:editType]) {
             
             [self regionChoiceWithDic:tmpDic indexPath:indexPath];
         }
    }else{
        if ([EditType_RegionChoice isEqualToString:editType]) {
            [JAlertHelper jAlertWithTitle:@"改变经营区域需要重新申请认领，是否修改？" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"确定"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
                if (buttonIndex==1) {
                    [self regionChoiceWithDic:tmpDic indexPath:indexPath];
                }
            }];
            
        }
    }
     if ([EditType_APChoice isEqualToString:editType]) {
        [self APWithDic:tmpDic indexPath:indexPath];
    } else if ([EditType_CSChoice isEqualToString:editType]){
       [self handelkCreditWithIndexPath:indexPath withDic:tmpDic];
    }
}
- (void)textFieldWithDic:(NSDictionary *)tmpDic indexPath:(NSIndexPath *)indexPath {
    VC_TextField *vc = [self getVC_TextField];
    vc.type = INPUT_TYPE_NORMAL;
//    vc.minCount=6;
    NSString *text = _dic_data[tmpDic[kCellKey]];
    if (text != nil && ![text isEmptyString]) {
        vc.text = text;
    }
    if ([text isEqualToString:@"请输入企业全称"]) {
        vc.text=@"";
    }
    vc.jTitle = tmpDic[kCellDefaultText];
    vc.placeholder = tmpDic[kCellDefaultText];
    vc.inputBlock = ^(NSString *text) {
        if ([text isEmptyString]) {
            return ;
        }
        NSDictionary *paramDic=@{kCompanyName:text,kPage:@(1)};
        [_inCompanyService inCompanywithParamters:paramDic result:^(NSArray<InCompanyDomain *> *user, NSInteger code) {
            if (code != 1) {
                return ;
            }
            
            if (user.count>0) {
               
                VC_AddCompany *vc_AddCompany =[self.storyboard instantiateViewControllerWithIdentifier:@"VC_AddCompany"];
                NSDictionary *dic=@{kCompanyName:text};
                vc_AddCompany.parameters=@{kPageDataDic:dic, kPageType: @(_type),kContainAptitudes:@(1)};
                vc_AddCompany.addCompanyBlock=^(NSString *companyString){
                    if (companyString.length>0) {
                        [_dic_data setObject:companyString forKey:tmpDic[kCellKey]];
                        [self reloadIndexPath:indexPath];
                    }
                };
                [self.navigationController pushViewController:vc_AddCompany animated:YES];
                
            }else{
                [_dic_data setObject:text forKey:tmpDic[kCellKey]];
                [self reloadIndexPath:indexPath];
            }
        }];

       
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (VC_TextField *)getVC_TextField {
    return [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_TextField"];
}
- (void)APWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    if ([self.parameters[@"type"]integerValue] ==1) {
        if(_dic_data[kCompanyName]==nil || [_dic_data[kCompanyName] isEqualToString:@"请输入企业全称"]){
            [ProgressHUD showInfo:@"请输入企业全称" withSucc:NO withDismissDelay:2];
            return;
        }
    }

    VC_APList *apList = [[self storyboard] instantiateViewControllerWithIdentifier:@"VC_APList"];
    NSString *key = dic[kCellKey];
    NSArray *tmpArray = _dic_data[key];
    if (tmpArray != nil && tmpArray.count > 0) {
        apList.arr_quality = [NSMutableArray arrayWithArray:tmpArray];
    }
    apList.multiQuality = ^(NSArray *resultArray) {
        [_dic_data setObject:resultArray forKey:key];
        [self reloadIndexPath:indexPath];
    };
    [self.navigationController pushViewController:apList animated:YES];
}
- (void)regionChoiceWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    if ([self.parameters[@"type"]integerValue] ==1) {
        if(_dic_data[kCompanyName]==nil || [_dic_data[kCompanyName] isEqualToString:@"请输入企业全称"]){
            [ProgressHUD showInfo:@"请输入企业全称" withSucc:NO withDismissDelay:2];
            return;
        }
    }
    [_bidService getRegionToResult:^(NSArray<KeyValueDomain *> *regionList, NSInteger code) {
        if (code != 1) {
            return;
        }
        VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
        if ([self.parameters[@"type"]integerValue] !=1){
           vc_choice.nav_title=@"选择经营区域";
        }else{
            if ([dic[kCellKey]isEqualToString:kPlaceOfOrign]) {
                vc_choice.nav_title=@"请选择注册地";
            }else if ([dic[kCellKey]isEqualToString:kFilingArea]){
                vc_choice.nav_title=@"选择经营区域";
            }
        }
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
            if ([self.parameters[@"type"]integerValue] !=1) {
                [self changeRegion];
            }
        };
        [self.navigationController pushViewController:vc_choice animated:YES];
    }];
}
- (void)handelkCreditWithIndexPath:(NSIndexPath *)indexPath withDic:(NSDictionary *)dic {
    if ([self.parameters[@"type"]integerValue] ==1) {
    if (_dic_data[kFilingArea] == nil) {
        [ProgressHUD showInfo:@"请先选择区域" withSucc:NO withDismissDelay:2];
        return;
    }
        if(_dic_data[kCompanyName]==nil || [_dic_data[kCompanyName] isEqualToString:@"请输入企业全称"]){
            [ProgressHUD showInfo:@"请输入企业全称" withSucc:NO withDismissDelay:2];
            return;
        }
    }
    NSString *editType = dic[kCellEditType];
    NSString *key = dic[kCellKey];
    if ([EditType_CSChoice isEqualToString:editType]){
        
        [self handleCredit2WithIndexPath:indexPath key:key ];
    }
}
- (void)handleCredit2WithIndexPath:(NSIndexPath *)indexPath key:(NSString *)key {
//    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil];
//    VC_CreditScore *vc_CreditScore=[storyboard instantiateViewControllerWithIdentifier:@"VC_CreditScore"];
//    if ([self.parameters[@"type"]integerValue] ==1) {
//         vc_CreditScore.selectArray = _dic_data[key];
//    }else{
//        vc_CreditScore.selectArray = _dic_data[key];
//        vc_CreditScore.type=1;
//    }
//    vc_CreditScore.credit2Result = ^(NSArray *resultArray){
//        [_dic_data setObject:resultArray forKey:key];
//        [self reloadIndexPath:indexPath];
//    };
//    [self.navigationController pushViewController:vc_CreditScore animated:YES];
    VC_CreditType *vc = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_CreditType"];
    vc.dic_data = _dic_data[key] == nil ? @{} : _dic_data[key];
    vc.regionCode = _dic_data[kFilingArea][kCommonKey];
    vc.type = 1;
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

- (void)reloadIndexPath:(NSIndexPath *)indexPath {
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (NSString *)stringWithInt:(int)number {
    return [NSString stringWithFormat:@"%d", number];
}
-(BOOL)resultCheck{
    if (_dic_data[kCompanyName] == nil || [_dic_data[kCompanyName] isEqualToString:@"请输入企业全称"]) {
        [ProgressHUD showInfo:@"请输入企业全称" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[kPlaceOfOrign] == nil) {
        [ProgressHUD showInfo:@"请选择注册地" withSucc:NO withDismissDelay:2];
        return NO;
    }
    NSArray *arr=_dic_data[kCustomerAptitudes];
    if (arr.count==0) {
        [ProgressHUD showInfo:@"请选择企业资质" withSucc:NO withDismissDelay:2];
        return NO;
    }
        if (_dic_data[kFilingArea] == nil) {
        [ProgressHUD showInfo:@"请选择经营区域" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
}
-(BOOL)resultCheck2{
    if ( _dic_data[kCustomerAptitudes] == nil && _dic_data[kFilingArea] == nil) {
        [ProgressHUD showInfo:@"请至少选择更改一项" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if(![_dic_data.allKeys containsObject:kCustomerAptitudes]){
        [ProgressHUD showInfo:@"请至少保留一项企业资质" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
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
