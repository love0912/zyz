//
//  VC_OrderDetail.h
//  自由找
//
//  Created by guojie on 16/8/4.
//  Copyright © 2016年 zyz. All rights reserved.
//

#import "VC_Base.h"

@interface VC_OrderDetail : VC_Base

@property (weak, nonatomic) IBOutlet UILabel *lb_orderName;
@property (weak, nonatomic) IBOutlet UILabel *lb_moneyTag;
@property (weak, nonatomic) IBOutlet UILabel *lb_money;
@property (weak, nonatomic) IBOutlet UILabel *lb_count;
@property (weak, nonatomic) IBOutlet UILabel *lb_serviceTag;
@property (weak, nonatomic) IBOutlet UIButton *btn_pei;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_product;
@property (weak, nonatomic) IBOutlet UILabel *lb_orderNumber;
@property (weak, nonatomic) IBOutlet UILabel *lb_orderNumberName;
@property (weak, nonatomic) IBOutlet UIButton *btn_status;

@property (weak, nonatomic) IBOutlet UILabel *lb_contactName;
@property (weak, nonatomic) IBOutlet UILabel *lb_contactPhone;
@property (weak, nonatomic) IBOutlet UILabel *lb_viewProducer;
- (IBAction)btn_viewProducer_pressed:(id)sender;
- (IBAction)btn_refund_pressed:(id)sender;
- (IBAction)btn_toEvaluate_pressed:(id)sender;
- (IBAction)btn_call_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_call;
@property (weak, nonatomic) IBOutlet UILabel *lb_total;

@property (weak, nonatomic) IBOutlet UIView *v_cancel_backview;
//状态为执行中的时候显示的下载按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_download_4;
@property (weak, nonatomic) IBOutlet UIView *v_pay_backview;
@property (weak, nonatomic) IBOutlet UIView *v_viewProducer_backview;
@property (weak, nonatomic) IBOutlet UIView *v_doing_backview;

@property (weak, nonatomic) IBOutlet UIButton *btn_refund;
@property (weak, nonatomic) IBOutlet UIButton *btn_download_finish;
@property (weak, nonatomic) IBOutlet UIButton *btn_delete;
@property (weak, nonatomic) IBOutlet UIButton *btn_evaluate;

@property (weak, nonatomic) IBOutlet UILabel *lb_cancel_reason;
/**
 *  自由找取消显示原因的背景
 */
@property (weak, nonatomic) IBOutlet UIView *v_zyzCancel_backview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_padding_2_y;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_padding_1_y;
- (IBAction)btn_cancelOrder_pressed:(id)sender;
- (IBAction)btn_pay_pressed:(id)sender;
- (IBAction)btn_download4_pressed:(id)sender;
- (IBAction)btn_downloadFinish_pressed:(id)sender;
- (IBAction)btn_delete_pressed:(id)sender;

- (IBAction)btn_cancel_delete_pressed:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_contact_top;
@property (weak, nonatomic) IBOutlet UIView *v_projectName_back;
@property (weak, nonatomic) IBOutlet UILabel *lb_projectName;
@end
