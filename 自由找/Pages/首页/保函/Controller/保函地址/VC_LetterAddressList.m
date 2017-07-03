//
//  VC_LetterAddressList.m
//  自由找
//
//  Created by 郭界 on 16/10/13.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_LetterAddressList.h"
#import "LetterAddressService.h"

@interface VC_LetterAddressList ()
{
    LetterAddressService *_addressService;
    NSMutableArray *_arr_address;
}
@end

@implementation VC_LetterAddressList

- (void)initData {
    _addressService = [LetterAddressService sharedService];
    [self refreshAddress];
}

- (void)layoutUI {
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddress) name:Notification_LetterAddress_Refresh object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"收取保函地址";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}

- (void)refreshAddress {
    [_addressService getOurAddressListToResult:^(NSInteger code, NSArray<LetterAddressDomain *> *list) {
        if (code == 1 && list != nil) {
            _arr_address = [NSMutableArray arrayWithArray:list];
            [_tableView reloadData];
        }
    }];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_address.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"Cell_Address";
    Cell_Address *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    cell.delegate = self;
//    LetterAddressDomain *address = [[LetterAddressDomain alloc] init];
//    address.Recipient = @"郭界";
//    address.Phone = @"17708347776";
//    address.Street = @"重庆市合川区东海龙宫A区B座家是哪里对李娜的是发哦送佛额外啊是的哦嗷嗷哦啊哦啊";
//    address.IsDefault = @"0";
//    if (indexPath.row == 3) {
//        address.IsDefault = @"1";
//    }
    
    LetterAddressDomain *address = [_arr_address objectAtIndex:indexPath.row];
    cell.address = address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LetterAddressDomain *address = [_arr_address objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_Change_Address" object:address];
    [self goBack];
}

#pragma mark - cell delegate
- (void)handleWithAddress:(LetterAddressDomain *)address type:(NSInteger)type {
    if (type == 1) {
        //编辑
        [self editAddress:address];
    } else if (type == 2) {
        //删除
        [self deleteAddress:address];
    } else {
        //设为默认
        [self setDefaultAddress:address];
    }
}

- (void)editAddress:(LetterAddressDomain *)address {
    NSInteger deleteType = 1;
    if (_arr_address.count > 1) {
        deleteType = 0;
    }
    
    [PageJumpHelper pushToVCID:@"VC_LetterAddress" storyboard:Storyboard_Main parameters:@{kPageType: @2, kPageDataDic: address, @"Delete_Type": @(deleteType)} parent:self];
}

- (void)deleteAddress:(LetterAddressDomain *)address {
    if (_arr_address.count == 1) {
        [JAlertHelper jAlertWithTitle:@"必须保留一个收取保函地址" message:@"请新增后再删除或者直接编辑地址" cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            
        }];
        return;
    }
    __block VC_LetterAddressList *weakSelf = self;
    [JAlertHelper jAlertWithTitle:@"确定删除该地址？" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"删除"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [_addressService deleteAddressByID:address.OId result:^(NSInteger code) {
                if (code == 1) {
                    [ProgressHUD showInfo:@"删除成功" withSucc:YES withDismissDelay:2];
                    //刷新列表
                    [weakSelf refreshAddress];
                }
                
            }];
        }
    }];
}

- (void)setDefaultAddress:(LetterAddressDomain *)address {
    __block VC_LetterAddressList *weakSelf = self;
    [JAlertHelper jAlertWithTitle:@"是否设置该地址为默认收货地址？" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [_addressService setDefaultAddressByID:address.OId result:^(NSInteger code) {
                if (code == 1) {
                    [ProgressHUD showInfo:@"设置成功" withSucc:YES withDismissDelay:2];
                    //刷新列表
                    [weakSelf refreshAddress];
                }
                
            }];
        }
    }];
}

#pragma mark -

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
    [PageJumpHelper pushToVCID:@"VC_LetterAddress" storyboard:Storyboard_Main parameters:@{kPageType: @1} parent:self];
}
@end
