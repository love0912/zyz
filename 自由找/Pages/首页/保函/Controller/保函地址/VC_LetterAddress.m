//
//  VC_LetterAddress.m
//  自由找
//
//  Created by 郭界 on 16/10/13.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_LetterAddress.h"
#import "LetterAddressDomain.h"
#import "JAddressPicker.h"
#import "LetterAddressService.h"
#import "RXJDAddressPickerView.h"

@interface VC_LetterAddress ()
{
    /**
     * 0 - 从下单页面第一次输入地址
     * 1 - 从地址列表页点击新建
     * 2 - 编辑地址
     */
    NSInteger _type;
    
    LetterAddressDomain *_letterAddress;
    LetterAddressService *_addressService;
    
    /*
     0 -- 允许删除， 1 -- 不允许删除，必须保留一个收货地址
     */
    NSInteger _deleteType;
}

@property (nonatomic,strong) JAddressPicker *regionPickerView;

@end

@implementation VC_LetterAddress

- (void)initData {
    _type = [[self.parameters objectForKey:kPageType] integerValue];
    _deleteType = [[self.parameters objectForKey:@"Delete_Type"] integerValue];
    if (_type == 2) {
        _letterAddress = [self.parameters objectForKey:kPageDataDic];
        _btn_delete.hidden = NO;
    } else {
        _letterAddress = [[LetterAddressDomain alloc] init];
    }
    
    _addressService = [LetterAddressService sharedService];
}

- (void)layoutUI {
    if (_letterAddress != nil) {
        _tf_name.text = _letterAddress.Recipient;
        _tf_phone.text = _letterAddress.Phone;
        _tv_address.text = _letterAddress.Street;
        _lb_address.text = [_letterAddress.District stringByReplacingOccurrencesOfString:@"," withString:@""];
        _lb_addressTips.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"编辑保函地址";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    _lb_addressTips.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text.trimWhitesSpace isEqualToString:@""]) {
        _lb_addressTips.hidden = NO;
    }
}


- (IBAction)btn_choiceAddress_pressed:(id)sender {
    [self.view endEditing:YES];
//    NSString *province = @"";//省
//    NSString *city = @"";//市
//    NSString *county = @"";//县
//    if (_letterAddress.District != nil && ![_letterAddress.District isEmptyString]) {
////        NSArray *array = [_letterAddress.District componentsSeparatedByString:@","];
////        if (array.count > 2) {
////            province = array[0];
////            city = array[1];
////            county = array[2];
////        } else if (array.count > 1) {
////            province = array[0];
////            city = array[1];
////        } else if (array.count > 0) {
////            province = array[0];
////        }
//        [RXJDAddressPickerView showWithSelectArea:_letterAddress.District completion:^(NSString *address, NSString *addressCode) {
//            
//        }];
//    } else {
//        
//    }
//    [self.regionPickerView showPickerWithProvinceName:province cityName:city countyName:county];
    NSString *selectArea = _letterAddress.District;
    if (selectArea == nil) {
        selectArea = @"";
    }
    __weak typeof(self) wself = self;
    __block LetterAddressDomain *weakLetter = _letterAddress;
    [RXJDAddressPickerView showWithSelectArea:selectArea completion:^(NSString *address, NSString *addressCode) {
        NSString *choiceCity = [address stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (_type == 2) {
            wself.tv_address.text = [wself.tv_address.text stringByReplacingOccurrencesOfString:wself.lb_address.text withString:choiceCity];
        }
        weakLetter.District = [address stringByReplacingOccurrencesOfString:@" " withString:@","];
        wself.lb_address.text = choiceCity;
        [wself.tv_address becomeFirstResponder];
    }];
}

- (JAddressPicker *)regionPickerView {
    if (!_regionPickerView) {
        _regionPickerView = [[JAddressPicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        __weak typeof(self) wself = self;
        __block LetterAddressDomain *weakLetter = _letterAddress;
        _regionPickerView.completion = ^(NSString *provinceName,NSString *cityName,NSString *countyName) {
            __strong typeof(wself) self = wself;
            if (_type == 2) {
                wself.tv_address.text = [wself.tv_address.text stringByReplacingOccurrencesOfString:wself.lb_address.text withString:[NSString stringWithFormat:@"%@%@%@", provinceName, cityName, countyName]];
            }
            weakLetter.District = [NSString stringWithFormat:@"%@,%@,%@", provinceName, cityName, countyName];
            self.lb_address.text = [NSString stringWithFormat:@"%@%@%@",provinceName,cityName,countyName];
            
            [wself.tv_address becomeFirstResponder];
        };
        [self.navigationController.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)checkInput {
    if ([_tf_name.text.trimWhitesSpace isEmptyString]) {
        [ProgressHUD showInfo:@"请输入收保函人" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if ([_tf_phone.text.trimWhitesSpace isEmptyString]) {
        [ProgressHUD showInfo:@"请输入联系电话" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if (_letterAddress.District == nil || [_letterAddress.District isEmptyString]) {
        [ProgressHUD showInfo:@"请选择所在地区" withSucc:NO withDismissDelay:2];
        return NO;
    }
    if ([_tv_address.text.trimWhitesSpace isEmptyString]) {
        [ProgressHUD showInfo:@"请输入详细地址" withSucc:NO withDismissDelay:2];
        return NO;
    }
    return YES;
}

- (IBAction)btn_save_pressed:(id)sender {
    if ([self checkInput]) {
        _letterAddress.Recipient = _tf_name.text.trimWhitesSpace;
        _letterAddress.Phone = _tf_phone.text.trimWhitesSpace;
        if (_type == 2) {
            _letterAddress.Street = _tv_address.text;
        } else {
            _letterAddress.Street = [NSString stringWithFormat:@"%@%@", _lb_address.text, _tv_address.text];
        }
        _letterAddress.ZipCode = @"";
        __block VC_LetterAddress *weakSelf = self;
        if (_type == 0) {
            [_addressService addAddressByAddressDomain:_letterAddress result:^(NSInteger code) {
                if (code == 1) {
                    
                    [CountUtil countBidLetterCreateAddress];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_Submit_Letter_Order" object:nil];
                    [weakSelf goBack];
                }
            }];
        } else if (_type == 1) {
            [_addressService addAddressByAddressDomain:_letterAddress result:^(NSInteger code) {
                if (code == 1) {
                    [ProgressHUD showInfo:@"添加成功" withSucc:YES withDismissDelay:2];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LetterAddress_Refresh object:nil];
                    [weakSelf goBack];
                }
            }];
        } else {
            [_addressService editAddressByAddressDomain:_letterAddress result:^(NSInteger code) {
                if (code == 1) {
                    [ProgressHUD showInfo:@"修改成功" withSucc:YES withDismissDelay:2];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LetterAddress_Refresh object:nil];
                    [weakSelf goBack];
                }
            }];
        }
    }
}

- (IBAction)btn_delete_pressed:(id)sender {
    if (_deleteType == 1) {
        [JAlertHelper jAlertWithTitle:@"必须保留一个收取保函地址" message:@"请新增后再删除或者直接编辑地址" cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
            
        }];
        return;
    }
    
    [JAlertHelper jAlertWithTitle:@"是否删除该地址" message:nil cancleButtonTitle:@"取消" OtherButtonsArray:@[@"删除"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            __block VC_LetterAddress *weakSelf = self;
            [_addressService deleteAddressByID:_letterAddress.OId result:^(NSInteger code) {
                if (code == 1) {
                    [ProgressHUD showInfo:@"删除成功" withSucc:YES withDismissDelay:2];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LetterAddress_Refresh object:nil];
                    [weakSelf goBack];
                }
            }];
        }
    }];
}
@end
