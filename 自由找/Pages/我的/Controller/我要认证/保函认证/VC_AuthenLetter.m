//
//  VC_AuthenLetter.m
//  自由找
//
//  Created by 郭界 on 16/10/18.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_AuthenLetter.h"
#import "VC_TextField.h"
#import "AuthenLetterDomain.h"

@interface VC_AuthenLetter ()
{
    NSArray *_arr_input;
    NSMutableDictionary *_dic_data;
    AuthenLetterDomain *_autherLetter;
}
@end

@implementation VC_AuthenLetter

- (void)initData {
    _arr_input = @[
                   @{kCellKey: @"Name", kCellEditType: EditType_TextField, kCellName: @"姓名", kCellDefaultText: @"请输入姓名"},
                   @{kCellKey: @"Job", kCellEditType: EditType_TextField, kCellName: @"职务", kCellDefaultText: @"请输入职务"},
                   @{kCellKey: @"Company", kCellEditType: EditType_TextField, kCellName: @"所在担保公司", kCellDefaultText: @"请输入所在担保公司"}];
    _dic_data = [NSMutableDictionary dictionaryWithCapacity:3];
    _autherLetter = [self.parameters objectForKey:kPageDataDic];
    if (_autherLetter != nil ) {
        [_dic_data setDictionary:[_autherLetter toDictionary]];
    }
}

- (void)layoutUI {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"保函认证";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_input.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_AuthenLetter";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
    cell.textLabel.text = tmpDic[kCellName];
    NSString *key = tmpDic[kCellKey];
    NSString *text = tmpDic[kCellDefaultText];
    UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
    NSString *editType = tmpDic[kCellEditType];
    if ([EditType_TextField isEqualToString:editType]) {
        if (_dic_data[key] != nil && ![_dic_data[key] isEmptyString]) {
            text = _dic_data[key];
            detailTextColor = [UIColor colorWithHex:@"333333"];
        }
    }
    cell.detailTextLabel.text = text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([_autherLetter.AuthStatus isEqualToString:@"1"]) {
        [ProgressHUD showInfo:@"正在审核中，不能修改" withSucc:NO withDismissDelay:2];
        return;
    }
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
    [self
     textFieldWithDic:tmpDic indexPath:indexPath];
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
        if (text.trimWhitesSpace.length == 0) {
            [_dic_data removeObjectForKey:tmpDic[kCellKey]];
        } else {
            [_dic_data setObject:text forKey:tmpDic[kCellKey]];
        }
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
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

- (IBAction)btn_next_pressed:(id)sender {
    AuthenLetterDomain *authenLetter = [AuthenLetterDomain domainWithObject:_dic_data];
    if (authenLetter.Name == nil || [authenLetter.Name isEmptyString]) {
        [ProgressHUD showInfo:@"请输入姓名" withSucc:NO withDismissDelay:2];
    } else if (authenLetter.Job == nil || [authenLetter.Job isEmptyString]) {
        [ProgressHUD showInfo:@"请输入职务" withSucc:NO withDismissDelay:2];
    } else if (authenLetter.Company == nil || [authenLetter.Company isEmptyString]) {
        [ProgressHUD showInfo:@"请输入所在担保公司" withSucc:NO withDismissDelay:2];
    } else {
        [PageJumpHelper pushToVCID:@"VC_AuthenLetterUpload" storyboard:Storyboard_Mine parameters:@{kPageDataDic: authenLetter} parent:self];
    }
}
@end
