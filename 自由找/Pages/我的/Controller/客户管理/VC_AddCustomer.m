//
//  VC_AddCustomer.m
//  自由找
//
//  Created by guojie on 16/7/6.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_AddCustomer.h"
#import "VC_TextInput.h"
#import "VC_Choice.h"
#import "VC_APList.h"
#import "CustomerService.h"
#import <AddressBook/AddressBook.h>
#import "VC_Contact.h"
#import "VC_TextField.h"
#import "InCompanyService.h"
#import "VC_AddCompany.h"
#import "InCompanyDomain.h"
@interface VC_AddCustomer ()
{
    NSArray *_arr_input;
    NSMutableDictionary *_dic_data;
    CustomerService *_customerService;
    InCompanyService *_inCompanyService;
    CompanyAptitudesDomain *_companyAptitude;

}
@end

@implementation VC_AddCustomer

- (void)initData {
    _arr_input = @[
                   @{kCellKey: kCustomerName, kCellEditType: EditType_TextField, kCellName: @"企业名称", kCellDefaultText: @"请搜索添加企业名称"},
                   @{kCellKey: kCustomerAptitudes, kCellEditType: EditType_APChoice, kCellName: @"企业资质", kCellDefaultText: @"请选择企业资质"},
                   @{kCellKey: kCustomerContact, kCellEditType: EditType_TextField, kCellName: @"联系人", kCellDefaultText: @"请输入企业联系人"},
                   @{kCellKey: kCustomerPhone, kCellEditType: EditType_TextField, kCellName: @"联系电话", kCellDefaultText: @"请输入企业联系电话"},
                   @{kCellKey: kCustomerAdress, kCellEditType: EditType_Text, kCellName: @"通讯地址", kCellDefaultText: @"请输入企业通讯地址"},
                   @{kCellKey: kCustomerCooperation, kCellEditType: EditType_RegionChoice, kCellName: @"合作情况", kCellDefaultText: @"请选择合作情况"},
                   @{kCellKey: kCustomerProfessionalDesc, kCellEditType: EditType_Text, kCellName: @"专业人员情况", kCellDefaultText: @"请输入专业人员情况"},
                   @{kCellKey: kCustomerRemark, kCellEditType: EditType_Text, kCellName: @"备注", kCellDefaultText: @"请输入备注"},
                   ];
    _dic_data = [NSMutableDictionary dictionaryWithCapacity:_arr_input.count];
    _customerService = [CustomerService sharedService];
    _inCompanyService=[InCompanyService sharedService];
    _type = [[self.parameters objectForKey:kPageType] integerValue];
    if (_type == 1) {
        //编辑
        _dic_data = [NSMutableDictionary dictionaryWithDictionary:[self.parameters objectForKey:kPageDataDic]];
    }
    
}

- (void)layoutUI {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"导入联系人" style:UIBarButtonItemStylePlain target:self action:@selector(toContactVC)];
    [self setNavigationBarRightItem:rightItem];
    
    if (_type == 0) {
        self.jx_title = @"增加客户";
    } else {
        self.jx_title = @"编辑客户";
    }
    [self hideTableViewFooter:_tableView];
}

- (void)toContactVC {
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
            [_dic_data setObject:name forKey:kCustomerContact];
            [_dic_data setObject:phone forKey:kCustomerPhone];
            NSIndexPath *nameIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            NSIndexPath *phoneIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [_tableView reloadRowsAtIndexPaths:@[nameIndexPath, phoneIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [self.navigationController pushViewController:vc_contact animated:YES];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}


#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_input.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell_AddCustomer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
    NSString *key = tmpDic[kCellKey];
    NSString *text = tmpDic[kCellDefaultText];
    cell.textLabel.text = tmpDic[kCellName];
    UIColor *detailTextColor = [UIColor colorWithHex:@"bbbbbb"];
    NSString *editType = tmpDic[kCellEditType];
    if ([EditType_Text isEqualToString:editType] || [EditType_TextField isEqualToString:editType]) {
        if (_dic_data[key] != nil && ![_dic_data[key] isEmptyString]) {
            text = _dic_data[key];
            detailTextColor = [UIColor colorWithHex:@"666666"];
        }
    } else if ([EditType_APChoice isEqualToString:editType]) {
        NSArray *tmpArray = _dic_data[key];
        if (tmpArray != nil && tmpArray.count > 0) {
            text = [NSString stringWithFormat:@"已选择%d项资质", tmpArray.count];
            detailTextColor = [UIColor colorWithHex:@"666666"];
        }
    } else if ([EditType_RegionChoice isEqualToString:editType]) {
        if (_dic_data[key] != nil && ![_dic_data[key] isEmptyString]) {
            text = [CommonUtil cooperationValueForKey:_dic_data[key]];
            detailTextColor = [UIColor colorWithHex:@"666666"];
        }
    }
    cell.detailTextLabel.text = text;
    cell.detailTextLabel.textColor = detailTextColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *tmpDic = [_arr_input objectAtIndex:indexPath.row];
    NSString *editType = tmpDic[kCellEditType];
    if ([EditType_Text isEqualToString:editType]) {
        [self textInputedDic:tmpDic indexPath:indexPath];
    } else if ([EditType_TextField isEqualToString:editType]) {
        [self textFieldWithDic:tmpDic indexPath:indexPath];
    } else if ([EditType_APChoice isEqualToString:editType]) {
        [self APWithDic:tmpDic indexPath:indexPath];
    } else if ([EditType_RegionChoice isEqualToString:editType]) {
        //选择框
        [self cooperationTypeWithDic:tmpDic indexPath:indexPath];
    }
}

- (void)textInputedDic:(NSDictionary *)tmpDic indexPath:(NSIndexPath *)indexPath {
    VC_TextInput *vc = [self getVC_TextInput];
    vc.type = 0;
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
    if ([tmpDic[kCellKey] isEqualToString:kCustomerPhone]) {
        vc.type = INPUT_TYPE_NUMBER;
        vc.maxCount = 20;
    }
    
    NSString *text = _dic_data[tmpDic[kCellKey]];
    if (text != nil && ![text.trimWhitesSpace isEmptyString]) {
        vc.text = text.trimWhitesSpace;
    }
    vc.jTitle = tmpDic[kCellDefaultText];
    vc.placeholder = tmpDic[kCellDefaultText];
    vc.inputBlock = ^(NSString *text) {
        [_dic_data setObject:text forKey:tmpDic[kCellKey]];
        [self reloadIndexPath:indexPath];
        if ([kCustomerName isEqualToString:tmpDic[kCellKey]] && _type==0) {
            NSDictionary *paramDic=@{kCompanyName:text,kPage:@(1)};
            [_inCompanyService inCompanywithParamters:paramDic result:^(NSArray<InCompanyDomain *> *user, NSInteger code) {
                if (code != 1) {
                    return ;
                }
                if (user.count>0) {
                    VC_AddCompany *vc_AddCompany =[self.storyboard instantiateViewControllerWithIdentifier:@"VC_AddCompany"];
                    NSDictionary *dic=@{kCompanyName:text};
                    vc_AddCompany.parameters=@{kPageDataDic:dic, kPageType: @(_type+2),kContainAptitudes:@(1)};
                    vc_AddCompany.AddCompanyBlock2=^(BaseDomain *companyDomain){
                        InCompanyDomain *company = (InCompanyDomain *)companyDomain;
                        NSArray *companyarr = company.CompanyAptitudes;
                        if (companyarr.count>0) {
                            
                            NSMutableArray *array=[[NSMutableArray alloc]init];
                            for (int i=0; i<companyarr.count; i++) {
                                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                                _companyAptitude=[companyarr objectAtIndex:i];
                                [dic setObject:_companyAptitude.AptitudeKey forKey:kCommonKey];
                                NSString *valueString=[NSString stringWithFormat:@"%@/%@",_companyAptitude.AptitudeName,_companyAptitude.AptitudeGrade];
                                [dic setObject:valueString forKey:kCommonValue];
                                [dic setObject:_companyAptitude.AptitudeKey forKey:kTopKey];
                                [array addObject:dic];
                            }
                            [_dic_data setObject:array forKey:kCustomerAptitudes];
                            [_dic_data setObject:company.CompanyName forKey:kCustomerName];
                            [self reloadIndexPath:indexPath];
                            [self reloadIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];

                        }
                    };
                    [self.navigationController pushViewController:vc_AddCompany animated:YES];
                    
                }
            }];
            
        }

    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)cooperationTypeWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
    NSArray *arr_coo = [CommonUtil getCooperationData];
    VC_Choice *vc_choice = [[UIStoryboard storyboardWithName:Storyboard_Main bundle:nil] instantiateViewControllerWithIdentifier:@"VC_Choice"];
    NSMutableArray *selectArray = [NSMutableArray array];
    NSString *key = dic[kCellKey];
    if (_dic_data[key] != nil) {
        [selectArray addObject:_dic_data[key]];
    }
    [vc_choice setDataArray:arr_coo selectArray:selectArray];
    vc_choice.choiceBlock = ^(NSDictionary *resultDic) {
        [_dic_data setObject:resultDic[kCommonKey] forKey:key];
        [self reloadIndexPath:indexPath];
    };
    [self.navigationController pushViewController:vc_choice animated:YES];
}

- (void)APWithDic:(NSDictionary *)dic indexPath:(NSIndexPath *)indexPath {
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

- (IBAction)btn_save_pressed:(id)sender {
    if ([self checkMustInput]) {
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:_dic_data];
//        NSDictionary *cooDic = paramDic[kCustomerCooperation];
//        if (cooDic != nil) {
//            [paramDic setObject:cooDic[kCommonKey] forKey:kCustomerCooperation];
//        }
        __block VC_AddCustomer *weakSelf = self;
        
        if (_type == 0) {
            [_customerService addCustomerUserWithParameters:paramDic result:^(NSInteger code) {
                if (code == 1) {
                    [ProgressHUD showInfo:@"添加成功" withSucc:YES withDismissDelay:1];
                    [weakSelf goBack];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Customer_Refresh object:nil];
                }
            }];
        } else {
            [_customerService editCustomerWithParameters:paramDic result:^(NSInteger code) {
                if (code == 1) {
                    [ProgressHUD showInfo:@"修改成功" withSucc:YES withDismissDelay:1];
                    [weakSelf goBack];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Customer_Detail_Refresh object:nil];
                }
            }];
        }
        
    }
}

- (BOOL)checkMustInput {
    if (_dic_data[kCustomerName] == nil || [_dic_data[kCustomerName] isEmptyString]) {
        [ProgressHUD showInfo:@"请输入企业名称" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
}
@end
