//
//  VC_AddProject.m
//  自由找
//
//  Created by guojie on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_AddProject.h"
#import <AddressBook/AddressBook.h>
#import "VC_Contact.h"
#import "VC_TextInput.h"
#import "VC_TextField.h"
#import "JJDBService.h"
#import "BSModalDatePickerView.h"
#import "CustomerService.h"
#import "VC_ChoiceProject.h"

#define EditType_Customer_ProjectID @"EditType_Customer_ProjectID"

@interface VC_AddProject ()
{
    NSArray *_arr_input;
    JJDBService *_dbService;
    CustomerService *_customerService;
}
@end

@implementation VC_AddProject

- (void)initData {
    _dbService = [JJDBService sharedJJDBService];
    _customerService = [CustomerService sharedService];
    _arr_input = @[
                   @{kCellName: @"项目编号",
                     kCellDefaultText: @"请选择项目编号",
                     kCellEditType: EditType_Customer_ProjectID,
                     kCellKey: @"ProjectId"},
                   @{kCellName: @"项目名称",
                     kCellDefaultText: @"请输入",
                     kCellEditType: EditType_TextField,
                     kCellKey: @"Name"},
                   @{kCellName: @"项目概述",
                     kCellDefaultText: @"请输入",
                     kCellEditType: EditType_Text,
                     kCellKey: @"Desc"},
                   @{kCellName: @"联系人",
                     kCellDefaultText: @"请输入",
                     kCellEditType: EditType_TextField,
                     kCellKey: @"Contact"},
                   @{kCellName: @"联系电话",
                     kCellDefaultText: @"请输入",
                     kCellEditType: EditType_TextField,
                     kCellKey: @"Phone"},
                   @{kCellName: @"开标时间",
                     kCellDefaultText: @"请选择开标时间",
                     kCellEditType: EditType_DatePicker,
                     kCellKey: @"openDate"},
                   @{kCellName: @"保证金额",
                     kCellDefaultText: @"请输入保证金额",
                     kCellEditType: EditType_TextField,
                     kCellKey: @"Money"},
                   @{kCellName: @"备注",
                     kCellDefaultText: @"请输入其他信息",
                     kCellEditType: EditType_Text,
                     kCellKey: @"Remark"}
                   ];
    
    _type = [[self.parameters objectForKey:kPageType] integerValue];
    if (_type == 1) {
        //编辑
        _project = [self.parameters objectForKey:kPageDataDic];
    }
    
}

- (void)layoutUI {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"导入联系人" style:UIBarButtonItemStylePlain target:self action:@selector(toContactVC)];
    [self setNavigationBarRightItem:rightItem];
    
    if (_type == 0) {
        self.jx_title = @"增加项目记录";
    } else {
        self.jx_title = @"编辑项目记录";
    }
    [self hideTableViewFooter:self.tableView];
}

- (void)toContactVC {
    if (_project == nil) {
        [ProgressHUD showInfo:@"请选择项目编号" withSucc:NO withDismissDelay:2];
        return;
    }
    //1.获取授权状态
    ABAuthorizationStatus type =  ABAddressBookGetAuthorizationStatus();
    //授权申请
    if (type == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRef book = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(book, ^(bool granted, CFErrorRef error) {
            if (granted) {
                //                NSLog(@"授权允许");
                [self openAddressChoiceView];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您拒绝授权访问通信录，以后如需使用该功能，请到【隐私】-【通信录】打开软件授权!" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        });
        //释放book
        CFRelease(book);
    } else if (type == kABAuthorizationStatusAuthorized) {
        [self openAddressChoiceView];
    } else if (type == kABAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"如需使用该功能，请到【隐私】-【通信录】打开软件授权!" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)openAddressChoiceView {
    [ProgressHUD showProgressHUDWithInfo:@""];
    dispatch_async(dispatch_get_main_queue(), ^{
        VC_Contact *vc_contact = [[self storyboard] instantiateViewControllerWithIdentifier:@"VC_Contact"];
        vc_contact.addressBookChoice = ^(NSString *name, NSString *phone) {
//            [_dic_data setObject:name forKey:kCustomerContact];
//            [_dic_data setObject:phone forKey:kCustomerPhone];
//            NSIndexPath *nameIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
//            NSIndexPath *phoneIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
//            [_tableView reloadRowsAtIndexPaths:@[nameIndexPath, phoneIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            _project.contact = name;
            _project.phone = phone;
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:vc_contact animated:YES];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"增加项目";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_input.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_AddProject";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = _arr_input[indexPath.row][kCellName];
    if (_project == nil) {
        cell.detailTextLabel.text = _arr_input[indexPath.row][kCellDefaultText];
    } else {
        NSDictionary *tmpDic = _arr_input[indexPath.row];
        NSString *key = tmpDic[kCellKey];
        NSString *text;
        UIColor *detailTextColor = [UIColor colorWithHex:@"666666"];
        if ([key isEqualToString:@"ProjectId"]) {
            text = [NSString stringWithFormat:@"%@号", _project.projectId];
        } else if ([key isEqualToString:@"Name"]) {
            text = _project.name;
        } else if ([key isEqualToString:@"Desc"]) {
            text = _project.desc;
        } else if ([key isEqualToString:@"Contact"]) {
            text = _project.contact;
        } else if ([key isEqualToString:@"Phone"]) {
            text = _project.phone;
        } else if ([key isEqualToString:@"openDate"]) {
            text = _project.openDate;
        } else if ([key isEqualToString:@"Money"]) {
            text = _project.money == nil ? @"" : [NSString stringWithFormat:@"%@ 万元", _project.money];
        } else if ([key isEqualToString:@"Remark"]) {
            text = _project.remark;
        }
        if (text == nil || [text isEmptyString]) {
            text = tmpDic[kCellDefaultText];
            detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
        }
        cell.detailTextLabel.text = text;
        cell.detailTextLabel.textColor = detailTextColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_project == nil && indexPath.row != 0) {
        [ProgressHUD showInfo:@"请先选择项目编号" withSucc:NO withDismissDelay:2];
        return;
    }
    if (_type == 1 && indexPath.row == 0) {
        [ProgressHUD showInfo:@"不能修改项目编号，如需更改为其他项目，请添加新项目!" withSucc:NO withDismissDelay:3];
        return;
    }
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
    NSString *editType = tmpDic[kCellEditType];
    if ([EditType_Text isEqualToString:editType]) {
        [self textInputedDic:tmpDic indexPath:indexPath];
    } else if ([EditType_TextField isEqualToString:editType]) {
        [self textFieldWithDic:tmpDic indexPath:indexPath];
    } else if ([EditType_DatePicker isEqualToString:editType]) {
        [self deadLineWithDic:tmpDic indexPath:indexPath];
    } else if ([EditType_Customer_ProjectID isEqualToString:editType]) {
        [self choiceProject];
    }
}

- (void)textFieldWithDic:(NSDictionary *)tmpDic indexPath:(NSIndexPath *)indexPath {
    VC_TextField *vc = [self getVC_TextField];
    vc.type = INPUT_TYPE_NORMAL;
    if ([tmpDic[kCellKey] isEqualToString:@"Phone"]) {
        vc.type = INPUT_TYPE_NUMBER;
        vc.maxCount = 20;
    } else if ([tmpDic[kCellKey] isEqualToString:@"Money"]) {
        vc.type = INPUT_TYPE_NUMBER;
        vc.jUnit = @"万元";
    }
    NSString *tmpText = @"";
    NSString *key = tmpDic[kCellKey];
    if ([key isEqualToString:@"Name"]) {
        vc.maxCount = 200;
        tmpText = _project.name;
    } else if ([key isEqualToString:@"Contact"]) {
        vc.maxCount = 50;
        tmpText = _project.contact;
    } else if ([key isEqualToString:@"Money"]) {
        vc.maxCount = 20;
        tmpText = _project.money;
    } else if ([key isEqualToString:@"Phone"]) {
        vc.maxCount = 15;
        tmpText = _project.phone;
    }
    
    vc.text = tmpText;
    vc.jTitle = tmpDic[kCellDefaultText];
    vc.placeholder = tmpDic[kCellDefaultText];
    vc.inputBlock = ^(NSString *text) {
        
        if ([key isEqualToString:@"Name"]) {
            _project.name = text.trimWhitesSpace;
        } else if ([key isEqualToString:@"Contact"]) {
            _project.contact = text;;
        } else if ([key isEqualToString:@"Money"]) {
            _project.money = text;;
        } else if ([key isEqualToString:@"Phone"]) {
            _project.phone = text;
        }
        [_tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)textInputedDic:(NSDictionary *)tmpDic indexPath:(NSIndexPath *)indexPath {
    VC_TextInput *vc = [self getVC_TextInput];
    vc.type = 0;
    NSString *tmpText = @"";
    NSString *key = tmpDic[kCellKey];
    if ([key isEqualToString:@"Desc"]) {
        vc.maxCount = 2000;
        tmpText = _project.desc;
    } else if ([key isEqualToString:@"Remark"]) {
        vc.maxCount = 2000;
        tmpText = _project.remark;
    }
    vc.text = tmpText;
    vc.inputTitle = tmpDic[kCellDefaultText];
    vc.tipText = tmpDic[kCellDefaultText];
    vc.inputBlock = ^(NSString *text, NSString *imgUrls) {
        
        if ([key isEqualToString:@"Desc"]) {
            _project.desc = text;;
        } else if ([key isEqualToString:@"Remark"]) {
            _project.remark = text;
        }
        [_tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deadLineWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
//    NSString *key = dic[kCellKey];
    if (_project.openDate != nil && ![_project.openDate isEqualToString:@""]) {
        [JAlertHelper jSheetWithTitle:@"您已选择截止时间" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"重新选择" OtherButtonsArray:@[@"删除截止时间"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                //重新选择
                [self choiceDateWithDic:dic indexPath:indexPath selectDate:_project.openDate];
            } else if (buttonIndex == 2) {
                //删除开标时间
                _project.openDate = nil;
                [self reloadIndexPath:indexPath];
            }
        }];
    } else {
        [self choiceDateWithDic:dic indexPath:indexPath selectDate:nil];
    }
}

- (void)choiceDateWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath selectDate:(NSString *)selectDate {
    BSModalDatePickerView *datePicker = [[BSModalDatePickerView alloc] initWithDate:[NSDate date]];
    datePicker.mode = UIDatePickerModeDate;
    if (selectDate != nil && ![selectDate isEmptyString]) {
        datePicker.selectedDate = [CommonUtil dateFromString:selectDate];
    }
    [datePicker presentInWindowWithBlock:^(BOOL madeChoice) {
        if (madeChoice) {
            _project.openDate = [CommonUtil stringFromDate:datePicker.selectedDate];
            [self reloadIndexPath:indexPath];
        }
    }];
}

- (void)choiceProject {
    VC_ChoiceProject *choiceProjectVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"VC_ChoiceProject"];
    choiceProjectVC.choiceProject = ^(Project *project) {
        _project = project;
        [_tableView reloadData];
    };
    [self.navigationController pushViewController:choiceProjectVC animated:YES];
    
}

- (VC_TextInput *)getVC_TextInput {
    return [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_TextInput"];
}

- (VC_TextField *)getVC_TextField {
    return [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_TextField"];
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

- (IBAction)btn_add_pressed:(id)sender {
    UserDomain *user = [CommonUtil getUserDomain];
    if (_type == 0) {
        //添加
        if (_project == nil) {
            [ProgressHUD showInfo:@"请选择项目编号" withSucc:NO withDismissDelay:2];
            return;
        }
        if ([_dbService isRepeatProjectByID:[NSString stringWithFormat:@"%@", _project.projectId] userId:user.UserId]) {
            [ProgressHUD showInfo:@"您已添加过该项目，请勿重复添加!" withSucc:NO withDismissDelay:2];
        } else {
            if ([_project.name isEmptyString]) {
                [ProgressHUD showInfo:@"请输入项目名" withSucc:NO withDismissDelay:2];
                return;
            }
            if ([_dbService addProject:_project userId:user.UserId]) {
                [ProgressHUD showInfo:@"添加成功!" withSucc:YES withDismissDelay:1];
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CProject_Refresh object:nil];
                [self goBack];
            } else {
                [ProgressHUD showInfo:@"添加失败!请稍后再试!" withSucc:NO withDismissDelay:2];
            }
        }
    } else {
        //编辑
        if ([_dbService editProject:_project]) {
            [ProgressHUD showInfo:@"修改成功" withSucc:YES withDismissDelay:1];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CProject_Detail_Refresh object:_project];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CProject_Refresh object:nil];
        } else {
            [ProgressHUD showInfo:@"修改失败!请稍后再试!" withSucc:NO withDismissDelay:2];
        }
    }
    
}
@end
