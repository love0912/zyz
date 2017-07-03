//
//  VC_OrderDetail.m
//  自由找
//
//  Created by guojie on 16/8/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_OrderDetail.h"
#import "ProductService.h"
#import "UIImageView+WebCache.h"
#import "CustomIOSAlertView.h"
#import "LPTradeView.h"

@interface VC_OrderDetail ()
{
    OrderInfoDomain *_orderInfo;
    ProductService *_productService;
    CustomIOSAlertView *_alert_pay;
}

@end

@implementation VC_OrderDetail

- (void)initData {
    _productService = [ProductService sharedService];
    
    _orderInfo = [self.parameters objectForKey:kPageDataDic];
//    _orderInfo = [[OrderInfoDomain alloc] init];
//    _orderInfo.SerialNo = @"20111092832";
//    _orderInfo.Status = @"1";
//    _orderInfo.RefundStatus = @"0";
//    _orderInfo.ProductName = @"进取型";
//    _orderInfo.ProjectName = @"日白项目";
//    _orderInfo.RefundDt = @"2011-11-11";
//    _orderInfo.ProductDescription = @"做好点";
//    _orderInfo.Price = @"6000";
//    _orderInfo.Quantity = @"6";
//    _orderInfo.Remark = @"该项目做不来";
//    ContactInfo *contact = [[ContactInfo alloc] init];
//    contact.Phone = @"121212121";
//    contact.Name = @"自由找客服12312";
//    _orderInfo.ContactInfo = contact;
//    DownloadInfo *download = [[DownloadInfo alloc] init];
//    download.Url = @"http://www.baidu.com";
//    download.AccessCode = @"1234";
//    _orderInfo.DownLoad = download;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderDetail) name:Notification_OrderDetail_Refresh object:nil];
}

- (void)refreshOrderDetail {
    [_productService getOrderDetailByID:_orderInfo.SerialNo result:^(NSInteger code, OrderInfoDomain *orderInfo) {
        if (code == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OurOrder_Refresh object:nil];
            _orderInfo = orderInfo;
            [self layoutUI];
        }
    }];
}

- (void)layoutUI {
    
    if ([_orderInfo.ProductType isEqualToString:@"2"]) {
        [_btn_download_4 setTitle:@"下载投标预算" forState:UIControlStateNormal];
        [_btn_download_finish setTitle:@"投标预算" forState:UIControlStateNormal];
    }

    
    _btn_download_4.layer.masksToBounds = YES;
    _btn_download_4.layer.cornerRadius = 5;
    
    if (IS_IPHONE_5_OR_LESS) {
        _lb_orderName.font = [UIFont systemFontOfSize:16];
        UIFont *font = [UIFont systemFontOfSize:12];
        _lb_money.font = font;
        _lb_moneyTag.font = font;
        _lb_serviceTag.font = font;
        _btn_pei.titleLabel.font = font;
        _lb_projectName.font = font;
        _lb_viewProducer.font = font;
        _lb_contactName.font = font;
        _lb_orderNumber.font = font;
        _lb_orderNumberName.font = font;
        _lb_contactPhone.font = [UIFont systemFontOfSize:10];
        _btn_call.titleLabel.font = [UIFont systemFontOfSize:9];
        _layout_padding_1_y.constant = _layout_padding_2_y.constant = 8;
    } else if (IS_IPHONE_6P) {
        [_btn_call setTitleEdgeInsets:UIEdgeInsetsMake(15, -15, -7, 0)];
        [_btn_call setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 15, -6)];
    }
    
    [_imgv_product sd_setImageWithURL:[NSURL URLWithString:_orderInfo.LogoUrl] placeholderImage:[UIImage imageNamed:@"Order_intro"]];
    _lb_orderName.text = _orderInfo.ProductName;
    _lb_orderNumber.text = _orderInfo.SerialNo;
    _lb_money.text = [NSString stringWithFormat:@"%@元/份", _orderInfo.Price];
    _lb_count.text = [NSString stringWithFormat:@"x%@", _orderInfo.Quantity];
    NSString *statusImageName = [NSString stringWithFormat:@"Order_Status_%@", _orderInfo.Status];
    [_btn_status setImage:[UIImage imageNamed:statusImageName] forState:UIControlStateDisabled];
    _lb_contactName.text = _orderInfo.ContactInfo.Name;
    _lb_contactPhone.text = _orderInfo.ContactInfo.Phone;
    
    CGFloat price = [_orderInfo.Price floatValue];
    NSInteger count = [_orderInfo.Quantity integerValue];
    _lb_total.text = [NSString stringWithFormat:@"%.f元", price * count];
    
    NSString *status = _orderInfo.Status;
    if ([status isEqualToString:@"1"]) {
        [self showNotPayView];
    } else if ([status isEqualToString:@"2"]) {
        [self showWattingHandle];
    } else if ([status isEqualToString:@"3"]) {
        [self showzyzCancelView];
    } else if ([status isEqualToString:@"4"]) {
        [self showDoingView];
    } else if ([status isEqualToString:@"5"]) {
        [self showFinishView];
    }
    
    if (_orderInfo.ProjectName != nil && ![_orderInfo.ProjectName isEmptyString]) {
        _lb_projectName.text = _orderInfo.ProjectName;
        _v_projectName_back.hidden = NO;
        _layout_contact_top.constant = 50;
    } else {
        _v_projectName_back.hidden = YES;
        _layout_contact_top.constant = 10;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jx_title = @"订单详情";
    [self zyzOringeNavigationBar];
    [self initData];
    [self layoutUI];
    
    if ([_orderInfo.ProductType isEqualToString:@"1"]) {
        [CountUtil countTechOrderDetail];
    } else if ([_orderInfo.ProductType isEqualToString:@"2"]) {
        [CountUtil countBudgeOrderDetail];
    }
}

- (void)showNotPayView {
    _v_cancel_backview.hidden = YES;
    _btn_download_4.hidden = YES;
    _v_doing_backview.hidden = YES;
    _v_viewProducer_backview.hidden = YES;
    _v_zyzCancel_backview.hidden = YES;
    
}

- (void)showWattingHandle {
    _v_cancel_backview.hidden = YES;
    _btn_download_4.hidden = YES;
    _v_pay_backview.hidden = YES;
    _v_zyzCancel_backview.hidden = YES;
    _v_viewProducer_backview.hidden = YES;
    _v_doing_backview.hidden = YES;
}

- (void)showzyzCancelView {
    _v_cancel_backview.hidden = YES;
    _btn_download_4.hidden = YES;
    _v_pay_backview.hidden = YES;
    _v_doing_backview.hidden = YES;
    _v_viewProducer_backview.hidden = YES;
    _lb_cancel_reason.text = _orderInfo.Remark;
}

- (void)showDoingView {
    _v_pay_backview.hidden = YES;
    _v_cancel_backview.hidden = YES;
    _v_doing_backview.hidden = YES;
    _v_zyzCancel_backview.hidden = YES;
}

- (void)showFinishView {
    _v_cancel_backview.hidden = YES;
    _btn_download_4.hidden = YES;
    _v_pay_backview.hidden = YES;
    _v_zyzCancel_backview.hidden = YES;
//    _btn_delete.hidden=YES;
    if ([_orderInfo.RefundStatus isEqualToString:@"0"]) {
        [_btn_refund setImage:[UIImage imageNamed:@"Order_menu_return"] forState:UIControlStateNormal];
        [_btn_refund setTitle:@"申请退款" forState:UIControlStateNormal];
    } else {
        [_btn_refund setImage:[UIImage imageNamed:@"Order_menu_view"] forState:UIControlStateNormal];
        [_btn_refund setTitle:@"查看结果" forState:UIControlStateNormal];
    }
    if ([_orderInfo.IsRecommend isEqualToString:@"1"]) {
        _btn_evaluate.enabled=NO;
        [_btn_evaluate setTitle:@"已评价" forState:UIControlStateNormal];
    }else{
        _btn_evaluate.enabled=YES;
        [_btn_evaluate setTitle:@"评价" forState:UIControlStateNormal];
    }
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

- (IBAction)btn_viewProducer_pressed:(id)sender {
//    [PageJumpHelper pushToVCID:@"VC_Producer" storyboard:Storyboard_Main parent:self];
    
    if ([_orderInfo.ProductType isEqualToString:@"1"]) {
        [CountUtil countTechViewProducer];
    } else if ([_orderInfo.ProductType isEqualToString:@"2"]) {
        [CountUtil countBudgeViewProducer];
    }
    
    
    [ProgressHUD showProgressHUDWithInfo:@""];
    [_productService getProducerByID:_orderInfo.SerialNo result:^(NSInteger code, NSArray<ProducerDomain *> *producerInfo) {
        if (code == 1 && producerInfo.count > 0) {
            [PageJumpHelper pushToVCID:@"VC_Producer" storyboard:Storyboard_Main parameters:@{kPageDataDic:_orderInfo.SerialNo} parent:self];
        } else {
            [ProgressHUD showInfo:@"我们正在为您安排制作人员，请稍后再试" withSucc:NO withDismissDelay:3];
        }
    }];
    
    
}

- (IBAction)btn_call_pressed:(id)sender {
    [CommonUtil callWithPhone:_orderInfo.ContactInfo.Phone];
}
- (IBAction)btn_cancelOrder_pressed:(id)sender {
    [JAlertHelper jSheetWithTitle:@"确定取消订单" message:nil cancleButtonTitle:@"不取消" destructiveButtonTitle:@"取消" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            //取消
            [_productService cancelOrderByID:_orderInfo.SerialNo reason:@"" result:^(NSInteger code) {
                if (code == 1) {
                    [self refreshOurSelfOrderList];
                    [ProgressHUD showInfo:@"取消成功" withSucc:YES withDismissDelay:2];
                    [self goBack];
                }
            }];
        }
    }];
}

- (IBAction)btn_pay_pressed:(id)sender {
    
//    CGFloat price = [_orderInfo.Price floatValue];
//    NSInteger count = [_orderInfo.Quantity integerValue];
//    CGFloat total = price * count;
    OrderInfoDomain *order = [[OrderInfoDomain alloc] init];
    order.SerialNo = _orderInfo.SerialNo;
    order.CouponAmount = _orderInfo.CouponAmount;
    CGFloat price = [_orderInfo.Price floatValue];
    NSInteger count = [_orderInfo.Quantity floatValue];
    order.POAmount = [NSString stringWithFormat:@"%.2f", price * count];
    [PageJumpHelper pushToVCID:@"VC_OrderSubmit" storyboard:Storyboard_Main parameters:@{kPageDataDic: order, kPageType: @2} parent:self];
    
    
//    [LPTradeView tradeViewNumberKeyboardWithMoney:[NSString stringWithFormat:@"%@", _orderInfo.POAmount] password:^(NSString *password) {
//        
////        NSLog(@"密码是:%@",password);
//        
//        [_productService payOrderByID:_orderInfo.SerialNo password:password result:^(NSInteger code) {
//            if (code == 1) {
//                //支付成功
//                //TODO: 调转至我的订单
////                [PageJumpHelper pushToVCID:@"VC_MineOrders" storyboard:Storyboard_Mine parameters:@{kPageType:@(1)} parent:self];
//                
//            }else if (code==301){//充值
//                [JAlertHelper jAlertWithTitle:@"余额不足，是否前去充值？" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
//                    if (buttonIndex == 1) {
//                        [PageJumpHelper pushToVCID:@"VC_Recharge" storyboard:Storyboard_Mine parent:self];
//                    }
//                }];
//                
//            }else if (code==302){//未开通
//                [JAlertHelper jAlertWithTitle:@"未开通钱包，是否前去开通？" message:nil cancleButtonTitle:@"否" OtherButtonsArray:@[@"是"] showInController:self clickAtIndex:^(NSInteger buttonIndex) {
//                    if (buttonIndex == 1) {
//                        [PageJumpHelper pushToVCID:@"VC_PayPass" storyboard:Storyboard_Mine parameters:@{kPageDataDic:@"1"} parent:self];
//                    }
//                }];
//                
//            }
//
//        }];
//        
//    }];
    
}
- (IBAction)btn_download4_pressed:(id)sender {
    
    NSString *title = [NSString stringWithFormat:@"您的订单还未制作完成，完成后我们会通知您下载，请耐心等待"];
    if (_orderInfo.DeliveryDt != nil && ![_orderInfo.DeliveryDt isEmptyString]) {
        title = [NSString stringWithFormat:@"我们将在%@日交付资料，请在此日期之后在该页面获取下载地址!", _orderInfo.DeliveryDt];
    }
    [JAlertHelper jAlertWithTitle:title message:nil cancleButtonTitle:@"确定" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        
    }];
}

- (IBAction)btn_downloadFinish_pressed:(id)sender {
    
    if ([_orderInfo.ProductType isEqualToString:@"1"]) {
        [CountUtil countTechDownload];
    } else if ([_orderInfo.ProductType isEqualToString:@"2"]) {
        [CountUtil countBudgeDownload];
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width - 60, 200)];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, backView.width, 20)];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.font = [UIFont systemFontOfSize:19];
    titleLabel.textColor = [UIColor colorWithHex:@"333333"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"下载提示";
    [backView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left);
        make.top.equalTo(backView.mas_top).with.offset(16);
        make.right.equalTo(backView.mas_right);
    }];
    UIFont *font;
    if (IS_IPHONE_5_OR_LESS) {
        font = [UIFont systemFontOfSize:14];
    } else {
        font = [UIFont systemFontOfSize:16];
    }
//    UILabel *downloadAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, titleLabel.origin.y + titleLabel.height + 25, backView.width - 31, 20)];
    UILabel *downloadAddressLabel = [[UILabel alloc] init];
    downloadAddressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    downloadAddressLabel.numberOfLines = 0;
    downloadAddressLabel.textColor = [UIColor colorWithHex:@"333333"];
    downloadAddressLabel.font = font;
    NSString *text = [NSString stringWithFormat:@"下载地址：%@", _orderInfo.DownLoad.Url];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"47b8ed"] range:NSMakeRange(5,text.length - 5)];
    downloadAddressLabel.attributedText = attributeString;
    [backView addSubview:downloadAddressLabel];
    [downloadAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).with.offset(31);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(25);
        make.right.equalTo(backView.mas_right).with.offset(-31);
    }];
    NSString *codeString = [NSString stringWithFormat:@"下载提取码：%@", _orderInfo.DownLoad.AccessCode];
//    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, downloadAddressLabel.origin.y + downloadAddressLabel.height + 11, backView.width - 31, 20)];
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.textColor = [UIColor colorWithHex:@"333333"];
    codeLabel.font = font;
    codeLabel.text = codeString;
    [backView addSubview:codeLabel];
    [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView.mas_left).with.offset(31);
        make.top.equalTo(downloadAddressLabel.mas_bottom).with.offset(11);
        make.right.equalTo(backView.mas_right).with.offset(-31);
    }];
    
    CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
    [alert setContainerView:backView];
    [alert setButtonTitles:@[@"取消", @"去下载"]];
    [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        if (buttonIndex == 1) {
            NSURL *url = [NSURL URLWithString:_orderInfo.DownLoad.Url];
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    [alert show];
    
}

- (IBAction)btn_delete_pressed:(id)sender {
    [JAlertHelper jSheetWithTitle:@"确定删除订单?" message:nil cancleButtonTitle:@"取消" destructiveButtonTitle:@"删除" OtherButtonsArray:nil showInController:self clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [_productService deleteProductOrderByID:_orderInfo.SerialNo productType:_orderInfo.ProductType.integerValue result:^(NSInteger code) {
                if (code == 1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OurOrder_Refresh object:nil];
                    [ProgressHUD showInfo:@"删除成功" withSucc:YES withDismissDelay:1];
                    [self goBack];
                }
            }];
        }
    }];
    
}

- (IBAction)btn_cancel_delete_pressed:(id)sender {
    [self btn_delete_pressed:nil];
}


- (IBAction)btn_refund_pressed:(id)sender {
    if ([_orderInfo.RefundStatus isEqualToString:@"0"]) {
//        [PageJumpHelper pushToVCID:@"VC_Refund" storyboard:Storyboard_Main parent:self];
        [PageJumpHelper pushToVCID:@"VC_Refund" storyboard:Storyboard_Main parameters:@{kPageDataDic: _orderInfo} parent:self];
        
    } else {
//        [PageJumpHelper pushToVCID:@"VC_RefundResult" storyboard:Storyboard_Main parent:self];
        [PageJumpHelper pushToVCID:@"VC_RefundResult" storyboard:Storyboard_Main parameters:@{kPageDataDic: _orderInfo.SerialNo} parent:self];
    }
}

- (IBAction)btn_toEvaluate_pressed:(id)sender {
//    [PageJumpHelper pushToVCID:@"VC_PublishEvaluate" storyboard:Storyboard_Main parent:self];
    [PageJumpHelper pushToVCID:@"VC_PublishEvaluate" storyboard:Storyboard_Main parameters:@{kPageDataDic: _orderInfo.SerialNo} parent:self];
}


- (void)refreshOurSelfOrderList {
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_OurOrder_Refresh object:nil];
}

@end
