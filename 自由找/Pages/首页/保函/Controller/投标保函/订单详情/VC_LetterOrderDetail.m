//
//  VC_LetterOrderDetail.m
//  自由找
//
//  Created by 郭界 on 16/10/14.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_LetterOrderDetail.h"
#import "LetterOrderDetailDomain.h"
#import "OrderInfoDomain.h"
#import "LetterAddressService.h"
#import "LetterService.h"
#import <UIImageView+WebCache.h>

@interface VC_LetterOrderDetail ()
{
    LetterOrderDetailDomain *_orderDetailInfo;
    LetterAddressService *_letterAddressService;
    LetterService *_letterService;
}
@end

@implementation VC_LetterOrderDetail

- (void)initData {
    _letterAddressService = [LetterAddressService sharedService];
    _letterService = [LetterService sharedService];
    
    _orderDetailInfo = [self.parameters objectForKey:kPageDataDic];
    
//    _orderDetailInfo = [[LetterOrderDetailDomain alloc] init];
//    _orderDetailInfo.OrderNo = @"zyz100982838";
//    _orderDetailInfo.ProjectName = @"重庆两江新区市政工程";
//    _orderDetailInfo.ProductName = @"浦发银行投标保函";
//    _orderDetailInfo.Status = @"6";
//    _orderDetailInfo.PayMode = @"1";
//    _orderDetailInfo.PayParameter = @"0.004";
//    _orderDetailInfo.Quantity = @"2";
//    _orderDetailInfo.PayFee = @"3500";
//    _orderDetailInfo.LogoUrl = @"";
//    _orderDetailInfo.ContactInfo = [ContactInfo domainWithObject:@{@"Phone":@"17799998888", @"Name": @"大锤"}];
//    _orderDetailInfo.Remark = @"不符合规定";
//    _orderDetailInfo.Tracking = [Tracking domainWithObject:@{@"No": @"20192873", @"Carrier": @"顺丰"}];
//    _orderDetailInfo.IsRecommend = @"0";
//    _orderDetailInfo.ProductType = @"3";
}

- (void)layoutUI {
    [self layoutStatus];
//    [self fillData];
    [_btn_status layoutIfNeeded];
    CGRect rect = _btn_status.frame;
    _layout_lbOrderNo_right.constant = rect.size.width + 23;
//    if (IS_IPHONE_5_OR_LESS) {
//        UIFont *font = [UIFont systemFontOfSize:11];
//        _lb_orderNo.font = font;
//        
//        
////        NSLog(@"%@", NSStringFromCGRect(rect));
//    }
    
    _layout_scrollContent_width.constant = SCREEN_WIDTH;
    if (IS_IPHONE_5_OR_LESS) {
        _layout_scrollContent_height.constant = 600;
    }
}

- (void)layoutStatus {
    _v_notPay_back.hidden = YES;
    _v_normal_back.hidden = YES;
    _v_normak_back_menu.hidden = YES;
    _v_return_back.hidden = YES;
    _btn_toUpload.hidden = YES;
    
    if ([_orderDetailInfo.Status isEqualToString:@"1"]) {
        //代付款
        _v_notPay_back.hidden = NO;
    } else if ([_orderDetailInfo.Status isEqualToString:@"2"]) {
      //处理中
    } else if ([_orderDetailInfo.Status isEqualToString:@"3"]) {
        //取消
        _v_return_back.hidden = NO;
    } else if ([_orderDetailInfo.Status isEqualToString:@"4"]) {
        //执行中
    } else if ([_orderDetailInfo.Status isEqualToString:@"5"]) {
        //完成
        _v_normal_back.hidden = NO;
        _v_normak_back_menu.hidden = NO;
    } else if ([_orderDetailInfo.Status isEqualToString:@"6"]) {
        _btn_toUpload.hidden = NO;
    }
    
    NSString *statusImageName = [NSString stringWithFormat:@"LetterStatus_%@", _orderDetailInfo.Status];
    [_btn_status setImage:[UIImage imageNamed:statusImageName] forState:UIControlStateDisabled];
    if ([_orderDetailInfo.IsRecommend isEqualToString:@"1"]) {
        _btn_evaluate.enabled=NO;
        [_btn_evaluate setTitle:@"已评价" forState:UIControlStateNormal];
    }else{
        _btn_evaluate.enabled=YES;
        [_btn_evaluate setTitle:@"评价" forState:UIControlStateNormal];
    }
    
    [self fillData];
}

- (void)fillData {
    _lb_orderNo.text = [NSString stringWithFormat:@"订单号：%@", _orderDetailInfo.OrderNo];
    _lb_name.text = _orderDetailInfo.ProductName;
//    [_iv_logo sd_setImageWithURL:[NSURL URLWithString:_orderDetailInfo.LogoUrl]];
    
    [_iv_logo sd_setImageWithURL:[NSURL URLWithString:[_orderDetailInfo.LogoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [_iv_background sd_setImageWithURL:[NSURL URLWithString:[_orderDetailInfo.LogoBackgroundUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"bidLetterBackground"]];
    NSString *bankCity = [NSString stringWithFormat:@"%@", _orderDetailInfo.SubBank];
    _lb_city.text = bankCity;
    
    if ([_orderDetailInfo.PayMode isEqualToString:@"1"]) {
        _lb_priceTag.text = @"费率";
        CGFloat price = _orderDetailInfo.PayParameter.floatValue * 100;
        NSString *test = [NSString stringWithFormat:@"%f", price];
        NSString *value = [CommonUtil removeFloatAllZero:test];
        _lb_price.text = [NSString stringWithFormat:@"%@%%", value];
    } else {
        _lb_priceTag.text = @"价格";
        _lb_price.text = [NSString stringWithFormat:@"%@元", [CommonUtil removeFloatAllZero:_orderDetailInfo.PayParameter]];

    }
    _lb_count.text = [NSString stringWithFormat:@"x %@", _orderDetailInfo.Quantity];
    _lb_totalPrice.text = [NSString stringWithFormat:@"保函费用：￥%@元", [CommonUtil removeFloatAllZero:_orderDetailInfo.PayFee]];
    
    _lb_contactName.text = _orderDetailInfo.ContactInfo.Name;
    _lb_contactPhone.text = _orderDetailInfo.ContactInfo.Phone;
    
    _lb_returnReason.text = _orderDetailInfo.CancelRemark;
    
    _lb_trackingNo.text = _orderDetailInfo.Tracking.No;
    _lb_trackingName.text = _orderDetailInfo.Tracking.Carrier;
    
    _lb_remark.text = (_orderDetailInfo.Remark == nil || [_orderDetailInfo.Remark isEmptyString]) ? @"无" : _orderDetailInfo.Remark;
    _lb_projectName.text = (_orderDetailInfo.ProjectTitle == nil || [_orderDetailInfo.ProjectTitle isEmptyString]) ? @"无" : _orderDetailInfo.ProjectTitle;
    NSString *money = @"无";
    if (_orderDetailInfo.PerAmount != nil) {
        CGFloat fMoney = [_orderDetailInfo.PerAmount floatValue];
        fMoney = fMoney / 10000;
        NSString *moneyString = [NSString stringWithFormat:@"%f", fMoney];
        money = [NSString stringWithFormat:@"%@万", [CommonUtil removeFloatAllZero:moneyString]];
    }
    _lb_letterMoney.text = money;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"订单详情";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLetterDetailByOrderID) name:@"Notification_Refresh_LetterDetail" object:nil];
}

- (void)getLetterDetailByOrderID {
    [_letterService getLetterOrderDetailByOrderNo:_orderDetailInfo.OrderNo result:^(NSInteger code, LetterOrderDetailDomain *orderDetail) {
        if (code == 1) {
            _orderDetailInfo = orderDetail;
            [self layoutStatus];
        }
    }];
}

- (void)deleteOrder {
    [_letterService deleteBidLetterOrderByID:_orderDetailInfo.OrderNo result:^(NSInteger code) {
        if (code == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OurOrder_Refresh object:nil];
            [ProgressHUD showInfo:@"删除成功" withSucc:YES withDismissDelay:1];
            [self goBack];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)btn_call_pressed:(id)sender {
    [CommonUtil callWithPhone:_orderDetailInfo.ContactInfo.Phone];
}

- (IBAction)btn_toUpload_pressed:(id)sender {
//    [PageJumpHelper pushToVCID:@"VC_UploadData" storyboard:Storyboard_Main parameters:@{kPageType: @2, @"Letter_Type":_orderDetailInfo.BaoHanStyle, kPageDataDic: _orderDetailInfo.OrderNo} parent:self];
    
    [PageJumpHelper pushToVCID:@"VC_BidLetterProjectInfo" storyboard:Storyboard_Main parameters:@{kPageDataDic: _orderDetailInfo} parent:self];
}

- (IBAction)btn_returnDelete_pressed:(id)sender {
    [JAlertHelper jSheetWithTitle:@"确定删除订单?" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"删除" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self deleteOrder];
        }
    }];
}

- (IBAction)btn_cancel_pressed:(id)sender {
    [JAlertHelper jSheetWithTitle:@"订单还未支付，是否删除?" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"删除" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self deleteOrder];
        }
    }];
}

- (IBAction)btn_toPay_pressed:(id)sender {
    if (_orderDetailInfo.AddressInfo != nil) {
        LetterAddressDomain *letterAddress = [LetterAddressDomain domainWithObject:_orderDetailInfo.AddressInfo];
        [PageJumpHelper pushToVCID:@"VC_CommitLetter" storyboard:Storyboard_Main parameters:@{kPageType:@2, kPageDataDic: letterAddress, @"Order_ID": _orderDetailInfo.OrderNo, @"Pay_Fee": _orderDetailInfo.PayFee, @"OrderDetail_Info": _orderDetailInfo} parent:self];
    }
    
    
//    [_letterAddressService getOurDefaultAddressToResult:^(NSInteger code, LetterAddressDomain *letterAddress) {
//        [PageJumpHelper pushToVCID:@"VC_CommitLetter" storyboard:Storyboard_Main parameters:@{kPageType:@2, kPageDataDic: letterAddress, @"Order_ID": _orderDetailInfo.OrderNo, @"Pay_Fee": _orderDetailInfo.PayFee, @"OrderDetail_Info": _orderDetailInfo} parent:self];
//    }];
}

- (IBAction)btn_finishDelete_pressed:(id)sender {
    [JAlertHelper jSheetWithTitle:@"确定删除订单?" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"删除" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self deleteOrder];
        }
    }];
}

- (IBAction)btn_evaluate_pressed:(id)sender {
    [PageJumpHelper pushToVCID:@"VC_PublishEvaluate" storyboard:Storyboard_Main parameters:@{kPageDataDic: _orderDetailInfo.OrderNo, kPageType: @3} parent:self];
}
@end
