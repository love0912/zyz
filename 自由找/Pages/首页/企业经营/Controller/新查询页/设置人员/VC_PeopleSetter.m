//
//  VC_PeopleSetter.m
//  zyz
//
//  Created by 郭界 on 16/12/30.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_PeopleSetter.h"
#import "NewQueryService.h"
#import "VC_RegisterJob.h"

#define kPeople_Register @"Type1"
#define kPeople_Job @"Type2"
#define kPeople_Manager @"Type3"

#define EditType_RegisterJob @"EditType_RegisterJob"
#define EditType_PeopleManager @"EditType_PeopleManager"


@interface VC_PeopleSetter ()
{
    NSArray *_arrInput;
    NewQueryService *_queryService;
    
    NSMutableArray *_arr_memberRegion;
    
    NSMutableArray *_arr_1;
    NSMutableArray *_arr_2;
    NSMutableArray *_arr_4;
    
}
@end

@implementation VC_PeopleSetter

- (void)initData {
    _arrInput = @[
                  @{kCellKey: kPeople_Register, kCellName: @"注册类人员", kCellDefaultText: @"请设置注册类人员", kCellEditType: EditType_RegisterJob},
                  @{kCellKey: kPeople_Job, kCellName: @"职称类人员", kCellDefaultText: @"请设置职称类人员", kCellEditType: EditType_RegisterJob},
                  @{kCellKey: kPeople_Manager, kCellName: @"现场管理人员", kCellDefaultText: @"请设置现场管理人员", kCellEditType: EditType_PeopleManager}
                  ];
    
    _queryService = [NewQueryService sharedService];
    if (_dic_MemberInfo == nil) {
        _dic_MemberInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    }
}

- (void)layoutUI {
    [self getDataList];
}

//获取不能选择的数据
- (void)getDataList {
    [_queryService getMembersResult:^(NSArray *resultArray, NSInteger code) {
        if (code != 1) {
            return ;
        }
        for (NSDictionary *tmpDic in resultArray) {
            if ([tmpDic[kCommonKey] isEqualToString:@"1"]) {
                _arr_1 = [NSMutableArray arrayWithArray:tmpDic[kQualitySubCollection]];
            } else if ([tmpDic[kCommonKey] isEqualToString:@"2"]) {
                _arr_2 = [NSMutableArray arrayWithArray:tmpDic[kQualitySubCollection]];
            } else if ([tmpDic[kCommonKey] isEqualToString:@"4"]) {
                _arr_4 = [NSMutableArray arrayWithArray:tmpDic[kQualitySubCollection]];
            }
        }
        
    }];
}

- (void)setDic_MemberInfo:(NSMutableDictionary *)dic_MemberInfo {
    _dic_MemberInfo = [NSMutableDictionary dictionaryWithDictionary:dic_MemberInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    self.jx_title = @"设置人员搜索条件";
    [self initData];
    [self layoutUI];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrInput.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_Normal";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    NSDictionary *tmpDic = [_arrInput objectAtIndex:indexPath.row];
    NSString *key = tmpDic[kCellKey];
    NSString *detailText = tmpDic[kCellDefaultText];
    UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
    if (_dic_MemberInfo[key] != nil) {
        NSArray *array = _dic_MemberInfo[key];
        detailText = [NSString stringWithFormat:@"已设置 %ld项", array.count];
        detailTextColor = [UIColor colorWithHex:@"333333"];
    }
    cell.textLabel.text = tmpDic[kCellName];
    cell.detailTextLabel.text = detailText;
    cell.detailTextLabel.textColor = detailTextColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arrInput objectAtIndex:indexPath.row];
//    NSString *editType = tmpDic[kCellEditType];
    NSArray *tmpArray;
    if ([tmpDic[kCellKey] isEqualToString:kPeople_Register]) {
        tmpArray = _arr_1;
    } else if ([tmpDic[kCellKey] isEqualToString:kPeople_Job]) {
        tmpArray = _arr_2;
    } else {
        tmpArray = _arr_4;
    }
    BOOL canNext = NO;
    for (NSDictionary *tmpDic2 in tmpArray) {
        if ([tmpDic2[kCommonKey] isEqualToString:_regionDic[kCommonKey]]) {
            canNext = YES;
            break;
        }
    }
    if (canNext) {
        [self registerJobWithDic:tmpDic indexPath:indexPath];
    } else {
        NSString *title = [NSString stringWithFormat:@"%@暂未开通设置%@", _regionDic[kCommonValue],tmpDic[kCellName]];
        [ProgressHUD showInfo:title withSucc:NO withDismissDelay:3];
    }
//    if ([editType isEqualToString:EditType_RegisterJob]) {
//        //注册类，职称类
//        [self registerJobWithDic:tmpDic indexPath:indexPath];
//    } else if ([editType isEqualToString:EditType_PeopleManager]) {
//        //现场管理类
//        [self peopleManagerWithDic:tmpDic indexPath:indexPath];
//    }
}

#pragma mark -
- (void)registerJobWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    NSString *key = dic[kCellKey];
    VC_RegisterJob *vc_registerJob = [self.storyboard instantiateViewControllerWithIdentifier:@"VC_RegisterJob"];
    NSMutableArray *arry = _dic_MemberInfo[key];
    if (arry != nil) {
        vc_registerJob.arr_registerJobInfo = arry;
    }
    if ([key isEqualToString:kPeople_Register]) {
        vc_registerJob.titleType = 1;
    } else if ([key isEqualToString:kPeople_Job]) {
        vc_registerJob.titleType = 2;
    } else {
        vc_registerJob.titleType = 4;
    }
    vc_registerJob.qualityResult = ^(NSMutableArray *resultArray) {
        if (resultArray.count == 0) {
            [_dic_MemberInfo removeObjectForKey:key];
        } else {
            [_dic_MemberInfo setObject:resultArray forKey:key];
        }
        [self reloadIndexPath:indexPath];
    };
    [self.navigationController pushViewController:vc_registerJob animated:YES];
    
}

- (void)reloadIndexPath:(NSIndexPath *)indexPath {
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)peopleManagerWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    
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

- (IBAction)btn_finish_pressed:(id)sender {
    if (_dic_MemberInfo.count == 0) {
        self.memberResult(nil);
    } else {
        self.memberResult(_dic_MemberInfo);
    }
    [self goBack];
}

- (void)backPressed {
    [JAlertHelper jAlertWithTitle:@"是否保存配置" message:nil cancleButtonTitle:@"不保存" OtherButtonsArray:@[@"保存"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            if (_dic_MemberInfo.count == 0) {
                self.memberResult(nil);
            } else {
                self.memberResult(_dic_MemberInfo);
            }
        }
        [self goBack];
    }];
}

@end
