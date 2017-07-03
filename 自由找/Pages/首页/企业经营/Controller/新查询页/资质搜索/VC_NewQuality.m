//
//  VC_NewQuality.m
//  zyz
//
//  Created by 郭界 on 16/12/22.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_NewQuality.h"
#import "BidService.h"
#import "VC_Quality.h"

#define RadioInfoDic @{kCellEditType:EditType_None}

@interface VC_NewQuality ()
{
    NSMutableArray *_arr_qualitySelected;
    NSMutableArray *_arrQuality;
    NSInteger _isMatchAny;
    NSMutableArray *_arr_Input;
    
    BidService *_bidService;
}
@end

@implementation VC_NewQuality

- (void)setDic_QualityInfo:(NSMutableDictionary *)dic_QualityInfo {
    _dic_QualityInfo = [[NSMutableDictionary dictionaryWithDictionary:dic_QualityInfo] mutableCopy];
}

- (void)initData {
    _bidService = [BidService sharedService];
    if (_dic_QualityInfo == nil) {
        _arrQuality = [NSMutableArray array];
        _isMatchAny = 0;
        _dic_QualityInfo = [NSMutableDictionary dictionaryWithCapacity:2];
        _arr_qualitySelected = [NSMutableArray array];
        _arr_Input = [NSMutableArray array];
        [self showAPChoiceViewWithIndex:-1];
    } else {
        _arrQuality = [[_dic_QualityInfo objectForKey:kQualityData] mutableCopy];
        _arr_qualitySelected = [[_dic_QualityInfo objectForKey:kQualityChoiceData] mutableCopy];
        _isMatchAny = [[_dic_QualityInfo objectForKey:kIsMatchAny] integerValue];
        _arr_Input = [NSMutableArray arrayWithArray:_arrQuality];
        if (_arr_Input.count > 1) {
            NSDictionary *tmpDic = _arr_Input.lastObject;
            if (tmpDic[kCellEditType] == nil || ![tmpDic[kCellEditType] isEqualToString:EditType_None]) {
                [_arr_Input addObject:RadioInfoDic];
            }
        }
        
    }
}

- (void)layoutUI {
    if (_arrQuality.count > 0) {
        [_btn_add setTitle:@"继续添加企业资质" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    self.jx_title = @"设置企业资质搜索条件";
    [self initData];
    [self layoutUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.swipeBackEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.swipeBackEnabled = YES;
}

- (void)showAPChoiceViewWithIndex:(NSInteger)index {
    [_bidService getQualitificationWithType:2 result:^(NSArray *qualityList, NSInteger code) {
        if (code != 1) {
            if (index == -1) {
            }
            return ;
        }
        VC_Quality *vc_quality = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Quality"];
        if (index < 0) {
            NSMutableArray *disabledArray = [NSMutableArray arrayWithCapacity:_arr_qualitySelected.count];
            for (NSDictionary *tmpDic in _arr_qualitySelected) {
                [disabledArray addObject:tmpDic[kTopKey]];
            }
            [vc_quality setDataArray:qualityList disabledArray:disabledArray selectedData:nil];
        } else {
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:_arr_qualitySelected];
            NSDictionary *tmpDic = [tmpArray objectAtIndex:index];
            [tmpArray removeObjectAtIndex:index];
            NSMutableArray *disabledArray = [NSMutableArray arrayWithCapacity:_arr_qualitySelected.count-1];
            for (NSDictionary *tmpDic in tmpArray) {
                [disabledArray addObject:tmpDic[kTopKey]];
            }
            [vc_quality setDataArray:qualityList disabledArray:disabledArray selectedData:tmpDic];
        }
        __block UIButton *weakAddButton = _btn_add;
        [self.navigationController pushViewController:vc_quality animated:YES];
        vc_quality.choiceQualityBlock = ^(NSDictionary * dic) {
            if (index >= 0) {
                [_arr_Input removeObjectAtIndex:index];
                [_arr_qualitySelected removeObjectAtIndex:index];
                [_arrQuality removeObjectAtIndex:index];
                
                [_arrQuality insertObject:dic atIndex:index];
                [_arr_qualitySelected insertObject:@{kTopKey: dic[kTopKey], kLimitKey: dic[kCommonKey]} atIndex:index];
                [_arr_Input insertObject:dic atIndex:index];
                
            } else {
                [_arrQuality addObject:dic];
                [_arr_qualitySelected addObject:@{kTopKey: dic[kTopKey], kLimitKey: dic[kCommonKey]}];
                if (_arrQuality.count > 1) {
                    NSDictionary *tmpDic = _arr_Input.lastObject;
                    if (tmpDic[kCellEditType] == nil || ![tmpDic[kCellEditType] isEqualToString:EditType_None]) {
                        [_arr_Input addObject:RadioInfoDic];
                    }
                    [_arr_Input insertObject:dic atIndex:_arr_Input.count - 1];
                } else {
                    [_arr_Input addObject:dic];
                }
            }
            [_tableView reloadData];
            if (_arrQuality.count > 0) {
                [weakAddButton setTitle:@"继续添加企业资质" forState:UIControlStateNormal];
            }
            
        };
    }];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_Input.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_Normal";
    static NSString *CellID2 = @"Cell_NewRadio";
    NSDictionary *tmpDic = [_arr_Input objectAtIndex:indexPath.row];
    if (tmpDic[kCellEditType] != nil && [tmpDic[kCellEditType] isEqualToString:EditType_None]) {
        Cell_NewRadio *cell = [tableView dequeueReusableCellWithIdentifier:CellID2];
        cell.delegate = self;
        cell.type = _isMatchAny;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
        cell.textLabel.text = tmpDic[kCommonValue];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arr_Input objectAtIndex:indexPath.row];
    if (tmpDic[kCellEditType] != nil && [tmpDic[kCellEditType] isEqualToString:EditType_None]) {
        return;
    }
    [self showAPChoiceViewWithIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arr_Input objectAtIndex:indexPath.row];
    if (tmpDic[kCellEditType] != nil && [tmpDic[kCellEditType] isEqualToString:EditType_None]) {
        return 58;
    }
    return 48;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDic = [_arr_Input objectAtIndex:indexPath.row];
    if (tmpDic[kCellEditType] != nil && [tmpDic[kCellEditType] isEqualToString:EditType_None]) {
        return NO;
    }
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        NSMutableArray *paths = [NSMutableArray arrayWithObject:indexPath];
        [_arr_Input removeObjectAtIndex:indexPath.row];
        [_arr_qualitySelected removeObjectAtIndex:indexPath.row];
        [_arrQuality removeObjectAtIndex:indexPath.row];
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
        if (_arrQuality.count == 0) {
            [_btn_add setTitle:@"添加企业资质" forState:UIControlStateNormal];
        }
        [self performSelector:@selector(deleteLastCell) withObject:nil afterDelay:0.2];
    }
}

- (void)deleteLastCell {
    if (_arrQuality.count < 2) {
        NSDictionary *tmpDic = _arr_Input.lastObject;
        if (tmpDic[kCellEditType] != nil && [tmpDic[kCellEditType] isEqualToString:EditType_None]) {
            [_arr_Input removeLastObject];
            [_tableView reloadData];
        }
    }
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - 代理
/**
 *  资质选择---同时具备和任意满足
 *
 */
- (void)choiceRadioResult:(NSInteger)result {
    _isMatchAny = result;
}

- (void)backPressed {
    __block typeof(self) weakSelf = self;
    [JAlertHelper jAlertWithTitle:@"是否保存资质条件" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"保存"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf finish];
        }
        [weakSelf goBack];
    }];
}

- (void)finish {
//    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
//    [resultDic setObject:_arrQuality forKey:kQualityData];
//    [resultDic setObject:_arr_qualitySelected forKey:kQualityChoiceData];
//    [resultDic setObject:[NSString stringWithFormat:@"%d", _isMatchAny] forKey:kIsMatchAny];
//    if (self.qualityResult) {
//        self.qualityResult(resultDic);
//    }
    if (_arrQuality.count > 0) {
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        [resultDic setObject:_arrQuality forKey:kQualityData];
        [resultDic setObject:_arr_qualitySelected forKey:kQualityChoiceData];
        if (_arrQuality.count > 1) {
            [resultDic setObject:[NSString stringWithFormat:@"%ld", _isMatchAny] forKey:kIsMatchAny];
        }
        self.qualityResult(resultDic);
    } else {
        self.qualityResult(nil);
    }
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

- (IBAction)btn_add_pressed:(id)sender {
    if (_arrQuality.count > 3) {
        [ProgressHUD showInfo:@"最多只能选择4个资质条件" withSucc:NO withDismissDelay:2];
    } else {
        [self showAPChoiceViewWithIndex:-2];
    }
}
- (IBAction)btn_finish_pressed:(id)sender {
    [self finish];
    [self goBack];
}
@end
