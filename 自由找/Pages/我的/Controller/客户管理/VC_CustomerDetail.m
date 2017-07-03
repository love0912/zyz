//
//  VC_CustomerDetail.m
//  自由找
//
//  Created by guojie on 16/7/7.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_CustomerDetail.h"
#import "CustomerService.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Cell_CustomerDetail.h"

@interface VC_CustomerDetail ()
{
    NSMutableDictionary *_dic_partnerDetail;
    NSMutableArray *_arr_partnerDetail;
    CustomerService *_customerService;
}
@end

@implementation VC_CustomerDetail

- (void)initData {
    _customerService = [CustomerService sharedService];
    _dic_partnerDetail = [NSMutableDictionary dictionary];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:Notification_Customer_Detail_Refresh object:nil];
    
    _CustomerId = [self.parameters objectForKey:kPageDataDic];
    [self requestPartnerDetail];
}

- (void)layoutUI {
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 0.1)];
    self.tableView.tableHeaderView = tableHeaderView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"查看详情";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

- (void)refresh {
    [_arr_partnerDetail removeAllObjects];
    [self requestPartnerDetail];
}

- (void)requestPartnerDetail {
    [_customerService queryCustomerDetailWithCustomerID:_CustomerId result:^(NSDictionary *custemerInfo, NSInteger code) {
        if (code == 1) {
            [_dic_partnerDetail setDictionary:custemerInfo];
            [self handleData];
        }
    }];
}

- (void)handleData {
    if (_arr_partnerDetail == nil) {
        _arr_partnerDetail = [NSMutableArray arrayWithCapacity:0];
    }
    
    NSMutableArray *arrGroup1 = [NSMutableArray array];
    
    [arrGroup1 addObject:@{kCellName: @"企业名称", kCellDefaultText: _dic_partnerDetail[kCustomerName]}];
    
    NSMutableString *EntQualifications2 = [NSMutableString string];
    NSArray *tmpArray_1 = _dic_partnerDetail[kCustomerAptitudes];
    if (tmpArray_1.count > 0) {
        for (int i = 0; i < tmpArray_1.count; i++) {
            NSDictionary *tmpDic = tmpArray_1[i];
            if (i > 0) {
                [EntQualifications2 appendString:@"\n"];
            }
            [EntQualifications2 appendString:tmpDic[kCommonValue]];
        }
        [arrGroup1 addObject:@{kCellName: @"企业资质", kCellDefaultText: EntQualifications2}];
    } else {
        [arrGroup1 addObject:@{kCellName: @"企业资质", kCellDefaultText: NoneText}];
    }
    
    NSMutableArray *arrGroup2 = [NSMutableArray array];
    NSString *contact = _dic_partnerDetail[kCustomerContact];
    if ([contact isEmptyString]) {
        contact = NoneText;
    }
    
    [arrGroup2 addObject:@{kCellName: @"联系人", kCellDefaultText: contact}];
    NSString *phone = _dic_partnerDetail[kCustomerPhone];
    if ([phone isEmptyString]) {
        phone = NoneText;
    }
    [arrGroup2 addObject:@{kCellName: @"联系电话", kCellDefaultText: phone}];
    _Phone = phone;
    
    NSMutableArray *arrGroup3 = [NSMutableArray array];
    NSString *cooperation = _dic_partnerDetail[kCustomerCooperation];
    if ([cooperation isEqualToString:@"1"]) {
        [arrGroup3 addObject:@{kCellName: @"合作情况", kCellDefaultText: @"优"}];
    } else if ([cooperation isEqualToString:@"2"]) {
        [arrGroup3 addObject:@{kCellName: @"合作情况", kCellDefaultText: @"良"}];
    } else if ([cooperation isEqualToString:@"8"]) {
        [arrGroup3 addObject:@{kCellName: @"合作情况", kCellDefaultText: @"差"}];
    } else {
        [arrGroup3 addObject:@{kCellName: @"合作情况", kCellDefaultText: NoneText}];
    }
    
    NSString *address = _dic_partnerDetail[kCustomerAdress];
    if ([address isEmptyString]) {
        address = NoneText;
    }
    [arrGroup3 addObject:@{kCellName: @"通讯地址", kCellDefaultText: address}];
    
    NSString *professional = _dic_partnerDetail[kCustomerProfessionalDesc];
    if ([professional isEmptyString]) {
        professional = NoneText;
    }
    [arrGroup3 addObject:@{kCellName: @"专业人员", kCellDefaultText: professional}];
    
    NSString *remark = _dic_partnerDetail[@"Remark"];
    if ([remark isEmptyString]) {
        remark = NoneText;
    }
    [arrGroup3 addObject:@{kCellName: @"备注", kCellDefaultText: remark}];
    
    [_arr_partnerDetail addObject:arrGroup1];
    [_arr_partnerDetail addObject:arrGroup2];
    [_arr_partnerDetail addObject:arrGroup3];
    [_tableView reloadData];
}


#pragma mark - tableview {
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arr_partnerDetail.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_arr_partnerDetail objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"Cell_CustomerDetail" cacheByIndexPath:indexPath configuration:^(Cell_CustomerDetail *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    if (height < 48) {
        height = 48;
    }
    return height;
}

- (void)configureCell:(Cell_CustomerDetail *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    [cell configureCellWithDic:_arr_partnerDetail[indexPath.section][indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell_CustomerDetail *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_CustomerDetail"];
    [cell configureCellWithDic:_arr_partnerDetail[indexPath.section][indexPath.row]];
    return cell;
}

- (IBAction)btn_delete_pressed:(id)sender
{
    [JAlertHelper jSheetWithTitle:@"确定删除该项目?" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"删除" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [_customerService deleteCustomerDetailWithCustomerID:_CustomerId result:^(NSInteger code) {
                if (code == 1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Customer_Refresh object:nil];
                    [self goBack];
                }
            }];
        }
    }];
}

- (IBAction)btn_call_pressed:(id)sender
{
    if (![_Phone isEqualToString:NoneText]) {
        [CommonUtil callWithPhone:_Phone];
    } else {
        [ProgressHUD showInfo:@"您未输入电话" withSucc:NO withDismissDelay:2];
    }
}

- (IBAction)btn_edit_pressed:(id)sender
{
    NSDictionary *tmpDic = @{kPageType: @(1), kPageDataDic: _dic_partnerDetail};
    [PageJumpHelper pushToVCID:@"VC_AddCustomer" storyboard:Storyboard_Mine parameters:tmpDic parent:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
