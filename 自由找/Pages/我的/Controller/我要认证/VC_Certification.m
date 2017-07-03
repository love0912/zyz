//
//  VC_Certification.m
//  自由找
//
//  Created by xiaoqi on 16/8/3.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Certification.h"
#import "VC_JobResume.h"
#import "VC_TextField.h"
#import "VC_Choice.h"
#import "BSModalDatePickerView.h"
#import "VC_GoodField.h"

#import "ProducerService.h"
#import "ProductService.h"

static NSString *CellID1 = @"Cell_Certification";
static NSString *CellID2 = @"Cell_CertificationRadio";
static NSString *CellID3 = @"Cell_Resume";
static NSString *CellID4 = @"Cell_CertificationOverview";
@interface VC_Certification (){
    NSMutableArray *_arr_Input;
    NSMutableDictionary *_dic_data;
    NSInteger  _isSex;//性别
    NSInteger  _orderType;//接单类型
    NSMutableArray *_workExperience;
    NSMutableArray *_projectExperience;
    UIButton *_btn_next;
    NSString *_personalString;//个人概述
    ProducerService *_producerService;
    ProductService *_productService;
    ProducerDomain *_producerdomian;
    NSInteger callInterfaceType;
    CGFloat offsetY;
}

@end

@implementation VC_Certification

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"我要认证";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}
- (void)initData {
    _arr_Input = [NSMutableArray array];
    _workExperience=[[NSMutableArray alloc]init];
    _projectExperience=[[NSMutableArray alloc]init];
    _producerService=[ProducerService sharedService];
    _productService=[ProductService sharedService];
    _producerdomian=[self.parameters objectForKey:@"producerdomian"];
    [self layoutPages];
    callInterfaceType=1;
    offsetY=0.0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attention) name:Notification_Upload_Cerification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPersonView:) name:@"refreshPersonView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endrefreshPersonView:) name:@"endrefreshPersonView" object:nil];

}
-(void)backPressed{
//    NSString *titleString;
//    if (_producerdomian !=nil &&[_producerdomian.AuthStatus integerValue]==2) {
//       
//    }else{
//        titleString=@"您的认证未完成，如果要继续认证，请点击“确定”";
//    }
//    [JAlertHelper jAlertWithTitle:@"如果要继续认证，请点击“确定”" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"确定"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
//        if(buttonIndex==1){
//            [self requsetEditOrUpdate];
//        }else{
//            [self goBack];
//        }
//    }];
    [self goBack];
}

- (void)setupMenuDataByProductType:(NSString *)type {
    if ([type isEqualToString:@"1"] ||[type isEqualToString:@"0"] ) {
        if (_projectExperience.count !=0||_workExperience.count!=0) {
            NSMutableArray *_arr_4=[NSMutableArray arrayWithArray:[_arr_Input objectAtIndex:4]];
            if(_arr_4.count<3){
                NSArray *goodArr=@[@{kCellKey: kExpertCategory, kCellName: @"擅长领域", kCellDefaultText: @"请选择您擅长的领域", kCellEditType: EditType_GoodFieldChoice}];
                [_arr_4 addObjectsFromArray:goodArr];
                [_arr_Input replaceObjectAtIndex:4 withObject:_arr_4];
            }
            [_arr_Input setArray:_arr_Input];
            
        }else{
            NSArray * arr_Input = @[
                                    @[
                                        @{kCellKey: kName, kCellName: @"姓名", kCellDefaultText: @"请输入真实姓名(必填)", kCellEditType: EditType_TextField},
                                        @{kCellKey: kNickName, kCellName: @"昵称", kCellDefaultText: @"请输入昵称", kCellEditType: EditType_TextField},
                                        @{kCellKey: kSex, kCellName: @"性别", kCellDefaultText: @"", kCellEditType: EditType_None},
                                        @{kCellKey: kDateofBirth, kCellName: @"出生年月", kCellDefaultText: @"请选择出生年月", kCellEditType: EditType_DatePicker},
                                        @{kCellKey: kGraduatedSchool, kCellName: @"毕业学校", kCellDefaultText: @"请输入您的毕业学校", kCellEditType: EditType_TextField}
                                        ],
                                    @[
                                        @{kCellKey: kJobResume, kCellName: @"＋添加简历", kCellDefaultText: @"", kCellEditType: EditType_None}
                                        ],
                                    @[
                                        @{kCellKey: kProjectResume, kCellName: @"＋项目简历", kCellDefaultText: @"", kCellEditType: EditType_None}
                                        ],
                                    @[
                                        @{kCellKey: kPersonalOverView, kCellName: @"", kCellDefaultText: @"", kCellEditType: EditType_None}
                                        ],
                                    @[
                                        @{kCellKey: kOrderRegion, kCellName: @"接单区域", kCellDefaultText: @"请选择您的接单区域", kCellEditType: EditType_RegionChoice},
                                        @{kCellKey: kOrderType, kCellName: @"接单类型", kCellDefaultText: @"", kCellEditType: EditType_None},
                                        @{kCellKey: kExpertCategory, kCellName: @"擅长领域", kCellDefaultText: @"请选择您擅长的领域", kCellEditType: EditType_GoodFieldChoice},
                                        ]
                                    
                                    ];
            [_arr_Input setArray:arr_Input];
        
        }
        
    } else {
        if (_projectExperience.count !=0||_workExperience.count!=0) {
            NSMutableArray *_arr_4=[NSMutableArray arrayWithArray:[_arr_Input objectAtIndex:4]];
            [_arr_4 removeObjectAtIndex:2];
            [_arr_Input replaceObjectAtIndex:4 withObject:_arr_4];
            [_arr_Input setArray:_arr_Input];
            
        }else{
        NSArray * arr_Input = @[
                                @[
                                    @{kCellKey: kName, kCellName: @"姓名", kCellDefaultText: @"请输入真实姓名(必填)", kCellEditType: EditType_TextField},
                                    @{kCellKey: kNickName, kCellName: @"昵称", kCellDefaultText: @"请输入昵称", kCellEditType: EditType_TextField},
                                    @{kCellKey: kSex, kCellName: @"性别", kCellDefaultText: @"", kCellEditType: EditType_None},
                                    @{kCellKey: kDateofBirth, kCellName: @"出生年月", kCellDefaultText: @"请选择出生年月", kCellEditType: EditType_DatePicker},
                                    @{kCellKey: kGraduatedSchool, kCellName: @"毕业学校", kCellDefaultText: @"请输入您的毕业学校", kCellEditType: EditType_TextField}
                                    ],
                                @[
                                    @{kCellKey: kJobResume, kCellName: @"＋添加简历", kCellDefaultText: @"", kCellEditType: EditType_None}
                                    ],
                                @[
                                    @{kCellKey: kProjectResume, kCellName: @"＋项目简历", kCellDefaultText: @"", kCellEditType: EditType_None}
                                    ],
                                @[
                                    @{kCellKey: kPersonalOverView, kCellName: @"", kCellDefaultText: @"", kCellEditType: EditType_None}
                                    ],
                                @[
                                    @{kCellKey: kOrderRegion, kCellName: @"接单区域", kCellDefaultText: @"请选择您的接单区域", kCellEditType: EditType_RegionChoice},
                                    @{kCellKey: kOrderType, kCellName: @"接单类型", kCellDefaultText: @"", kCellEditType: EditType_None}
                                    ]
                                
                                ];
        [_arr_Input setArray:arr_Input];
    }
  }
}

- (void)layoutPages {
    if (_producerdomian ==nil) {//编辑 1－接单 0－我的
        _dic_data = [NSMutableDictionary dictionaryWithCapacity:_arr_Input.count];
        _isSex=0;
        _orderType=0;
        [self setupMenuDataByProductType:@"1"];
    }else{
        [self setupMenuDataByProductType:_producerdomian.ProductType];
         _dic_data = [[NSMutableDictionary alloc]init];
        if ([_producerdomian.WorkExperiences isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *arr=[[NSMutableArray alloc]initWithArray:[_arr_Input objectAtIndex:1]];
            for (WorkExperienceDomain *dic in _producerdomian.WorkExperiences) {
                [arr  insertObject:[dic toDictionary] atIndex:arr.count-1];
                [_workExperience addObject:[dic toDictionary]];
            }
           
            [_arr_Input replaceObjectAtIndex:1 withObject:arr];
            [_dic_data setObject:arr forKey:kWorkExperience];
        }
        if ([_producerdomian.ProjectExperiences isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *arr=[[NSMutableArray alloc]initWithArray:[_arr_Input objectAtIndex:2]];
            for (ProjectExperienceDomain *dic in _producerdomian.ProjectExperiences) {
                [arr  insertObject:[dic toDictionary] atIndex:arr.count-1];
                 [_projectExperience addObject:[dic toDictionary]];
            }
//            [_projectExperience addObjectsFromArray:_producerdomian.ProjectExperiences];
            [_arr_Input replaceObjectAtIndex:2 withObject:arr];
            [_dic_data setObject:arr forKey:kProjectExperience];
        }
       
        //擅长领域-字符,分隔成数组
        if (_producerdomian.ExpertCategory !=nil && ![_producerdomian.ExpertCategory isEmptyString]) {
            NSString *engineeringString=_producerdomian.ExpertCategory;
            NSArray *array = [engineeringString componentsSeparatedByString:@","];
            [_dic_data setObject:array forKey:kExpertCategory];
    
        }
        [_dic_data setObject:_producerdomian.Name forKey:kName];
        [_dic_data setObject:_producerdomian.NickName forKey:kNickName];
        [_dic_data setObject:_producerdomian.Birthday forKey:kDateofBirth];
        [_dic_data setObject:_producerdomian.Education forKey:kGraduatedSchool];
        [_dic_data setObject:_producerdomian.Sex forKey:kSex];
        [_dic_data setObject:_producerdomian.Description forKey:kPersonalOverView];
        [_dic_data setObject:[_producerdomian.Region toDictionary] forKey:kOrderRegion];
        [_dic_data setObject:_producerdomian.ProductType forKey:kOrderType];
//        [_dic_data setObject:[_producerdomian.ExpertCategory componentsSeparatedByString:@","] forKey:kExpertCategory];
        _isSex=[[_dic_data objectForKey:kSex]integerValue];
        _orderType=[[_dic_data objectForKey:kOrderType]integerValue]-1;
        _personalString=[_dic_data objectForKey:kPersonalOverView];
    }
    
}
-(void)layoutUI{
    _tableView.sectionHeaderHeight=10;
    _tableView.sectionFooterHeight=0;
    UIView *tableViewheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 10)];
    tableViewheaderView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = tableViewheaderView;
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width,65)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _btn_next=[[UIButton alloc]initWithFrame:CGRectMake(14, 10, ScreenSize.width-28, 45)];
    if (_producerdomian==nil) {
        _btn_next.enabled=YES;
        [_btn_next setTitle:@"下一步" forState:UIControlStateNormal];
    }else if(_producerdomian!=nil && [_producerdomian.AuthStatus intValue]==2){
        _btn_next.enabled=YES;
        [_btn_next setTitle:@"确定修改" forState:UIControlStateNormal];
    }else if(_producerdomian!=nil && [_producerdomian.AuthStatus intValue] ==1){
         [ProgressHUD showInfo:@"正在审核中，请耐心等待..." withSucc:NO withDismissDelay:2];
        [_btn_next setTitle:@"正在审核中" forState:UIControlStateNormal];
        _btn_next.enabled=NO;
    }else if (_producerdomian!=nil && [_producerdomian.AuthStatus intValue]==4){
         _btn_next.enabled=YES;
        [ProgressHUD showInfo:@"审核被拒，请重新提交" withSucc:NO withDismissDelay:2];
        [_btn_next setTitle:@"下一步" forState:UIControlStateNormal];
    }else if (_producerdomian!=nil && [_producerdomian.AuthStatus intValue] ==0){
         _btn_next.enabled=YES;
        [ProgressHUD showInfo:@"亲，请完善您的信息！" withSucc:NO withDismissDelay:2];
        [_btn_next setTitle:@"下一步" forState:UIControlStateNormal];
    }
    [_btn_next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn_next setBackgroundImage:[UIImage imageNamed:@"Login_btn1"] forState:UIControlStateNormal];
    [_btn_next addTarget:self action:@selector(btn_next_press:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:_btn_next];
    self.tableView.tableFooterView = tableFooterView;
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arr_Input.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_arr_Input objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellID1];
    Cell_CertificationRadio *cell_radio = [tableView dequeueReusableCellWithIdentifier:CellID2];
    Cell_CertificationOverview *cell_overView=[tableView dequeueReusableCellWithIdentifier:CellID4];
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellID3];
    NSDictionary *dic_input = [[_arr_Input objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *key = dic_input[kCellKey];
    NSString *name = dic_input[kCellName];
    NSString *editType = dic_input[kCellEditType];
    NSString *text = dic_input[kCellDefaultText];
    UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
    if ([EditType_Text isEqualToString:editType] || [EditType_DatePicker isEqualToString:editType] || [EditType_TextField isEqualToString:editType] || [EditType_RegionChoice isEqualToString:editType] || [EditType_GoodFieldChoice isEqualToString:editType]) {
        if ([EditType_RegionChoice isEqualToString:editType] ) {
            NSDictionary *dic = _dic_data[key];
            if (dic != nil) {
                text = dic[kCommonValue];
                detailTextColor = [UIColor colorWithHex:@"333333"];
            }
        }else if ([EditType_GoodFieldChoice isEqualToString:editType]){
            NSArray *arry=_dic_data[key];
            if (_dic_data[key] != nil &&  arry.count!=0) {
                text = [NSString stringWithFormat:@"已选择%lu项",(long)arry.count];
                detailTextColor = [UIColor colorWithHex:@"333333"];
            }else{
                detailTextColor=[UIColor colorWithHex:@"bbbbbb"];
            }
            if(_orderType==1){
                cell1.hidden=YES;
            }else{
                cell1.hidden=NO;
            }
        }else{
            if (_dic_data[key] != nil && ![_dic_data[key] isEmptyString]) {
                text = _dic_data[key];
                detailTextColor = [UIColor colorWithHex:@"333333"];
            }else{
                detailTextColor=[UIColor colorWithHex:@"bbbbbb"];
            }
        }
        cell1.textLabel.text = name;
        cell1.detailTextLabel.textColor = detailTextColor;
        cell1.detailTextLabel.text = text;
        return cell1;

    }else{
        if ([key isEqualToString:kSex]) {
            cell_radio.delegate = self;
            cell_radio.type = _isSex;
            cell_radio.cellType=0;
            return cell_radio;
        }else if ([key isEqualToString:kOrderType]) {
            cell_radio.delegate = self;
            cell_radio.type = _orderType;
            cell_radio.cellType=1;
//            if(_producerdomian ==nil || [_producerdomian.AuthStatus intValue]!=2){
//                cell_radio.userInteractionEnabled=YES;
//            }else{
//                cell_radio.userInteractionEnabled=NO;
//            }

            return cell_radio;
        }else if ([key isEqualToString:kJobResume]){
            cell2.textLabel.text=@"＋添加工作简历";
            [cell2.textLabel setTextAlignment:NSTextAlignmentCenter];
            return cell2;
        }else if([_dic_data[kWorkExperience] isKindOfClass:[NSArray class]] && indexPath.section==1){
            NSDictionary *dic=[_dic_data[kWorkExperience] objectAtIndex:indexPath.row];
            name= dic[kOrganization];
            NSString *timeString=[NSString stringWithFormat:@"%@至%@",dic[kStartDt],dic[kEndDt]];
            text = timeString;
            detailTextColor = [UIColor colorWithHex:@"333333"];
            cell1.textLabel.text = name;
            cell1.detailTextLabel.textColor = detailTextColor;
            cell1.detailTextLabel.text = text;
            return cell1;

        }else if([key isEqualToString:kProjectResume]){
            cell2.textLabel.text=@"＋添加项目简历";
            [cell2.textLabel setTextAlignment:NSTextAlignmentCenter];
            return cell2;
        }else if([_dic_data[kProjectExperience] isKindOfClass:[NSArray class]] && indexPath.section==2){
            NSDictionary *dic=[_dic_data[kProjectExperience] objectAtIndex:indexPath.row];
            name= dic[kBidName];
            NSString *timeString=[NSString stringWithFormat:@"%@至%@",dic[kStartDt],dic[kEndDt]];
            text = timeString;
            detailTextColor = [UIColor colorWithHex:@"333333"];
            cell1.textLabel.text = name;
            cell1.detailTextLabel.textColor = detailTextColor;
            cell1.detailTextLabel.text = text;
            return cell1;
        }else{
            cell_overView.delegate=self;
            cell_overView.tv_content.text=_personalString;
            if (_personalString.length != 0) {
                cell_overView.lb_tips.hidden = YES;
            }
            return cell_overView;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     NSDictionary *tmpDic = [[_arr_Input objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
     NSString *key = tmpDic[kCellKey];
     if ([key isEqualToString:kPersonalOverView]) {
         return 140;
     }else{
         return 44;
     }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [[_arr_Input objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *editType = tmpDic[kCellEditType];
    if ([EditType_TextField isEqualToString:editType]) {
        [self textFieldWithDic:tmpDic indexPath:indexPath];
    } else if ([EditType_RegionChoice isEqualToString:editType]) {
        [self regionChoiceWithDic:tmpDic indexPath:indexPath];
    } else if ([EditType_DatePicker isEqualToString:editType]) {
        [self deadLineWithDic:tmpDic indexPath:indexPath];
    }else if([EditType_GoodFieldChoice isEqualToString:editType]){
//        if (_orderType==2) {
//             [ProgressHUD showInfo:@"请选择接单类型－技术标方案" withSucc:NO withDismissDelay:2];
//        }else{
             [self goodFieldChoiceWithDic:tmpDic indexPath:indexPath];
//        }
    }else{
        if (indexPath.section==1||indexPath.section==2) {
            VC_JobResume *vc_JobResume=[self.storyboard instantiateViewControllerWithIdentifier:@"VC_JobResume"];
            if (indexPath.section==1){
                NSMutableArray *arr= [NSMutableArray arrayWithArray:[_arr_Input objectAtIndex:indexPath.section]];
                if (arr.count>1 && indexPath.row != arr.count-1) {
                    vc_JobResume.ResumeType=1;
                    if ([_dic_data[kWorkExperience] isKindOfClass:[NSArray class]]) {
                        vc_JobResume.parameters=[_dic_data[kWorkExperience] objectAtIndex:indexPath.row];
                    }
                }else{
                    vc_JobResume.ResumeType=0;
                }
                vc_JobResume.ResumeCategory=0;//0-工作简历
                vc_JobResume.jobResumeBlock=^(NSDictionary *resultDic){
                    if (vc_JobResume.ResumeType==1) {
                        [_workExperience replaceObjectAtIndex:indexPath.row withObject:resultDic];
                        [arr  replaceObjectAtIndex:indexPath.row withObject:resultDic];
                    }else{
                        [_workExperience addObject:resultDic];
                        if (arr.count==1) {
                            [arr  insertObject:resultDic atIndex:0];
                        }else if(arr.count>1){
                            [arr  insertObject:resultDic atIndex:arr.count-1];
                        }
                    }
                    [_arr_Input replaceObjectAtIndex:indexPath.section withObject:arr];
                    [_dic_data setObject:_workExperience forKey:kWorkExperience];
                    [self reloadIndexSelction:indexPath.section];

                };
                
            }else{
                if (indexPath.section==2){
                    NSMutableArray *arr= [NSMutableArray arrayWithArray:[_arr_Input objectAtIndex:indexPath.section]];
                    if (arr.count>1 && indexPath.row != arr.count-1) {
                    vc_JobResume.ResumeType=1;
                        if ([_dic_data[kProjectExperience] isKindOfClass:[NSArray class]]) {
                            vc_JobResume.parameters=[_dic_data[kProjectExperience] objectAtIndex:indexPath.row];
                        }
                    }else{
                        vc_JobResume.ResumeType=0;
                    }

                vc_JobResume.ResumeCategory=1;//1-项目简历
                vc_JobResume.jobResumeBlock=^(NSDictionary *resultDic){
                    if (vc_JobResume.ResumeType==1) {
                        [_projectExperience replaceObjectAtIndex:indexPath.row withObject:resultDic];
                        [arr  replaceObjectAtIndex:indexPath.row withObject:resultDic];

                    }else{
                        [_projectExperience addObject:resultDic];
                        if (arr.count==1) {
                            [arr  insertObject:resultDic atIndex:0];
                        }else if(arr.count>1){
                            [arr  insertObject:resultDic atIndex:arr.count-1];
                        }
                    }
                    [_arr_Input replaceObjectAtIndex:indexPath.section withObject:arr];
                    [_dic_data setObject:_projectExperience forKey:kProjectExperience];
                    [self reloadIndexSelction:indexPath.section];
                };
            }
          }
            vc_JobResume.jobResumeDeleteBlock=^(NSInteger result){
                if (result==1) {
                    NSMutableArray *arr=[NSMutableArray arrayWithArray:_dic_data[kWorkExperience]];
                    [arr removeObjectAtIndex:indexPath.row];
                    [_dic_data setObject:arr forKey:kWorkExperience];
                }else{
                    NSMutableArray *arr=[NSMutableArray arrayWithArray:_dic_data[kProjectExperience]];
                    [arr removeObjectAtIndex:indexPath.row];
                    [_dic_data setObject:arr forKey:kProjectExperience];
                }
                NSMutableArray *arr= [NSMutableArray arrayWithArray:[_arr_Input objectAtIndex:indexPath.section]];
                [arr removeObjectAtIndex:indexPath.row];
                [_arr_Input replaceObjectAtIndex:indexPath.section withObject:arr];
                [self reloadIndexSelction:indexPath.section];
            };
            [self.navigationController pushViewController:vc_JobResume animated:YES];
 
        }
    }
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
- (void)regionChoiceWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    [_productService getProductRegionToResult:^(NSInteger code, NSArray<KeyValueDomain *> *list) {
        if (code != 1) {
            return;
        }
        VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
        vc_choice.type = @"0";
        NSMutableArray *selectArray = [NSMutableArray array];
        NSString *key = dic[kCellKey];
        if (_dic_data[key] != nil) {
            [selectArray addObject:[_dic_data[key] objectForKey:kCommonKey]];
        }
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:list];
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
//擅长领域
- (void)goodFieldChoiceWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    [_producerService goodFiledResult:^(NSArray<KeyValueDomain *> *goodFiledList, NSInteger code) {
        if (code !=1) {
            return;
        }
        VC_GoodField *vc_goodField= [[UIStoryboard storyboardWithName:Storyboard_Mine bundle:nil] instantiateViewControllerWithIdentifier:@"VC_GoodField"];
        NSString *key = dic[kCellKey];
        if (_dic_data[key] != nil) {
            vc_goodField.selectArray=_dic_data[key];
        }else{
            vc_goodField.selectArray=[NSMutableArray array];
        }
        vc_goodField.allArray=[NSMutableArray arrayWithArray:goodFiledList];
        vc_goodField.filedchoiceBlock = ^(NSMutableArray *selectArr) {
            [_dic_data setObject:selectArr forKey:key];
            [self reloadIndexPath:indexPath];
        };
        [self.navigationController pushViewController:vc_goodField animated:YES];
        
    }];
}
- (void)deadLineWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    [self choiceDateWithDic:dic indexPath:indexPath selectDate:nil];
}

- (void)choiceDateWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath selectDate:(NSString *)selectDate {
    BSModalDatePickerView *datePicker = [[BSModalDatePickerView alloc] initWithDate:[NSDate date]];
    datePicker.mode = UIDatePickerModeDate;
    if (selectDate != nil && ![selectDate isEmptyString]) {
        datePicker.selectedDate = [CommonUtil dateFromString:_dic_data[dic[kCellKey]]];
    }
    [datePicker presentInWindowWithBlock:^(BOOL madeChoice) {
        if (madeChoice) {
            NSDate *today = [[NSDate alloc] init];
            if ([today compare:datePicker.selectedDate] ==NSOrderedAscending ) {
                [ProgressHUD showInfo:@"不能大于当前日期" withSucc:NO withDismissDelay:2];
                return;
            }
            [_dic_data setObject:[CommonUtil stringFromDate:datePicker.selectedDate] forKey:dic[kCellKey]];
            [self reloadIndexPath:indexPath];
        }
    }];
}
- (void)reloadIndexSelction:(NSInteger)selctionindex {
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:selctionindex];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadIndexPath:(NSIndexPath *)indexPath {
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (VC_TextField *)getVC_TextField {
    return [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_TextField"];
}

/**
 *  性别，接单类别
 */
- (void)choiceSexRadioResult:(NSInteger)result {
    _isSex=result;
}
- (void)choiceOrderRadioResult:(NSInteger)result {
    _orderType=result;
    
    if (result == 0) {
        [self setupMenuDataByProductType:@"1"];
    } else {
        [self setupMenuDataByProductType:@"2"];
    }
    
    [_tableView reloadData];
}
/**
 *  个人概述
 */
- (void)contentResult:(NSString *)result{
    _personalString=result;
    [_dic_data setObject:_personalString forKey:kPersonalOverView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (void)btn_next_press:(UIButton *)btn {
    [self requsetEditOrUpdate];
}
-(void)requsetEditOrUpdate{
    if ([self checkMustInput]) {
        if(_producerdomian==nil && callInterfaceType==1){
            NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:_dic_data];
            [paramDic setObject:@(_isSex) forKey:kSex];
            [paramDic setObject:@(_orderType+1) forKey:kOrderType];
            if([_dic_data[kExpertCategory] count]>0){
                [paramDic setObject:[paramDic[kExpertCategory] componentsJoinedByString:@","] forKey:kExpertCategory];
            }
            [_producerService createProducerWithDictionary:paramDic result:^(NSInteger code) {
                if (code !=1) {
                    return;
                }
                
                NSDictionary *dic;
                if([self.parameters[kPageType]integerValue]==1){//接单
                    dic=@{kPageType:self.parameters[kPageType],@"orderType":[NSString stringWithFormat:@"%lu",(long)_orderType]};
                }else{
                    dic=@{@"orderType":[NSString stringWithFormat:@"%lu",(long)_orderType]};
                }
                [PageJumpHelper pushToVCID:@"VC_UploadIDCard" storyboard:Storyboard_Mine parameters:dic parent:self];
              
            }];
            
        }else{
            NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:_dic_data];
            [paramDic setObject:@(_isSex) forKey:kSex];
            [paramDic setObject:@(_orderType+1) forKey:kOrderType];
            NSMutableArray *projectArr=[NSMutableArray arrayWithArray:_dic_data[kProjectExperience]];
            NSMutableArray *projectArr1=[NSMutableArray array];
            for (NSDictionary *dic in projectArr) {
                if(![dic.allKeys containsObject:kCellKey]){
                    [projectArr1 addObject:dic];
                }
            }
            [paramDic setObject:projectArr1 forKey:kProjectExperience];
            
            NSMutableArray *workArr=[NSMutableArray arrayWithArray:_dic_data[kWorkExperience]];
            NSMutableArray *workArr1=[NSMutableArray array];
            for (NSDictionary *dic in workArr) {
                if(![dic.allKeys containsObject:kCellKey]){
                    [workArr1 addObject:dic];
                }
            }
            [paramDic setObject:workArr1 forKey:kWorkExperience];
            if([_dic_data[kExpertCategory] count]>0 &&_orderType!=1){
                [paramDic setObject:[paramDic[kExpertCategory] componentsJoinedByString:@","] forKey:kExpertCategory];
            }
            [_producerService updateProducerWithDictionary:paramDic result:^(NSInteger code) {
                if (code !=1) {
                    return;
                }
                NSDictionary *dic;
                if([self.parameters[kPageType]integerValue]==1){
                    dic=@{kPageType:self.parameters[kPageType],@"orderType":[NSString stringWithFormat:@"%lu",(long)_orderType],@"producerdomian":_producerdomian};
                }else{
                    dic=@{@"orderType":[NSString stringWithFormat:@"%lu",(long)_orderType],@"producerdomian":_producerdomian};
                }
                [PageJumpHelper pushToVCID:@"VC_UploadIDCard" storyboard:Storyboard_Mine parameters:dic parent:self];
            }];
        }
    }

}
- (void)attention{
    callInterfaceType=3;
}
-(void)refreshPersonView:(NSNotification*)notification{
    NSInteger rowCount=[[_arr_Input objectAtIndex:1] count]+[[_arr_Input objectAtIndex:2] count]+1;
    [_tableView scrollRectToVisible:CGRectMake(0, ([[_arr_Input objectAtIndex:0] count]-1)*44, SCREEN_WIDTH, _tableView.frame.size.height) animated:YES];
    if (offsetY==0) {
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame=CGRectMake(0,-(rowCount*44), SCREEN_WIDTH, _tableView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            _tableView.frame=CGRectMake(0,-(rowCount*44), SCREEN_WIDTH, _tableView.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}
-(void)endrefreshPersonView:(NSNotification*)notification{
    [UIView animateWithDuration:0.2 animations:^{
        _tableView.frame=CGRectMake(0, 64, SCREEN_WIDTH, _tableView.frame.size.height);
    } completion:^(BOOL finished) {
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //获取当前活动的tableview
    offsetY = scrollView.contentOffset.y;
    
}
- (BOOL)checkMustInput {//工作简历
    if (_dic_data[kName] == nil|| [_dic_data[kName] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入您的真实名字" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[kNickName] == nil|| [_dic_data[kNickName] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入昵称" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[kDateofBirth] == nil || [_dic_data[kDateofBirth] isEmptyString]) {
        [ProgressHUD showInfo:@"请选择您的出生年月" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[kGraduatedSchool] == nil || [_dic_data[kGraduatedSchool] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入您的毕业学校" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[kPersonalOverView] == nil || [_dic_data[kPersonalOverView] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入您的个人概述" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[kOrderRegion] == nil || [_dic_data[kOrderRegion] isEmptyString]) {
        [ProgressHUD showInfo:@"请选择您的接单区域" withSucc:NO withDismissDelay:2];
        return NO;
    }
//    if(_dic_data[kWorkExperience]==nil ||[_dic_data[kWorkExperience] count]==0){
//        [ProgressHUD showInfo:@"请输入您的工作简历" withSucc:NO withDismissDelay:2];
//        return NO;
//    }if(_dic_data[kProjectExperience]==nil ||[_dic_data[kProjectExperience] count]==0){
//        [ProgressHUD showInfo:@"请输入您的项目简历" withSucc:NO withDismissDelay:2];
//        return NO;
//    }
    return YES;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
