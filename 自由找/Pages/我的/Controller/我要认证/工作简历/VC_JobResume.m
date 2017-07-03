//
//  VC_JobResume.m
//  自由找
//
//  Created by xiaoqi on 16/8/2.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_JobResume.h"
#import "VC_TextInput.h"
#import "VC_TextField.h"
#import "BSModalDatePickerView.h"
@interface VC_JobResume (){
    NSArray *_arr_Input;
    NSMutableDictionary *_dic_data;
    //工作时间
    NSInteger _timeType;
    NSString * _time1;
    NSString * _time2;
    
}
- (IBAction)btn_save_press:(id)sender;
- (IBAction)btn_delete_press:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_delete;

@end

@implementation VC_JobResume

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}
-(void)initData{
    if(_ResumeCategory==0){//工作简历
        self.jx_title = @"工作简历";
        _arr_Input =@[
                      @{kCellKey: kOrganization, kCellName: @"公司名称", kCellDefaultText: @"请输入公司名称", kCellEditType: EditType_TextField},
                      @{kCellKey: kDepartment, kCellName: @"工作部门", kCellDefaultText: @"请输入工作部门", kCellEditType: EditType_TextField},
                      @{kCellKey: kJob, kCellName: @"职位名称", kCellDefaultText: @"请输入职位名称", kCellEditType: EditType_TextField},
                      @{kCellKey: kWorkTime, kCellName: @"工作时间", kCellDefaultText: @"", kCellEditType: EditType_DatePicker},
                      @{kCellKey: kJobDescription, kCellName: @"工作内容", kCellDefaultText: @"请输入工作内容(选填)", kCellEditType: EditType_Text},
                      @{kCellKey: kWorkmate, kCellName: @"证明人", kCellDefaultText: @"请输入证明人", kCellEditType: EditType_TextField},
                      ];
    }else{//项目简历
        self.jx_title = @"项目简历";
        _arr_Input =@[
                      @{kCellKey: kBidName, kCellName: @"项目名称", kCellDefaultText: @"请输入项目名称", kCellEditType: EditType_TextField},
                      @{kCellKey: kJob, kCellName: @"职位名称", kCellDefaultText: @"请输入职位名称", kCellEditType: EditType_TextField},
                      @{kCellKey: kWorkTime, kCellName: @"工作时间", kCellDefaultText: @"", kCellEditType: EditType_DatePicker},
                      @{kCellKey: kWorkmate, kCellName: @"证明人", kCellDefaultText: @"请输入证明人", kCellEditType: EditType_TextField},
                      ];
    }
    if (_ResumeType==0) {//添加简历
        _dic_data = [NSMutableDictionary dictionaryWithCapacity:_arr_Input.count];
        _time1=@"请选择";
        _time2=@"请选择";
    }else{//修改简历
        _dic_data = [[NSMutableDictionary alloc]initWithDictionary:self.parameters];
        if (_dic_data[kStartDt] !=nil && ![_dic_data[kStartDt] isEqualToString:@"请选择"]) {
            _time1=_dic_data[kStartDt];
        }
        if (_dic_data[kEndDt] !=nil && ![_dic_data[kEndDt] isEqualToString:@"请选择"]) {
            _time2=_dic_data[kEndDt];
        }
    }
    
}
-(void)layoutUI{
    [self hideTableViewFooter:_tableView];
    _btn_delete.layer.borderColor=[[UIColor colorWithHex:@"ff7b23"]CGColor];
    _btn_delete.layer.borderWidth=1.0;
    _btn_delete.layer.masksToBounds=YES;
    _btn_delete.layer.cornerRadius=3;
    if (_ResumeType==0) {//添加简历
        _btn_delete.hidden=YES;
    }else{//修改简历
        _btn_delete.hidden=NO;
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arr_Input count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID1 = @"Cell_JobResume";
    static NSString *CellID2 = @"Cell_JobTime";
    UITableViewCell *cell_bid = [tableView dequeueReusableCellWithIdentifier:CellID1];
    Cell_JobTime *cell_JobTime=[tableView dequeueReusableCellWithIdentifier:CellID2];
    NSDictionary *dic_input = [_arr_Input objectAtIndex:indexPath.row];
    NSString *key = dic_input[kCellKey];
    NSString *name = dic_input[kCellName];
    NSString *editType = dic_input[kCellEditType];
    NSString *text = dic_input[kCellDefaultText];
    UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
    if ([EditType_Text isEqualToString:editType] || [EditType_TextField isEqualToString:editType] ) {
        if (_dic_data[key] != nil && ![_dic_data[key] isEmptyString]) {
            text = _dic_data[key];
            detailTextColor = [UIColor colorWithHex:@"333333"];
        }else{
            detailTextColor=[UIColor colorWithHex:@"bbbbbb"];
        }
        cell_bid.textLabel.text = name;
        cell_bid.detailTextLabel.textColor = detailTextColor;
        cell_bid.detailTextLabel.text = text;
        return cell_bid;
    }else{
        if (![_time1 isEqualToString:@"请选择"]) {
            cell_JobTime.lb_startTime.textColor=[UIColor colorWithHex:@"333333"];
        }
        if (![_time2 isEqualToString:@"请选择"]) {
            cell_JobTime.lb_endTime.textColor=[UIColor colorWithHex:@"333333"];
        }
        cell_JobTime.indexPath=indexPath;
        cell_JobTime.lb_startTime.text=_time1;
        cell_JobTime.lb_endTime.text=_time2;
        cell_JobTime.delegate=self;
        return cell_JobTime;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arr_Input objectAtIndex:indexPath.row];
    NSString *editType = tmpDic[kCellEditType];
    if ([EditType_Text isEqualToString:editType]) {
        [self textInputedDic:tmpDic indexPath:indexPath];
    } else if ([EditType_TextField isEqualToString:editType]) {
        [self textFieldWithDic:tmpDic indexPath:indexPath];
    }
}

- (void)textInputedDic:(NSDictionary *)tmpDic indexPath:(NSIndexPath *)indexPath {
    VC_TextInput *vc = [self getVC_TextInput];
    vc.type = 0;
    vc.maxCount=200;
    NSString *text = _dic_data[tmpDic[kCellKey]];
    if (text != nil && ![text isEmptyString]) {
        vc.text = text;
    }
    vc.inputTitle = tmpDic[kCellDefaultText];
    vc.tipText = tmpDic[kCellDefaultText];
    vc.inputBlock = ^(NSString *text, NSString *imgUrls) {
        [_dic_data setObject:text forKey:tmpDic[kCellKey]];
        [self reloadIndexPath:indexPath];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
- (void)indexPath:(NSIndexPath *)indexPath selectDate:(NSString *)selectDate {
    BSModalDatePickerView *datePicker = [[BSModalDatePickerView alloc] initWithDate:[NSDate date]];
    datePicker.mode = UIDatePickerModeDate;
    if (selectDate != nil && ![selectDate isEmptyString]) {
        if(_timeType==0){
            datePicker.selectedDate = [CommonUtil dateFromString:_time1];
        }else{
            datePicker.selectedDate=[CommonUtil dateFromString:_time2];
        }
    }
    [datePicker presentInWindowWithBlock:^(BOOL madeChoice) {
        if (madeChoice) {
            NSDate *today = [[NSDate alloc] init];
            if ([today compare:datePicker.selectedDate] ==NSOrderedAscending ) {
                [ProgressHUD showInfo:@"不能大于当前日期" withSucc:NO withDismissDelay:2];
                return;
            }
            //存时间
            if(_timeType==0){
                _time1=[CommonUtil stringFromDate:datePicker.selectedDate];
            }else{
                _time2=[CommonUtil stringFromDate:datePicker.selectedDate];
                
            }
            [self reloadIndexPath:indexPath];
        }
    }];
}

- (void)reloadIndexPath:(NSIndexPath *)indexPath {
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (VC_TextInput *)getVC_TextInput {
    return [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_TextInput"];
}

- (VC_TextField *)getVC_TextField {
    return [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_TextField"];
}
- (void)tapResult:(NSInteger)result indexPath:(NSIndexPath *)indexPath{
    _timeType=result;
    [self indexPath:indexPath selectDate:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)btn_save_press:(id)sender {
    if([self compareDate:_time1 withDate:_time2]==-1){
        [_dic_data setObject:_time2 forKey:kStartDt];
        [_dic_data setObject:_time1 forKey:kEndDt];
    }else if([self compareDate:_time1 withDate:_time2]==1){
        [_dic_data setObject:_time1 forKey:kStartDt];
        [_dic_data setObject:_time2 forKey:kEndDt];
    }
    if(_ResumeCategory==0){//工作简历
        if ([self checkMustInput]) {
            self.jobResumeBlock(_dic_data);
            [self goBack];
        }
    }else{//项目简历
        if ([self checkMustInput1]) {
            self.jobResumeBlock(_dic_data);
            [self goBack];
        }
    }
    
}

- (IBAction)btn_delete_press:(id)sender {
    if(_ResumeCategory==0){//工作简历
        [_dic_data removeAllObjects];
        self.jobResumeDeleteBlock(1);
        [self goBack];
    }else{//项目简历
        [_dic_data removeAllObjects];
        self.jobResumeDeleteBlock(0);
        [self goBack];
    }
}
- (BOOL)checkMustInput {//工作简历
    if (_time1 == nil || _time2==nil || [_time1 isEqualToString:@"请选择"] || [_time2 isEqualToString:@"请选择"]) {
        [ProgressHUD showInfo:@"请选择工作时间" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[kOrganization] == nil|| [_dic_data[kOrganization] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入公司名称" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[kDepartment] == nil|| [_dic_data[kDepartment] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入工作部门" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[kJob] == nil|| [_dic_data[kJob] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入职位名称" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[kWorkmate] == nil|| [_dic_data[kWorkmate] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入证明人" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if ([self compareDate:_time1 withDate:_time2]==0) {
        [ProgressHUD showInfo:@"起始时间与结束时间相同，请重新选择" withSucc:NO withDismissDelay:2];
        return NO;
    }
    
    return YES;
}
- (BOOL)checkMustInput1{//项目简历
    if (_time1 == nil || _time2==nil || [_time1 isEqualToString:@"请选择"] || [_time2 isEqualToString:@"请选择"]) {
        [ProgressHUD showInfo:@"请选择工作时间" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[kBidName] == nil|| [_dic_data[kBidName] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入项目名称" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[kJob] == nil|| [_dic_data[kJob] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入职位名称" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_dic_data[kWorkmate] == nil || [_dic_data[kWorkmate] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入证明人" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if ([self compareDate:_time1 withDate:_time2]==0) {
        [ProgressHUD showInfo:@"起始时间与结束时间相同，请重新选择" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
}
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1;
            break;
            //date02比date01小
        case NSOrderedDescending: ci=-1;
            break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}


@end
