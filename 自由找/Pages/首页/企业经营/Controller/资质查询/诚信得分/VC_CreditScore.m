//
//  VC_CreditScore.m
//  自由找
//
//  Created by xiaoqi on 16/7/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_CreditScore.h"
static NSString *CellID = @"Cell_CreditScore";
#import "QualificaService.h"
@interface VC_CreditScore (){
    
    VC_CreditScoreTwo *vc_creditscoretwo;
    NSDictionary *dicparam;
   
    NSIndexPath *_indexpath;
   
    QualificaService *_qualificaService;
    NSMutableArray *_creditScoreArray;
    NSInteger selectIndex;
    BOOL checked;


}
@property(nonatomic,strong)NSMutableDictionary *dic_data;
@property(nonatomic,strong) Cell_CreditScore *cell_creditscore;
@property(nonatomic,strong)  NSMutableArray *arraySelect;
@end

@implementation VC_CreditScore

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"诚信得分";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    [self selectArray:_selectArray];
}

-(void)selectArray:(NSArray *)selectArray{
   
    NSMutableArray *arr = [NSMutableArray arrayWithArray:selectArray];
    for (NSDictionary *tmpDic in arr) {
        NSObject *obj = tmpDic.allValues.firstObject;
        if ([obj isKindOfClass:[NSString class]]) {
            [arr removeObject:tmpDic];
        }
    }
    
    
//        if (arr.count >0) {
//            if (_type==1) {
//            checked = YES;
//            for (int i = 0; i < _arr_Input.count; i ++) {
//                for (int j=0; j<selectArray.count; j++) {
//                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:_arr_Input[i]];
//                    NSDictionary *selectdic = selectArray[j];
//                    NSMutableString *checkString=[NSMutableString stringWithFormat:@"%@",selectdic[kCommonKey]];
////                    [checkString deleteCharactersInRange:NSMakeRange(0,6)];
//                        NSString *tmpString = dic[kCommonKey];
//                        if ([checkString isEqualToString:tmpString]) {
//                            [dic setObject:selectdic[kCredit2DisplayName] forKey:kCredit2DisplayName];
//                            [dic setObject:selectdic[kCommonValue] forKey:kCommonValue];
//                            [_arr_Input removeObjectAtIndex:i];
//                            [_arr_Input insertObject:dic atIndex:i];
//                            NSMutableDictionary *dicback=[[NSMutableDictionary alloc]init];
//                            [dicback setObject:selectdic[kCommonValue] forKey:kCommonValue];
//                            [dicback setObject:selectdic[kCredit2DisplayName] forKey:kCredit2DisplayName];
////                            [dicback setObject:selectdic[kCommonValue] forKey:kCommonKey];
//                            NSMutableDictionary *dicAdd=[[NSMutableDictionary alloc]init];
//                            [dicAdd setObject:dicback forKey:tmpString];
////                            [dicback setObject:checkString forKey:tmpString];
//                            
//                            [_arraySelect addObject:dicAdd];
//                        }
//                    
//                }
//            }
//            }else{
                if (arr.count >0) {
                    checked = YES;
                    for (int i = 0; i < _arr_Input.count; i ++) {
                        for (int j=0; j<arr.count; j++) {
                            NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:_arr_Input[i]];
                            NSDictionary *selectdic = arr[j];
                            for ( NSString *checkString in selectdic.allKeys) {
                                NSString *tmpString = dic[kCommonKey];
                                if ([checkString isEqualToString:tmpString]) {
                                    NSString *DisplayName=[[selectdic objectForKey:checkString]objectForKey:kCredit2DisplayName];
                                    NSString *valueString=[[selectdic objectForKey:checkString]objectForKey:kCommonValue];
                                    [dic setObject:DisplayName forKey:kCredit2DisplayName];
                                    [dic setObject:valueString forKey:kCommonValue];
                                    [_arr_Input removeObjectAtIndex:i];
                                    [_arr_Input insertObject:dic atIndex:i];
                                }
                                
                            }
                            
                        }
                    }
                    [_arraySelect addObjectsFromArray:_selectArray];
                }
                
//            }


//    }
    _dic_data = [NSMutableDictionary dictionaryWithCapacity:_arr_Input.count];
   
}
-(void)initData{
        _arr_Input=[NSMutableArray arrayWithObjects:@{kCommonKey: KTraffic,kCredit2DisplayName: @"交通", kCommonValue: @"请选择"},@{kCommonKey: KWater,kCredit2DisplayName: @"水利", kCommonValue: @"请选择"}, @{kCommonKey: KBuilding,kCredit2DisplayName: @"建筑", kCommonValue: @"请选择"},@{kCommonKey: KGarden,kCredit2DisplayName: @"园林", kCommonValue: @"请选择"}
                    ,nil];

   
    _arraySelect=[NSMutableArray arrayWithCapacity:0];
    _qualificaService=[QualificaService sharedService];
    _creditScoreArray=[[NSMutableArray alloc]init];
    
}
-(void)layoutUI{
    _tableView.rowHeight=48;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItem_press)];
    rightItem.tintColor=[UIColor whiteColor];
    [self setNavigationBarRightItem:rightItem];

}
-(void)rightItem_press{
    //    if (_arraySelect.count !=0) {
    self.credit2Result(_arraySelect);
    //    }
    [self goBack];
}
//-(void)backPressed{
////    if (_arraySelect.count !=0) {
//        self.credit2Result(_arraySelect);
////    }
//    [self goBack];
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arr_Input count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        _cell_creditscore = [tableView dequeueReusableCellWithIdentifier:CellID];
        NSDictionary *dic_input = [_arr_Input  objectAtIndex:indexPath.row];
        NSString *name = dic_input[kCredit2DisplayName];
        NSString *key = dic_input[kCommonKey];
        UIColor *detailTextColor = [UIColor colorWithHex:@"333333"];
        NSString *text = _dic_data[key];
        if (text == nil || [text isEmptyString]) {
            text = dic_input[kCommonValue];
            detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
        }
        _cell_creditscore.lb_name.text=name;
        _cell_creditscore.lb_detail.textColor = detailTextColor;
        _cell_creditscore.lb_detail.text = text;
        return _cell_creditscore;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:_arr_Input[indexPath.row]];
    NSString *key=tmpDic[kCommonKey];
    if ([tmpDic[kCommonValue] isEqualToString:@"请选择"]) {
       [self WithDictionary:tmpDic withkey:key withindexPath:indexPath];
     }else{
         [JAlertHelper jSheetWithTitle:@"您已选择!" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"重新选择" OtherButtonsArray:@[@"删除"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
             if (buttonIndex == 0) {
                 
                 [self WithDictionary:tmpDic withkey:key withindexPath:indexPath];
             } else if (buttonIndex == 2) {
                 //删除该资
                 [_dic_data removeObjectForKey:key];
                 
                 for (int j=0; j<_arraySelect.count; j++) {
                     NSDictionary *selectdic = _arraySelect[j];
                     
                     for ( NSString *checkString in selectdic.allKeys) {
                         NSLog(@"%@",checkString);
                         NSLog(@"%@",key);
                         if ([checkString isEqualToString:key]) {
//                             [_arraySelect addObject:@""];
                             if (_type==1) {
                                 NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                                 [dic setObject:@"" forKey:key];
                                 [_arraySelect removeObjectAtIndex:j];
                                 [_arraySelect addObject:dic];
                             }else{
                               [_arraySelect removeObjectAtIndex:j];
                             }
                             
                             NSLog(@"%@",_arraySelect);
                         }
                         
                     }
                     
                 }

                 [tmpDic setObject:@"请选择" forKey:kCommonValue];
                 [tmpDic setObject:key forKey:kCommonKey];
                 [self.arr_Input removeObjectAtIndex:indexPath.row];
                 [self.arr_Input insertObject:tmpDic atIndex:indexPath.row];
                 [self  reloadIndexPath:indexPath];
//                 [_tableView reloadData];
             }
         }];

     }
    
}
-(void)WithDictionary:(NSMutableDictionary *)tmpDic withkey:(NSString *)key withindexPath:(NSIndexPath *)indexPath{
    //重新选择
    __weak typeof(self) weakSelf = self;
    NSDictionary *Paramedic=@{kCommonType:key};
    [_qualificaService creditsettingWithParameters:Paramedic result:^(NSArray<KeyValueDomain *> *responseBid, NSInteger code) {
        if (code != 1) {
            return ;
        }
        
        [_creditScoreArray removeAllObjects];
        [_creditScoreArray addObjectsFromArray:responseBid];
        vc_creditscoretwo =[self.storyboard instantiateViewControllerWithIdentifier:@"VC_CreditScoreTwo"];
        NSMutableArray *selectArray = [NSMutableArray array];
        
        if (![tmpDic[kCommonValue] isKindOfClass:[NSNull class]]) {
            [selectArray addObject:tmpDic[kCommonValue]];
        }
        [vc_creditscoretwo setDataArray:_creditScoreArray selectArray:selectArray];
        vc_creditscoretwo.choiceQualityBlock = ^(NSDictionary *dic) {
            _cell_creditscore= [_tableView cellForRowAtIndexPath:indexPath];
            weakSelf.cell_creditscore.lb_detail.text = dic[kCommonValue];
            [tmpDic setObject:dic[kCommonKey] forKey:kCommonKey];
            [tmpDic setObject:dic[kCommonValue] forKey:kCommonValue];
            [tmpDic setObject:tmpDic[kCredit2DisplayName] forKey:kCredit2DisplayName];
            [weakSelf.dic_data setObject:tmpDic forKey:key];
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:tmpDic,key,  nil];
            if (weakSelf.arraySelect.count==0) {
                  
                    [weakSelf.arraySelect addObject:paramDic];
                }else{
                   [weakSelf.arraySelect enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                       NSDictionary *dic=[[NSDictionary alloc]initWithDictionary:obj];
                       for ( NSString *checkString in dic.allKeys) {
                            if ([checkString isEqualToString:key]) {
                       
                            *stop = YES;
                            
                                if (*stop == YES) {
                                
                                    [weakSelf.arraySelect removeObject:dic];
                                 
                                }
                            }
                            
                        }
                        
                        if (*stop) {
                            
                            NSLog(@"array is %@",weakSelf.arraySelect);
                            
                        }
                        
                    }];
                    [weakSelf.arraySelect addObject:paramDic];

                }
     
        };
        [weakSelf.navigationController pushViewController:vc_creditscoretwo animated:YES];
        
    }];

}
- (void)reloadIndexPath:(NSIndexPath *)indexPath {
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
